// swiftlint:disable type_body_length file_length
import Foundation
import Sentry

/// Helper utility for tracking analytics metrics using Sentry Metrics API.
///
/// This utility provides type-safe wrapper functions for common metric patterns,
/// replacing the previous `SentrySDK.capture(event:)` calls for analytics tracking.
/// Metrics are better suited for tracking aggregate counts and don't create individual "issues" in Sentry.
enum SentryMetricsHelper {
    // MARK: - Link Creation

    /// Tracks link creation with creation flow and entity type attributes.
    /// - Parameters:
    ///   - creationFlow: The flow used to create the link (e.g., "direct", "list_picker", "share_extension")
    ///   - listId: The ID of the list the link was added to
    static func trackLinkCreated(creationFlow: String, listId: String) {
        SentrySDK.metrics.count(
            key: "link.created",
            value: 1,
            unit: .generic("link"),
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
            unit: .generic("list"),
            attributes: [
                "creation_flow": creationFlow,
                "entity_type": "list",
                "auto_created": autoCreated
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
            unit: .generic("share"),
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
            unit: .generic("share"),
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
            unit: .generic("selection"),
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
            unit: .generic("selection"),
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
            unit: .generic("interaction")
        )
    }

    /// Tracks feedback form closing.
    static func trackFeedbackFormClosed() {
        SentrySDK.metrics.count(
            key: "feedback.form.closed",
            value: 1,
            unit: .generic("interaction")
        )
    }

    // MARK: - Database Seeding

    /// Tracks database seeding start.
    static func trackDatabaseSeedingStarted() {
        SentrySDK.metrics.count(
            key: "database.seeding.started",
            value: 1,
            unit: .generic("operation")
        )
    }

    /// Tracks database seeding completion.
    static func trackDatabaseSeedingCompleted() {
        SentrySDK.metrics.count(
            key: "database.seeding.completed",
            value: 1,
            unit: .generic("operation")
        )
    }

    // MARK: - Performance Metrics

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
                "cache_hit": cacheHit,
                "image_size": imageSize
            ]
        )
    }

    /// Tracks QR code cache hit.
    static func trackQRCodeCacheHit() {
        SentrySDK.metrics.count(
            key: "qr_code.cache.hit",
            value: 1,
            unit: .generic("hit")
        )
    }

    /// Tracks QR code cache miss.
    static func trackQRCodeCacheMiss() {
        SentrySDK.metrics.count(
            key: "qr_code.cache.miss",
            value: 1,
            unit: .generic("miss")
        )
    }

    /// Tracks QR code cache eviction.
    /// - Parameter reason: Reason for eviction ("memory_warning" | "size_limit")
    static func trackQRCodeCacheEviction(reason: String) {
        SentrySDK.metrics.count(
            key: "qr_code.cache.eviction",
            value: 1,
            unit: .generic("eviction"),
            attributes: [
                "reason": reason
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
            unit: .generic("error"),
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
            SentrySDK.capture(error: error, configureScope: configureScope)
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
            unit: .generic("search"),
            attributes: [
                "search_context": searchContext,
                "result_count": resultCount
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
            value: 1,
            unit: .generic("action")
        )
    }

    /// Tracks list unpinning action.
    static func trackListUnpinned() {
        SentrySDK.metrics.count(
            key: "list.unpinned",
            value: 1,
            unit: .generic("action")
        )
    }

    /// Tracks list deletion.
    /// - Parameter linkCount: Number of links in deleted list
    static func trackListDeleted(linkCount: Int) {
        SentrySDK.metrics.count(
            key: "list.deleted",
            value: 1,
            unit: .generic("deletion"),
            attributes: [
                "link_count": linkCount
            ]
        )
    }

    /// Tracks bulk list deletion.
    /// - Parameter count: Number of lists deleted
    static func trackListDeletedBulk(count: Int) {
        SentrySDK.metrics.count(
            key: "list.deleted.bulk",
            value: 1,
            unit: .generic("deletion"),
            attributes: [
                "count": count
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
            unit: .generic("deletion"),
            attributes: [
                "list_link_count": listLinkCount
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
            unit: .generic("deletion"),
            attributes: [
                "count": count,
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
            unit: .generic("interaction"),
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
            unit: .generic("interaction"),
            attributes: attributes.isEmpty ? nil : attributes
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
            unit: .generic("completion"),
            attributes: [
                "list_selected": listSelected,
                "name_edited": nameEdited
            ]
        )
    }

    /// Tracks share extension cancellation.
    /// - Parameter step: Step where cancellation occurred ("initial" | "after_list_selection" | "after_name_edit")
    static func trackShareExtensionCancelled(step: String) {
        SentrySDK.metrics.count(
            key: "share_extension.cancelled",
            value: 1,
            unit: .generic("cancellation"),
            attributes: [
                "step": step
            ]
        )
    }

    // MARK: - NFC Metrics

    /// Tracks NFC availability (gauge).
    static func trackNFCAvailable() {
        SentrySDK.metrics.gauge(
            key: "nfc.available",
            value: 1.0,
            unit: .generic("capability")
        )
    }

    /// Tracks NFC share initiation.
    static func trackNFCShareInitiated() {
        SentrySDK.metrics.count(
            key: "nfc.share.initiated",
            value: 1,
            unit: .generic("share")
        )
    }

    /// Tracks successful NFC share.
    static func trackNFCShareSuccess() {
        SentrySDK.metrics.count(
            key: "nfc.share.success",
            value: 1,
            unit: .generic("share")
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
            unit: .generic("share"),
            attributes: attributes.isEmpty ? nil : attributes
        )
    }

    // MARK: - Database Performance

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

    // MARK: - App Health

    /// Tracks memory warning received.
    /// - Parameter cacheSizeAtWarning: Number of items in cache when warning received
    static func trackMemoryWarningReceived(cacheSizeAtWarning: Int) {
        SentrySDK.metrics.count(
            key: "memory.warning.received",
            value: 1,
            unit: .generic("warning"),
            attributes: [
                "cache_size_at_warning": cacheSizeAtWarning
            ]
        )
    }
}
// swiftlint:enable type_body_length file_length
