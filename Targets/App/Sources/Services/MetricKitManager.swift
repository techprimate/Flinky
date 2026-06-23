// swiftlint:disable file_length function_body_length type_body_length
import Foundation
import MetricKit
import os.log
import SentrySwift

final class MetricKitManager: NSObject, MXMetricManagerSubscriber {

    // MARK: - Properties

    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Flinky", category: "MetricKitManager")

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
        reportCPUMetrics(payload.cpuMetrics)
        reportGPUMetrics(payload.gpuMetrics)
        reportAppTimeMetrics(payload.applicationTimeMetrics)
        reportLocationActivityMetrics(payload.locationActivityMetrics)
        reportNetworkTransferMetrics(payload.networkTransferMetrics)
        reportAppLaunchMetrics(payload.applicationLaunchMetrics)
        reportAppResponsivenessMetrics(payload.applicationResponsivenessMetrics)
        reportDiskIOMetrics(payload.diskIOMetrics)
        reportMemoryMetrics(payload.memoryMetrics)
        reportDisplayMetrics(payload.displayMetrics)
        reportAnimationMetrics(payload.animationMetrics)
        reportCellularConditionMetrics(payload.cellularConditionMetrics)
        reportAppExitMetrics(payload.applicationExitMetrics)
        if #available(iOS 26.0, *) {
            reportDiskSpaceUsageMetrics(payload.diskSpaceUsageMetrics)
        }

        let breadcrumb = Breadcrumb(level: .info, category: "metrickit")
        breadcrumb.message = "Received MXMetricPayload"
        breadcrumb.data = [
            "time_stamp_begin": payload.timeStampBegin.description,
            "time_stamp_end": payload.timeStampEnd.description
        ]
        SentrySDK.addBreadcrumb(breadcrumb)
    }

    // MARK: - CPU Metrics

    private func reportCPUMetrics(_ metrics: MXCPUMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.distribution(
            key: "metrickit.cpu.cumulative_time",
            value: metrics.cumulativeCPUTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.cpu.cumulative_instructions",
            value: metrics.cumulativeCPUInstructions.value,
            unit: .generic("instructions")
        )
    }

    // MARK: - GPU Metrics

    private func reportGPUMetrics(_ metrics: MXGPUMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.distribution(
            key: "metrickit.gpu.cumulative_time",
            value: metrics.cumulativeGPUTime.converted(to: .seconds).value,
            unit: .second
        )
    }

    // MARK: - App Time Metrics

    private func reportAppTimeMetrics(_ metrics: MXAppRunTimeMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.distribution(
            key: "metrickit.app_time.foreground",
            value: metrics.cumulativeForegroundTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.app_time.background",
            value: metrics.cumulativeBackgroundTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.app_time.background_audio",
            value: metrics.cumulativeBackgroundAudioTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.app_time.background_location",
            value: metrics.cumulativeBackgroundLocationTime.converted(to: .seconds).value,
            unit: .second
        )
    }

    // MARK: - Location Activity Metrics

    private func reportLocationActivityMetrics(_ metrics: MXLocationActivityMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.distribution(
            key: "metrickit.location.best_accuracy_time",
            value: metrics.cumulativeBestAccuracyTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.location.best_accuracy_for_nav_time",
            value: metrics.cumulativeBestAccuracyForNavigationTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.location.nearest_ten_meters_time",
            value: metrics.cumulativeNearestTenMetersAccuracyTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.location.hundred_meters_time",
            value: metrics.cumulativeHundredMetersAccuracyTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.location.kilometer_time",
            value: metrics.cumulativeKilometerAccuracyTime.converted(to: .seconds).value,
            unit: .second
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.location.three_kilometers_time",
            value: metrics.cumulativeThreeKilometersAccuracyTime.converted(to: .seconds).value,
            unit: .second
        )
    }

    // MARK: - Network Transfer Metrics

    private func reportNetworkTransferMetrics(_ metrics: MXNetworkTransferMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.distribution(
            key: "metrickit.network.wifi_upload",
            value: metrics.cumulativeWifiUpload.converted(to: .bytes).value,
            unit: .byte
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.network.wifi_download",
            value: metrics.cumulativeWifiDownload.converted(to: .bytes).value,
            unit: .byte
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.network.cellular_upload",
            value: metrics.cumulativeCellularUpload.converted(to: .bytes).value,
            unit: .byte
        )
        SentrySDK.metrics.distribution(
            key: "metrickit.network.cellular_download",
            value: metrics.cumulativeCellularDownload.converted(to: .bytes).value,
            unit: .byte
        )
    }

    // MARK: - App Launch Metrics

    private func reportAppLaunchMetrics(_ metrics: MXAppLaunchMetric?) {
        guard let metrics else { return }
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
        reportDurationHistogram(
            metrics.histogrammedApplicationHangTime,
            key: "metrickit.responsiveness.hang_time"
        )
    }

    // MARK: - Disk IO Metrics

    private func reportDiskIOMetrics(_ metrics: MXDiskIOMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.distribution(
            key: "metrickit.disk_io.logical_writes",
            value: metrics.cumulativeLogicalWrites.converted(to: .bytes).value,
            unit: .byte
        )
    }

    // MARK: - Memory Metrics

    private func reportMemoryMetrics(_ metrics: MXMemoryMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.gauge(
            key: "metrickit.memory.peak_usage",
            value: metrics.peakMemoryUsage.converted(to: .bytes).value,
            unit: .byte
        )
        let avgMemory = metrics.averageSuspendedMemory
        SentrySDK.metrics.gauge(
            key: "metrickit.memory.avg_suspended",
            value: avgMemory.averageMeasurement.converted(to: .bytes).value,
            unit: .byte,
            attributes: ["sample_count": String(avgMemory.sampleCount)]
        )
    }

    // MARK: - Display Metrics

    private func reportDisplayMetrics(_ metrics: MXDisplayMetric?) {
        guard let metrics, let luminance = metrics.averagePixelLuminance else { return }
        SentrySDK.metrics.gauge(
            key: "metrickit.display.avg_pixel_luminance",
            value: luminance.averageMeasurement.value,
            unit: .generic("apl"),
            attributes: ["sample_count": String(luminance.sampleCount)]
        )
    }

    // MARK: - Animation Metrics

    private func reportAnimationMetrics(_ metrics: MXAnimationMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.gauge(
            key: "metrickit.animation.scroll_hitch_time_ratio",
            value: metrics.scrollHitchTimeRatio.value,
            unit: .generic("ratio")
        )
        if #available(iOS 26.0, *) {
            SentrySDK.metrics.gauge(
                key: "metrickit.animation.hitch_time_ratio",
                value: metrics.hitchTimeRatio.value,
                unit: .generic("ratio")
            )
        }
    }

    // MARK: - Cellular Condition Metrics

    private func reportCellularConditionMetrics(_ metrics: MXCellularConditionMetric?) {
        guard let metrics else { return }
        reportSignalBarsHistogram(
            metrics.histogrammedCellularConditionTime,
            key: "metrickit.cellular.condition_time"
        )
    }

    // MARK: - App Exit Metrics

    private func reportAppExitMetrics(_ metrics: MXAppExitMetric?) {
        guard let metrics else { return }

        let foreground = metrics.foregroundExitData
        SentrySDK.metrics.count(key: "metrickit.exit.fg.normal", value: UInt(foreground.cumulativeNormalAppExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.fg.memory_resource_limit", value: UInt(foreground.cumulativeMemoryResourceLimitExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.fg.bad_access", value: UInt(foreground.cumulativeBadAccessExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.fg.abnormal", value: UInt(foreground.cumulativeAbnormalExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.fg.illegal_instruction", value: UInt(foreground.cumulativeIllegalInstructionExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.fg.watchdog", value: UInt(foreground.cumulativeAppWatchdogExitCount))

        let background = metrics.backgroundExitData
        SentrySDK.metrics.count(key: "metrickit.exit.bg.normal", value: UInt(background.cumulativeNormalAppExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.bg.memory_resource_limit", value: UInt(background.cumulativeMemoryResourceLimitExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.bg.cpu_resource_limit", value: UInt(background.cumulativeCPUResourceLimitExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.bg.memory_pressure", value: UInt(background.cumulativeMemoryPressureExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.bg.bad_access", value: UInt(background.cumulativeBadAccessExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.bg.abnormal", value: UInt(background.cumulativeAbnormalExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.bg.illegal_instruction", value: UInt(background.cumulativeIllegalInstructionExitCount))
        SentrySDK.metrics.count(key: "metrickit.exit.bg.watchdog", value: UInt(background.cumulativeAppWatchdogExitCount))
        let lockedFileExits = background.cumulativeSuspendedWithLockedFileExitCount
        SentrySDK.metrics.count(key: "metrickit.exit.bg.suspended_with_locked_file", value: UInt(lockedFileExits))
        let taskTimeoutExits = background.cumulativeBackgroundTaskAssertionTimeoutExitCount
        SentrySDK.metrics.count(key: "metrickit.exit.bg.background_task_timeout", value: UInt(taskTimeoutExits))
    }

    // MARK: - Disk Space Usage Metrics

    @available(iOS 26.0, *)
    private func reportDiskSpaceUsageMetrics(_ metrics: MXDiskSpaceUsageMetric?) {
        guard let metrics else { return }
        SentrySDK.metrics.gauge(
            key: "metrickit.disk_space.binary_file_size",
            value: metrics.totalBinaryFileSize.converted(to: .bytes).value,
            unit: .byte
        )
        SentrySDK.metrics.gauge(
            key: "metrickit.disk_space.binary_file_count",
            value: Double(metrics.totalBinaryFileCount),
            unit: .generic("files")
        )
        SentrySDK.metrics.gauge(
            key: "metrickit.disk_space.data_file_size",
            value: metrics.totalDataFileSize.converted(to: .bytes).value,
            unit: .byte
        )
        SentrySDK.metrics.gauge(
            key: "metrickit.disk_space.data_file_count",
            value: Double(metrics.totalDataFileCount),
            unit: .generic("files")
        )
        SentrySDK.metrics.gauge(
            key: "metrickit.disk_space.cache_folder_size",
            value: metrics.totalCacheFolderSize.converted(to: .bytes).value,
            unit: .byte
        )
        SentrySDK.metrics.gauge(
            key: "metrickit.disk_space.clone_size",
            value: metrics.totalCloneSize.converted(to: .bytes).value,
            unit: .byte
        )
        SentrySDK.metrics.gauge(
            key: "metrickit.disk_space.total_used",
            value: metrics.totalDiskSpaceUsedSize.converted(to: .bytes).value,
            unit: .byte
        )
        SentrySDK.metrics.gauge(
            key: "metrickit.disk_space.total_capacity",
            value: metrics.totalDiskSpaceCapacity.converted(to: .bytes).value,
            unit: .byte
        )
    }

    // MARK: - Diagnostic Payload Processing

    private func reportDiagnostics(from payload: MXDiagnosticPayload) {
        if let cpuExceptions = payload.cpuExceptionDiagnostics {
            SentrySDK.metrics.count(
                key: "metrickit.diagnostic.cpu_exception",
                value: UInt(cpuExceptions.count)
            )
            for diagnostic in cpuExceptions {
                SentrySDK.metrics.distribution(
                    key: "metrickit.diagnostic.cpu_exception.total_cpu_time",
                    value: diagnostic.totalCPUTime.converted(to: .seconds).value,
                    unit: .second
                )
                SentrySDK.metrics.distribution(
                    key: "metrickit.diagnostic.cpu_exception.total_sampled_time",
                    value: diagnostic.totalSampledTime.converted(to: .seconds).value,
                    unit: .second
                )
            }
        }

        if let diskWriteExceptions = payload.diskWriteExceptionDiagnostics {
            SentrySDK.metrics.count(
                key: "metrickit.diagnostic.disk_write_exception",
                value: UInt(diskWriteExceptions.count)
            )
            for diagnostic in diskWriteExceptions {
                SentrySDK.metrics.distribution(
                    key: "metrickit.diagnostic.disk_write_exception.total_writes",
                    value: diagnostic.totalWritesCaused.converted(to: .bytes).value,
                    unit: .byte
                )
            }
        }

        if let hangDiagnostics = payload.hangDiagnostics {
            SentrySDK.metrics.count(
                key: "metrickit.diagnostic.hang",
                value: UInt(hangDiagnostics.count)
            )
            for diagnostic in hangDiagnostics {
                SentrySDK.metrics.distribution(
                    key: "metrickit.diagnostic.hang.duration",
                    value: diagnostic.hangDuration.converted(to: .seconds).value,
                    unit: .second
                )
            }
        }

        if let crashDiagnostics = payload.crashDiagnostics {
            SentrySDK.metrics.count(
                key: "metrickit.diagnostic.crash",
                value: UInt(crashDiagnostics.count)
            )
        }

        if let appLaunchDiagnostics = payload.appLaunchDiagnostics {
            SentrySDK.metrics.count(
                key: "metrickit.diagnostic.app_launch",
                value: UInt(appLaunchDiagnostics.count)
            )
            for diagnostic in appLaunchDiagnostics {
                SentrySDK.metrics.distribution(
                    key: "metrickit.diagnostic.app_launch.duration",
                    value: diagnostic.launchDuration.converted(to: .seconds).value,
                    unit: .second
                )
            }
        }

        let breadcrumb = Breadcrumb(level: .warning, category: "metrickit")
        breadcrumb.message = "Received MXDiagnosticPayload"
        breadcrumb.data = [
            "time_stamp_begin": payload.timeStampBegin.description,
            "time_stamp_end": payload.timeStampEnd.description,
            "cpu_exceptions": String(payload.cpuExceptionDiagnostics?.count ?? 0),
            "disk_write_exceptions": String(payload.diskWriteExceptionDiagnostics?.count ?? 0),
            "hangs": String(payload.hangDiagnostics?.count ?? 0),
            "crashes": String(payload.crashDiagnostics?.count ?? 0),
            "app_launch_issues": String(payload.appLaunchDiagnostics?.count ?? 0)
        ]
        SentrySDK.addBreadcrumb(breadcrumb)
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
                SentrySDK.metrics.distribution(key: key, value: midpoint, unit: .second)
            }
            totalCount += bucket.bucketCount
        }

        if totalCount > 0 {
            SentrySDK.metrics.count(key: "\(key).count", value: UInt(totalCount))
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
                SentrySDK.metrics.distribution(key: key, value: midpoint, unit: .generic("bars"))
            }
            totalCount += bucket.bucketCount
        }

        if totalCount > 0 {
            SentrySDK.metrics.count(key: "\(key).count", value: UInt(totalCount))
        }
    }

    // MARK: - Cleanup

    deinit {
        stopReceiving()
    }
}
// swiftlint:enable file_length function_body_length type_body_length
