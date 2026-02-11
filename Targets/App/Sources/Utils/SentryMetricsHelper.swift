// swiftlint:disable type_body_length file_length
import FlinkyCore
import Foundation
import SentrySPM

// MARK: - SentryMetricsHelper

/// Helper utility for tracking analytics metrics using Sentry Metrics API.
///
/// This utility provides type-safe wrapper functions for metric patterns that
/// **DO NOT overlap with Sentry's automatic tracing**. Before adding new metrics,
/// verify they don't duplicate what's already tracked automatically.
enum SentryMetricsHelper {

    // MARK: - App Health Signals
    // These track system-level signals that don't overlap with tracing.
    // They provide quick app/runtime health insights.

    /// Tracks memory warning received from the system.
    ///
    /// **Why Metrics (not Events):**
    /// - High-volume signal (can happen frequently under pressure)
    /// - Aggregate count is more valuable than individual occurrences
    /// - Doesn't need stack traces (unlike OOM crashes)
    ///
    /// **Not Covered By:**
    /// - Watchdog Terminations (those track the final crash, not warnings)
    /// - MetricKit (doesn't expose memory warnings)
    ///
    /// - Parameter cacheSizeAtWarning: Number of items in cache when warning received
    /// - Parameter appState: Current app state ("foreground" or "background")
    static func trackMemoryWarningReceived(cacheSizeAtWarning: Int, appState: String = "foreground") {
        SentrySDK.metrics.count(
            key: "memory.warning.received",
            value: 1,
            attributes: [
                "cache_size_at_warning": String(cacheSizeAtWarning),
                "app_state": appState
            ]
        )
    }

    /// Tracks thermal state transitions.
    ///
    /// **Why Metrics:**
    /// - Thermal throttling affects performance but isn't captured by tracing
    /// - Aggregate patterns are useful (e.g., "20% of sessions reach serious thermal state")
    ///
    /// **Not Covered By:**
    /// - Any existing Sentry feature
    /// - Partially related to App Hangs (thermal throttling can cause slowdowns), but distinct
    ///
    /// - Parameters:
    ///   - fromState: Previous thermal state ("nominal", "fair", "serious", "critical")
    ///   - toState: New thermal state after transition
    ///   - isEscalation: True if thermal state worsened
    static func trackThermalStateTransition(fromState: String, toState: String, isEscalation: Bool) {
        SentrySDK.metrics.count(
            key: "device.thermal.transition",
            value: 1,
            attributes: [
                "from_state": fromState,
                "to_state": toState,
                "is_escalation": String(isEscalation)
            ]
        )
    }

    /// Tracks network reachability changes.
    ///
    /// **Why Metrics:**
    /// - Network changes correlate with errors but aren't the errors themselves
    /// - Helps contextualize "why did errors spike?"
    ///
    /// **Not Covered By:**
    /// - Network Tracking (which tracks request performance, not connectivity state)
    /// - HTTP Client Errors (which track failures, not connectivity)
    ///
    /// - Parameters:
    ///   - status: "connected" or "disconnected"
    ///   - interfaceType: "wifi", "cellular", "wired", "loopback", "other"
    ///   - isExpensive: True if on cellular (metered connection)
    ///   - isConstrained: True if Low Data Mode is enabled
    static func trackNetworkReachabilityChanged(
        status: String,
        interfaceType: String,
        isExpensive: Bool,
        isConstrained: Bool
    ) {
        SentrySDK.metrics.count(
            key: "network.reachability.changed",
            value: 1,
            attributes: [
                "status": status,
                "interface": interfaceType,
                "is_expensive": String(isExpensive),
                "is_constrained": String(isConstrained)
            ]
        )
    }

    /// Tracks app state transitions (foreground/background).
    ///
    /// **Why Metrics:**
    /// - Helps correlate other metrics with app state
    /// - Useful for understanding user session patterns
    ///
    /// **Not Covered By:**
    /// - App Start Tracing (only tracks initial launch, not subsequent transitions)
    ///
    /// - Parameters:
    ///   - toState: New app state ("active", "inactive", "background")
    ///   - fromState: Previous app state
    static func trackAppStateTransition(toState: String, fromState: String) {
        SentrySDK.metrics.count(
            key: "app.state.transition",
            value: 1,
            attributes: [
                "to_state": toState,
                "from_state": fromState
            ]
        )
    }

    // MARK: - Background Task Lifecycle
    // Track background task completions, expirations, and failures.
    // Not covered by Tracing (which focuses on foreground operations).

    /// Tracks background task completion.
    /// - Parameters:
    ///   - taskType: Type of task ("app_refresh", "processing", "legacy")
    ///   - taskIdentifier: The registered task identifier
    static func trackBackgroundTaskCompleted(taskType: String, taskIdentifier: String) {
        SentrySDK.metrics.count(
            key: "background.task.completed",
            value: 1,
            attributes: [
                "task_type": taskType,
                "task_identifier": taskIdentifier
            ]
        )
    }

    /// Tracks background task expiration.
    /// - Parameters:
    ///   - taskType: Type of task ("app_refresh", "processing", "legacy")
    ///   - timeRemaining: Seconds remaining when task expired
    static func trackBackgroundTaskExpired(taskType: String, timeRemaining: Double) {
        SentrySDK.metrics.count(
            key: "background.task.expired",
            value: 1,
            attributes: [
                "task_type": taskType,
                "time_remaining": String(format: "%.1f", timeRemaining)
            ]
        )
    }

    /// Tracks background task duration.
    /// - Parameters:
    ///   - duration: Task duration in seconds
    ///   - taskType: Type of task ("app_refresh", "processing", "legacy")
    ///   - outcome: Result of the task ("completed", "expired", "cancelled")
    static func trackBackgroundTaskDuration(duration: Double, taskType: String, outcome: String) {
        SentrySDK.metrics.distribution(
            key: "background.task.duration",
            value: duration,
            unit: .second,
            attributes: [
                "task_type": taskType,
                "outcome": outcome
            ]
        )
    }

    // MARK: - Link Creation
    // User action tracking - doesn't overlap with tracing.

    /// Tracks link creation with creation flow and entity type attributes.
    /// - Parameters:
    ///   - creationFlow: The flow used to create the link (e.g., "direct", "list_picker", "share_extension")
    ///   - listId: The ID of the list the link was added to
    static func trackLinkCreated(creationFlow: String, listId: String) {
        SentrySDK.metrics.count(
            key: "link.created",
            value: 1,
            attributes: [
                "creation_flow": creationFlow,
                "entity_type": "link",
                "list_id": listId
            ]
        )
    }

    // MARK: - List Creation

    /// Tracks list creation with creation flow and auto-created attributes.
    /// - Parameters:
    ///   - creationFlow: The flow used to create the list (e.g., "direct", "share_extension")
    ///   - autoCreated: Whether the list was auto-created (e.g., default list in share extension)
    static func trackListCreated(creationFlow: String, autoCreated: Bool = false) {
        SentrySDK.metrics.count(
            key: "list.created",
            value: 1,
            attributes: [
                "creation_flow": creationFlow,
                "entity_type": "list",
                "auto_created": String(autoCreated)
            ]
        )
    }

    // MARK: - Link Sharing

    /// Tracks link sharing with sharing method attribute.
    /// - Parameters:
    ///   - sharingMethod: The method used to share (e.g., "copy_url", "qr_code_share", "qr_code_save", "nfc", "system_share")
    ///   - linkId: The ID of the link being shared
    static func trackLinkShared(sharingMethod: String, linkId: String) {
        SentrySDK.metrics.count(
            key: "link.shared",
            value: 1,
            attributes: [
                "sharing_method": sharingMethod,
                "link_id": linkId
            ]
        )
    }

    /// Tracks NFC-specific link sharing for detailed analysis.
    /// - Parameter linkId: The ID of the link being shared via NFC
    static func trackLinkSharedNFC(linkId: String) {
        SentrySDK.metrics.count(
            key: "link.shared.nfc",
            value: 1,
            attributes: [
                "sharing_method": "nfc",
                "link_id": linkId
            ]
        )
    }

    // MARK: - Customization

    /// Tracks color selection for links or lists.
    /// - Parameters:
    ///   - color: The selected color raw value
    ///   - entityType: The type of entity ("link" or "list")
    static func trackColorSelected(color: String, entityType: String) {
        let metricKey = entityType == "link" ? "link.color.selected" : "list.color.selected"
        SentrySDK.metrics.count(
            key: metricKey,
            value: 1,
            attributes: [
                "color": color,
                "entity_type": entityType
            ]
        )
    }

    /// Tracks symbol selection for links or lists.
    /// - Parameters:
    ///   - symbol: The selected symbol raw value
    ///   - entityType: The type of entity ("link" or "list")
    static func trackSymbolSelected(symbol: String, entityType: String) {
        let metricKey = entityType == "link" ? "link.symbol.selected" : "list.symbol.selected"
        SentrySDK.metrics.count(
            key: metricKey,
            value: 1,
            attributes: [
                "symbol": symbol,
                "entity_type": entityType
            ]
        )
    }

    // MARK: - Feedback

    /// Tracks feedback form opening.
    static func trackFeedbackFormOpened() {
        SentrySDK.metrics.count(
            key: "feedback.form.opened",
            value: 1,
        )
    }

    /// Tracks feedback form closing.
    static func trackFeedbackFormClosed() {
        SentrySDK.metrics.count(
            key: "feedback.form.closed",
            value: 1
        )
    }

    // MARK: - Database Seeding

    /// Tracks database seeding start.
    static func trackDatabaseSeedingStarted() {
        SentrySDK.metrics.count(
            key: "database.seeding.started",
            value: 1
        )
    }

    /// Tracks database seeding completion.
    static func trackDatabaseSeedingCompleted() {
        SentrySDK.metrics.count(
            key: "database.seeding.completed",
            value: 1
        )
    }

    // MARK: - QR Code Performance
    // Performance metrics for QR code generation and caching.
    // Note: This doesn't overlap with File I/O Tracing since QR generation
    // is CPU-bound image processing, not file operations.

    /// Tracks QR code generation duration.
    /// - Parameters:
    ///   - duration: Generation time in seconds
    ///   - cacheHit: Whether the QR code was served from cache
    ///   - imageSize: Image dimensions as string (e.g., "200x200")
    static func trackQRCodeGenerationDuration(duration: Double, cacheHit: Bool, imageSize: String) {
        SentrySDK.metrics.distribution(
            key: "qr_code.generation.duration",
            value: duration,
            unit: .second,
            attributes: [
                "cache_hit": String(cacheHit),
                "image_size": imageSize
            ]
        )
    }

    /// Tracks QR code cache hit.
    static func trackQRCodeCacheHit() {
        SentrySDK.metrics.count(
            key: "qr_code.cache.hit",
            value: 1
        )
    }

    /// Tracks QR code cache miss.
    static func trackQRCodeCacheMiss() {
        SentrySDK.metrics.count(
            key: "qr_code.cache.miss",
            value: 1
        )
    }

    /// Tracks QR code cache eviction.
    /// - Parameter reason: Reason for eviction ("memory_warning" | "size_limit")
    static func trackQRCodeCacheEviction(reason: String) {
        SentrySDK.metrics.count(
            key: "qr_code.cache.eviction",
            value: 1,
            attributes: [
                "reason": reason
            ]
        )
    }

    // MARK: - Link Metadata (LinkPresentation Framework)
    // Track link metadata fetching for rich previews.

    /// Tracks link metadata fetch completion.
    /// - Parameters:
    ///   - outcome: Result of fetch ("success", "failed", "cached")
    ///   - hasImage: Whether the metadata includes an image
    ///   - hasVideo: Whether the metadata includes video
    ///   - contentType: Type of content ("article", "video", "audio", "generic")
    static func trackLinkMetadataFetched(
        outcome: String,
        hasImage: Bool,
        hasVideo: Bool,
        contentType: String
    ) {
        SentrySDK.metrics.count(
            key: "link.metadata.fetched",
            value: 1,
            attributes: [
                "outcome": outcome,
                "has_image": String(hasImage),
                "has_video": String(hasVideo),
                "content_type": contentType
            ]
        )
    }

    /// Tracks link metadata fetch duration.
    /// - Parameters:
    ///   - duration: Fetch duration in seconds
    ///   - outcome: Result of fetch ("success", "failed", "cached")
    static func trackLinkMetadataFetchDuration(duration: Double, outcome: String) {
        SentrySDK.metrics.distribution(
            key: "link.metadata.fetch.duration",
            value: duration,
            unit: .second,
            attributes: [
                "outcome": outcome
            ]
        )
    }

    // MARK: - Error Rate Metrics

    /// Tracks error rate by type.
    /// - Parameter errorType: Type of error ("persistence" | "qr_generation" | "nfc" | "validation" | "data_corruption")
    static func trackErrorRate(errorType: String) {
        SentrySDK.metrics.count(
            key: "error.rate",
            value: 1,
            attributes: [
                "error_type": errorType
            ]
        )
    }

    /// Captures an error and tracks error rate metric.
    /// This is a convenience wrapper that both captures the error and tracks the metric.
    /// - Parameter error: The error to capture
    /// - Parameter configureScope: Optional scope configuration closure
    static func captureErrorAndTrackRate(_ error: Error, configureScope: ((Scope) -> Void)? = nil) {
        // Extract error type from AppError
        let errorType: String
        if let appError = error as? AppError {
            switch appError {
            case .persistenceError:
                errorType = "persistence"
            case .qrCodeGenerationError, .failedToGenerateQRCode:
                errorType = "qr_generation"
            case .nfcError:
                errorType = "nfc"
            case .validationError:
                errorType = "validation"
            case .dataCorruption:
                errorType = "data_corruption"
            case .networkError:
                errorType = "network"
            case .failedToOpenURL:
                errorType = "url_opening"
            case .unknownError:
                errorType = "unknown"
            }
        } else {
            errorType = "unknown"
        }

        // Track error rate metric
        trackErrorRate(errorType: errorType)

        // Capture error with Sentry
        if let configureScope = configureScope {
            SentrySDK.capture(error: error, block: configureScope)
        } else {
            SentrySDK.capture(error: error)
        }
    }

    // MARK: - Search Metrics

    /// Tracks search performed.
    /// - Parameters:
    ///   - searchContext: Context of search ("lists" | "links")
    ///   - resultCount: Number of results returned
    static func trackSearchPerformed(searchContext: String, resultCount: Int) {
        SentrySDK.metrics.count(
            key: "search.performed",
            value: 1,
            attributes: [
                "search_context": searchContext,
                "result_count": String(resultCount)
            ]
        )
    }

    /// Tracks search query length.
    /// - Parameters:
    ///   - length: Length of search query
    ///   - searchContext: Context of search ("lists" | "links")
    static func trackSearchQueryLength(length: Int, searchContext: String) {
        SentrySDK.metrics.distribution(
            key: "search.query.length",
            value: Double(length),
            unit: .generic("character"),
            attributes: [
                "search_context": searchContext
            ]
        )
    }

    // MARK: - List Management

    /// Tracks list pinning action.
    static func trackListPinned() {
        SentrySDK.metrics.count(
            key: "list.pinned",
            value: 1
        )
    }

    /// Tracks list unpinning action.
    static func trackListUnpinned() {
        SentrySDK.metrics.count(
            key: "list.unpinned",
            value: 1
        )
    }

    /// Tracks list deletion.
    /// - Parameter linkCount: Number of links in deleted list
    static func trackListDeleted(linkCount: Int) {
        SentrySDK.metrics.count(
            key: "list.deleted",
            value: 1,
            attributes: [
                "link_count": String(linkCount)
            ]
        )
    }

    /// Tracks bulk list deletion.
    /// - Parameter count: Number of lists deleted
    static func trackListDeletedBulk(count: Int) {
        SentrySDK.metrics.count(
            key: "list.deleted.bulk",
            value: 1,
            attributes: [
                "count": String(count)
            ]
        )
    }

    // MARK: - Link Management

    /// Tracks link deletion.
    /// - Parameter listLinkCount: Total links in list after deletion
    static func trackLinkDeleted(listLinkCount: Int) {
        SentrySDK.metrics.count(
            key: "link.deleted",
            value: 1,
            attributes: [
                "list_link_count": String(listLinkCount)
            ]
        )
    }

    /// Tracks bulk link deletion.
    /// - Parameters:
    ///   - count: Number of links deleted
    ///   - listId: UUID of the list
    static func trackLinkDeletedBulk(count: Int, listId: String) {
        SentrySDK.metrics.count(
            key: "link.deleted.bulk",
            value: 1,
            attributes: [
                "count": String(count),
                "list_id": listId
            ]
        )
    }

    /// Tracks link opened in Safari.
    /// - Parameters:
    ///   - linkId: The ID of the link being opened
    ///   - sharingMethod: Optional sharing method if opened from share context
    static func trackLinkOpened(linkId: String, sharingMethod: String? = nil) {
        var attributes: [String: String] = [
            "link_id": linkId
        ]
        if let sharingMethod = sharingMethod {
            attributes["sharing_method"] = sharingMethod
        }
        SentrySDK.metrics.count(
            key: "link.opened",
            value: 1,
            attributes: attributes
        )
    }

    // MARK: - Share Extension

    /// Tracks share extension opened.
    /// - Parameter sourceApp: Optional source app identifier
    static func trackShareExtensionOpened(sourceApp: String? = nil) {
        var attributes: [String: String] = [:]
        if let sourceApp = sourceApp {
            attributes["source_app"] = sourceApp
        }
        SentrySDK.metrics.count(
            key: "share_extension.opened",
            value: 1,
            attributes: attributes
        )
    }

    /// Tracks share extension completion.
    /// - Parameters:
    ///   - listSelected: Whether user selected a list
    ///   - nameEdited: Whether user edited the name
    static func trackShareExtensionCompleted(listSelected: Bool, nameEdited: Bool) {
        SentrySDK.metrics.count(
            key: "share_extension.completed",
            value: 1,
            attributes: [
                "list_selected": String(listSelected),
                "name_edited": String(nameEdited)
            ]
        )
    }

    /// Tracks share extension cancellation.
    /// - Parameter step: Step where cancellation occurred ("initial" | "after_list_selection" | "after_name_edit")
    static func trackShareExtensionCancelled(step: String) {
        SentrySDK.metrics.count(
            key: "share_extension.cancelled",
            value: 1,
            attributes: [
                "step": step
            ]
        )
    }

    // MARK: - NFC Metrics
    // CoreNFC framework usage tracking.

    /// Tracks NFC share initiation.
    static func trackNFCShareInitiated() {
        SentrySDK.metrics.count(
            key: "nfc.share.initiated",
            value: 1
        )
    }

    /// Tracks successful NFC share.
    static func trackNFCShareSuccess() {
        SentrySDK.metrics.count(
            key: "nfc.share.success",
            value: 1
        )
    }

    /// Tracks failed NFC share.
    /// - Parameter errorType: Optional error type category
    static func trackNFCShareFailed(errorType: String? = nil) {
        var attributes: [String: String] = [:]
        if let errorType = errorType {
            attributes["error_type"] = errorType
        }
        SentrySDK.metrics.count(
            key: "nfc.share.failed",
            value: 1,
            attributes: attributes
        )
    }

    /// Tracks NFC operation performed.
    /// - Parameters:
    ///   - operation: Type of operation ("read", "write", "scan")
    ///   - tagType: Type of NFC tag ("ndef", "iso7816", "iso15693", "felica")
    ///   - outcome: Result of operation ("success", "failed", "cancelled")
    static func trackNFCOperationPerformed(operation: String, tagType: String, outcome: String) {
        SentrySDK.metrics.count(
            key: "nfc.operation.performed",
            value: 1,
            attributes: [
                "operation": operation,
                "tag_type": tagType,
                "outcome": outcome
            ]
        )
    }

    // MARK: - Database Performance
    // Note: SwiftData is used (not Core Data), so these don't overlap with
    // Sentry's Core Data Tracing which specifically instruments NSManagedObjectContext.

    /// Tracks database query duration.
    /// - Parameters:
    ///   - duration: Query duration in seconds
    ///   - queryType: Type of query ("fetch_lists" | "fetch_links" | "save" | "delete")
    static func trackDatabaseQueryDuration(duration: Double, queryType: String) {
        SentrySDK.metrics.distribution(
            key: "database.query.duration",
            value: duration,
            unit: .second,
            attributes: [
                "query_type": queryType
            ]
        )
    }

    /// Tracks database save duration.
    /// - Parameters:
    ///   - duration: Save duration in seconds
    ///   - entityType: Type of entity ("link" | "list")
    ///   - operation: Type of operation ("create" | "update" | "delete")
    static func trackDatabaseSaveDuration(duration: Double, entityType: String, operation: String) {
        SentrySDK.metrics.distribution(
            key: "database.save.duration",
            value: duration,
            unit: .second,
            attributes: [
                "entity_type": entityType,
                "operation": operation
            ]
        )
    }

    // MARK: - Spotlight Search (CoreSpotlight)
    // Track Spotlight indexing for searchable links.

    /// Tracks Spotlight item indexed.
    /// - Parameters:
    ///   - count: Number of items indexed
    ///   - contentType: Type of content indexed
    static func trackSpotlightItemIndexed(count: Int, contentType: String) {
        SentrySDK.metrics.count(
            key: "spotlight.item.indexed",
            value: UInt(count),
            attributes: [
                "content_type": contentType
            ]
        )
    }

    /// Tracks Spotlight search performed from system.
    /// - Parameters:
    ///   - resultCountBucket: Bucketed result count ("0", "1-10", "10-50", "50+")
    ///   - querySource: Source of query ("in_app", "system_spotlight")
    static func trackSpotlightSearchPerformed(resultCountBucket: String, querySource: String) {
        SentrySDK.metrics.count(
            key: "spotlight.search.performed",
            value: 1,
            attributes: [
                "result_count_bucket": resultCountBucket,
                "query_source": querySource
            ]
        )
    }
}

// MARK: - Thermal State Helpers

extension SentryMetricsHelper {

    /// Converts ProcessInfo.ThermalState to a string for metrics.
    /// - Parameter state: The thermal state to convert
    /// - Returns: String representation ("nominal", "fair", "serious", "critical")
    static func thermalStateString(_ state: ProcessInfo.ThermalState) -> String {
        switch state {
        case .nominal:
            return "nominal"
        case .fair:
            return "fair"
        case .serious:
            return "serious"
        case .critical:
            return "critical"
        @unknown default:
            return "unknown"
        }
    }
}

// MARK: - App State Helpers

#if canImport(UIKit)
import UIKit

extension SentryMetricsHelper {

    /// Converts UIApplication.State to a string for metrics.
    /// - Parameter state: The application state to convert
    /// - Returns: String representation ("active", "inactive", "background")
    static func appStateString(_ state: UIApplication.State) -> String {
        switch state {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .background:
            return "background"
        @unknown default:
            return "unknown"
        }
    }
}
#endif
// swiftlint:enable type_body_length file_length
