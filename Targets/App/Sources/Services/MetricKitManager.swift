import Foundation
import MetricKit
import Logging
import SentrySwift

final class MetricKitManager: NSObject, MXMetricManagerSubscriber {

    // MARK: - Properties

    private static let logger = Logger(for: MetricKitManager.self)

    private var isReceiving = false

    // MARK: - Public Methods

    func startReceiving() {
        guard !isReceiving else {
            Self.logger.warning("MetricKitManager is already receiving reports")
            return
        }

        isReceiving = true
        MXMetricManager.shared.add(self)
        Self.logger.info("Started receiving MetricKit reports")
    }

    func stopReceiving() {
        guard isReceiving else { return }

        isReceiving = false
        MXMetricManager.shared.remove(self)
        Self.logger.info("Stopped receiving MetricKit reports")
    }

    // MARK: - MXMetricManagerSubscriber

    func didReceive(_ payloads: [MXMetricPayload]) {
        Self.logger.info("Received \(payloads.count) metric payload(s)")
        for payload in payloads {
            reportMetrics(from: payload)
        }
    }

    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        Self.logger.info("Received \(payloads.count) diagnostic payload(s)")
        for payload in payloads {
            reportDiagnostics(from: payload)
        }
    }

    // MARK: - Metric Payload Processing

    private func reportMetrics(from payload: MXMetricPayload) {
        // Sentry reports scalar metrics and exit counters through enabledMetricReports.
        // Keep histograms here until the SDK supports them.
        reportAppLaunchMetrics(payload.applicationLaunchMetrics)
        reportAppResponsivenessMetrics(payload.applicationResponsivenessMetrics)
        reportCellularConditionMetrics(payload.cellularConditionMetrics)

        let breadcrumb = Breadcrumb(level: .info, category: "metrickit")
        breadcrumb.message = "Received MXMetricPayload"
        breadcrumb.setData(value: payload.timeStampBegin.description, key: "time_stamp_begin")
        breadcrumb.setData(value: payload.timeStampEnd.description, key: "time_stamp_end")
        SentrySDK.addBreadcrumb(breadcrumb)
    }

    // MARK: - App Launch Metrics

    private func reportAppLaunchMetrics(_ metrics: MXAppLaunchMetric?) {
        guard let metrics else { return }
        Self.logger.info("Reporting App Launch metrics")
        reportDurationHistogram(
            metrics.histogrammedTimeToFirstDraw,
            key: "metrickit.launch.time_to_first_draw"
        )
        reportDurationHistogram(
            metrics.histogrammedApplicationResumeTime,
            key: "metrickit.launch.resume_time"
        )
        reportDurationHistogram(
            metrics.histogrammedOptimizedTimeToFirstDraw,
            key: "metrickit.launch.optimized_time_to_first_draw"
        )
        reportDurationHistogram(
            metrics.histogrammedExtendedLaunch,
            key: "metrickit.launch.extended_launch"
        )
    }

    // MARK: - App Responsiveness Metrics

    private func reportAppResponsivenessMetrics(_ metrics: MXAppResponsivenessMetric?) {
        guard let metrics else { return }
        Self.logger.info("Reporting App Responsiveness metrics")
        reportDurationHistogram(
            metrics.histogrammedApplicationHangTime,
            key: "metrickit.responsiveness.hang_time"
        )
    }

    // MARK: - Cellular Condition Metrics

    private func reportCellularConditionMetrics(_ metrics: MXCellularConditionMetric?) {
        guard let metrics else { return }
        Self.logger.info("Reporting Cellular Condition metrics")
        reportSignalBarsHistogram(
            metrics.histogrammedCellularConditionTime,
            key: "metrickit.cellular.condition_time"
        )
    }

    // MARK: - Diagnostic Payload Processing

    private func reportDiagnostics(from payload: MXDiagnosticPayload) {
        reportCPUExceptionDiagnostics(payload.cpuExceptionDiagnostics)
        reportDiskWriteExceptionDiagnostics(payload.diskWriteExceptionDiagnostics)
        reportHangDiagnostics(payload.hangDiagnostics)
        reportCrashDiagnostics(payload.crashDiagnostics)
        reportAppLaunchDiagnostics(payload.appLaunchDiagnostics)

        let breadcrumb = Breadcrumb(level: .warning, category: "metrickit")
        breadcrumb.message = "Received MXDiagnosticPayload"
        breadcrumb.setData(value: payload.timeStampBegin.description, key: "time_stamp_begin")
        breadcrumb.setData(value: payload.timeStampEnd.description, key: "time_stamp_end")
        breadcrumb.setData(value: String(payload.cpuExceptionDiagnostics?.count ?? 0), key: "cpu_exceptions")
        breadcrumb.setData(value: String(payload.diskWriteExceptionDiagnostics?.count ?? 0), key: "disk_write_exceptions")
        breadcrumb.setData(value: String(payload.hangDiagnostics?.count ?? 0), key: "hangs")
        breadcrumb.setData(value: String(payload.crashDiagnostics?.count ?? 0), key: "crashes")
        breadcrumb.setData(value: String(payload.appLaunchDiagnostics?.count ?? 0), key: "app_launch_issues")
        SentrySDK.addBreadcrumb(breadcrumb)
    }

    // MARK: - CPU Exception Diagnostics

    private func reportCPUExceptionDiagnostics(_ diagnostics: [MXCPUExceptionDiagnostic]?) {
        guard let diagnostics else { return }
        Self.logger.info("Reporting CPU Exception diagnostics")
        SentrySDK.metrics.count("metrickit.diagnostic.cpu_exception", value: UInt(diagnostics.count))
        for diagnostic in diagnostics {
            let totalCPUTime = diagnostic.totalCPUTime.converted(to: .seconds).value
            SentrySDK.metrics.distribution("metrickit.diagnostic.cpu_exception.total_cpu_time", value: totalCPUTime, options: .init(
                unit: .second
            ))
            let totalSampledTime = diagnostic.totalSampledTime.converted(to: .seconds).value
            SentrySDK.metrics.distribution("metrickit.diagnostic.cpu_exception.total_sampled_time", value: totalSampledTime, options: .init(
                unit: .second
            ))
        }
    }

    // MARK: - Disk Write Exception Diagnostics

    private func reportDiskWriteExceptionDiagnostics(_ diagnostics: [MXDiskWriteExceptionDiagnostic]?) {
        guard let diagnostics else { return }
        Self.logger.info("Reporting Disk Write Exception diagnostics")
        SentrySDK.metrics.count("metrickit.diagnostic.disk_write_exception", value: UInt(diagnostics.count))
        for diagnostic in diagnostics {
            let totalWrites = diagnostic.totalWritesCaused.converted(to: .bytes).value
            SentrySDK.metrics.distribution("metrickit.diagnostic.disk_write_exception.total_writes", value: totalWrites, options: .init(
                unit: .byte
            ))
        }
    }

    // MARK: - Hang Diagnostics

    private func reportHangDiagnostics(_ diagnostics: [MXHangDiagnostic]?) {
        guard let diagnostics else { return }
        Self.logger.info("Reporting Hang diagnostics")
        SentrySDK.metrics.count("metrickit.diagnostic.hang", value: UInt(diagnostics.count))
        for diagnostic in diagnostics {
            let duration = diagnostic.hangDuration.converted(to: .seconds).value
            SentrySDK.metrics.distribution("metrickit.diagnostic.hang.duration", value: duration, options: .init(
                unit: .second
            ))
        }
    }

    // MARK: - Crash Diagnostics

    private func reportCrashDiagnostics(_ diagnostics: [MXCrashDiagnostic]?) {
        guard let diagnostics else { return }
        Self.logger.info("Reporting Crash diagnostics")
        SentrySDK.metrics.count("metrickit.diagnostic.crash", value: UInt(diagnostics.count))
    }

    // MARK: - App Launch Diagnostics

    private func reportAppLaunchDiagnostics(_ diagnostics: [MXAppLaunchDiagnostic]?) {
        guard let diagnostics else { return }
        Self.logger.info("Reporting App Launch diagnostics")
        SentrySDK.metrics.count("metrickit.diagnostic.app_launch", value: UInt(diagnostics.count))
        for diagnostic in diagnostics {
            let duration = diagnostic.launchDuration.converted(to: .seconds).value
            SentrySDK.metrics.distribution("metrickit.diagnostic.app_launch.duration", value: duration, options: .init(
                unit: .second
            ))
        }
    }

    // MARK: - Histogram Helpers

    private func reportDurationHistogram(
        _ histogram: MXHistogram<UnitDuration>,
        key: String
    ) {
        var totalCount = 0
        let enumerator = histogram.bucketEnumerator
        while let bucket = enumerator.nextObject() as? MXHistogramBucket<UnitDuration> {
            let startSeconds = bucket.bucketStart.converted(to: .seconds).value
            let endSeconds = bucket.bucketEnd.converted(to: .seconds).value
            let midpoint = (startSeconds + endSeconds) / 2.0
            for _ in 0..<bucket.bucketCount {
                SentrySDK.metrics.distribution(key, value: midpoint, options: .init(
                    unit: .second
                ))
            }
            totalCount += bucket.bucketCount
        }

        if totalCount > 0 {
            SentrySDK.metrics.count("\(key).count", value: UInt(totalCount))
        }
    }

    private func reportSignalBarsHistogram(
        _ histogram: MXHistogram<MXUnitSignalBars>,
        key: String
    ) {
        var totalCount = 0
        let enumerator = histogram.bucketEnumerator
        while let bucket = enumerator.nextObject() as? MXHistogramBucket<MXUnitSignalBars> {
            let midpoint = (bucket.bucketStart.value + bucket.bucketEnd.value) / 2.0
            for _ in 0..<bucket.bucketCount {
                SentrySDK.metrics.distribution(key, value: midpoint, options: .init(
                    unit: .generic("bars")
                ))
            }
            totalCount += bucket.bucketCount
        }

        if totalCount > 0 {
            SentrySDK.metrics.count("\(key).count", value: UInt(totalCount))
        }
    }

    // MARK: - Cleanup

    deinit {
        stopReceiving()
    }
}
