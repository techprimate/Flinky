# Analytics & Tracking Documentation

This document describes the analytics and error tracking implementation in the Flinky iOS app using Sentry.

## Overview

Flinky implements a **privacy-first analytics strategy** that captures user behavior patterns and technical metrics while strictly protecting user-generated content (URLs, names, etc.). All tracking is implemented using Sentry with four primary mechanisms:

- **SwiftUI View Tracing**: Automatic performance monitoring of view rendering and navigation flows
- **Breadcrumbs**: Session-scoped debugging context for error investigation
- **Metrics**: Aggregate counters for user behavior patterns (replaces individual analytics events)
- **Error Events**: Individual error events for debugging actual issues

## SwiftUI View Tracing

### Overview

Every container view in the app implements Sentry's SwiftUI view tracing using the `.sentryTrace()` modifier. This provides automatic performance monitoring, view rendering metrics, and navigation flow analysis.

### Implementation Pattern

```swift
struct ExampleContainerView: View {
    var body: some View {
        ExampleRenderView(...)
            .sentryTrace("VIEW_NAME")
    }
}
```

### Traced Views

All major views are instrumented for comprehensive performance monitoring:

- `MAIN_VIEW` - Root navigation container
- `LINK_LISTS_VIEW` - Main lists overview
- `LINK_LIST_DETAIL_VIEW` - Individual list contents
- `LINK_DETAIL_VIEW` - Link details with QR codes
- `CREATE_LINK_EDITOR_VIEW` - Link creation form
- `CREATE_LINK_LIST_EDITOR_VIEW` - List creation form
- `CREATE_LINK_WITH_LIST_PICKER_EDITOR_VIEW` - Link creation with list selection
- `LINK_LIST_PICKER_VIEW` - List selection interface
- `LINK_EDITOR_VIEW` - Link editing form
- `LINK_LIST_EDITOR` - List editing form
- `LINK_DETAIL_NFC_SHARING` - NFC sharing interface

### Benefits

- **Performance Monitoring**: Automatic tracking of view rendering times
- **Navigation Analysis**: User flow patterns and bottlenecks
- **Error Context**: View-specific error correlation
- **User Experience Metrics**: Time-to-interactive measurements

### Best Practices

1. **Modifier Placement**: Place `.sentryTrace()` after other modifiers but before sheets/alerts to capture complete view lifecycle
2. **Naming Convention**: Use `SCREAMING_SNAKE_CASE` for consistency and clarity
3. **Descriptive Names**: Use clear, descriptive names that identify the view's purpose
4. **Container Views Only**: Apply to container views, not render views, to avoid duplicate tracking

### Example Implementation

```swift
struct LinkDetailContainerView: View {
    var body: some View {
        LinkDetailRenderView(...)
            .task(priority: .utility) {
                await createQRCodeImageInBackground()
            }
            // Place sentryTrace after task to capture main thread execution
            .sentryTrace("LINK_DETAIL_VIEW")
            .sheet(isPresented: $isEditing) {
                NavigationStack {
                    LinkInfoContainerView(link: item)
                }
            }
    }
}
```

## Privacy Principles

### ✅ What We Track (Safe)

- **Entity Identifiers**: UUIDs for links and lists (non-PII)
- **Interaction Types**: Button clicks, sharing methods, navigation patterns
- **Feature Usage**: Color/symbol selections, customization engagement
- **Technical Metrics**: Success/failure rates, error patterns
- **User Flows**: Creation patterns, sharing behaviors

### ❌ What We DON'T Track (Privacy Protected)

- **URLs**: User's private link destinations
- **Names**: List names, link titles, or any user-generated labels
- **Content**: Any personally identifiable information (PII)
- **Device IDs**: Personal device identifiers

## Tracking Categories

### 1. Link Management (`link_management`)

- Link creation, updates, and modifications
- Color and symbol customization for links

### 2. List Management (`list_management`)

- List creation, updates, and modifications
- Color and symbol customization for lists

### 3. Link Interaction (`link_interaction`)

- Opening links in Safari
- Link engagement patterns

### 4. Link Sharing (`link_sharing`)

- All sharing methods: copy URL, QR codes, NFC, system share
- Sharing success/failure patterns

## Metrics (Primary Analytics Mechanism)

### Overview

Sentry Metrics provide aggregate counters for tracking user behavior patterns. Unlike individual events, metrics don't create "issues" in Sentry and are better suited for analytics that only need aggregate counts. Metrics are enabled by default in Sentry SDK 9.2.0+.

### Avoiding Overlap with Tracing

Before adding new metrics, verify they don't duplicate what Sentry already tracks automatically. Reference: [sentry-cocoa#7000](https://github.com/getsentry/sentry-cocoa/issues/7000)

**Already Tracked via Tracing (DO NOT DUPLICATE):**

- App Start (cold/warm start duration)
- UIViewController load times
- Slow/Frozen frames
- Network request performance (NSURLSession)
- File I/O operations (NSData, NSFileManager)
- Core Data fetch/save
- User interaction clicks
- Time to Initial/Full Display (TTID/TTFD)

**Already Tracked via Events/Sessions:**

- App Hangs (main thread blocking)
- Watchdog Terminations (OOM, system kills)
- MetricKit diagnostics
- Release health (crash-free sessions)
- HTTP client errors (4xx/5xx)

### When to Use Metrics vs Events

**Use Metrics For:**

- User actions (clicks, creations, sharing)
- Feature usage tracking
- Aggregate behavior patterns
- Analytics that only need counts
- System health signals (memory warnings, thermal state, network changes)

**Use Events For:**

- Actual errors that need investigation
- Exceptional conditions requiring debugging
- Issues that need individual attention

### Metrics Helper Utility

The app provides `SentryMetricsHelper` with type-safe wrapper functions for common metrics:

```swift
import Sentry

// Link creation
SentryMetricsHelper.trackLinkCreated(creationFlow: "direct", listId: list.id.uuidString)

// List creation
SentryMetricsHelper.trackListCreated(creationFlow: "direct", autoCreated: false)

// Link sharing
SentryMetricsHelper.trackLinkShared(sharingMethod: "copy_url", linkId: link.id.uuidString)

// Customization
SentryMetricsHelper.trackColorSelected(color: color.rawValue, entityType: "link")
SentryMetricsHelper.trackSymbolSelected(symbol: symbol.rawValue, entityType: "list")

// Feedback
SentryMetricsHelper.trackFeedbackFormOpened()
SentryMetricsHelper.trackFeedbackFormClosed()

// Database seeding
SentryMetricsHelper.trackDatabaseSeedingStarted()
SentryMetricsHelper.trackDatabaseSeedingCompleted()
```

### Direct Metrics API Usage

For cases not covered by the helper, use Sentry's metrics API directly:

```swift
import Sentry

// Counter metric
SentrySDK.metrics.count(
    key: "custom.metric.name",
    value: 1,
    unit: .generic("unit"),
    attributes: [
        "attribute_name": "value",
        "entity_type": "link"
    ]
)
```

## Implementation Patterns

### Breadcrumb Pattern

```swift
// Privacy-conscious breadcrumb for debugging context
let breadcrumb = Breadcrumb(level: .info, category: "category_name")
breadcrumb.message = "Operation completed successfully"
breadcrumb.data = [
    "entity_id": entity.id.uuidString,
    "interaction_type": "specific_action",
    // Only non-PII metadata
]
SentrySDK.addBreadcrumb(breadcrumb)
```

### Metrics Pattern (Preferred for Analytics)

```swift
// Use metrics helper for type-safe analytics tracking
SentryMetricsHelper.trackLinkCreated(creationFlow: "direct", listId: list.id.uuidString)

// Or use metrics API directly with attributes
SentrySDK.metrics.count(
    key: "link.created",
    value: 1,
    unit: .generic("link"),
    attributes: [
        "creation_flow": "direct",
        "entity_type": "link",
        "list_id": list.id.uuidString
    ]
)
```

### Error Event Pattern (For Actual Errors)

```swift
// Only use events for actual errors that need investigation
let appError = AppError.persistenceError(.saveLinkFailed(underlyingError: error.localizedDescription))
SentrySDK.capture(error: appError)
```

### Error Tracking Pattern

```swift
// Following established memory pattern for consistent error handling
do {
    try performOperation()
} catch {
    let localDescription = "Failed to perform operation: \(error)"
    let appError = AppError.operationType(.specificError(underlyingError: error.localizedDescription))
    Sentry.captureException(appError)
    toaster.show(error: appError)
}
```

## Metrics Taxonomy

### Currently Implemented Metrics

The following metrics are currently tracked via `SentryMetricsHelper`:

#### Creation Metrics

- `link.created`: Counter for new links added to lists (attributes: `creation_flow`, `entity_type`, `list_id`)
- `list.created`: Counter for new lists created (attributes: `creation_flow`, `entity_type`, `auto_created`)

#### Customization Metrics

- `link.color.selected`: Counter for color customization on links (attributes: `color`, `entity_type`)
- `link.symbol.selected`: Counter for symbol customization on links (attributes: `symbol`, `entity_type`)
- `list.color.selected`: Counter for color customization on lists (attributes: `color`, `entity_type`)
- `list.symbol.selected`: Counter for symbol customization on lists (attributes: `symbol`, `entity_type`)

#### Sharing Metrics

- `link.shared`: Counter for all link sharing methods (attributes: `sharing_method`, `link_id`)
- `link.shared.nfc`: Counter for NFC-specific sharing (attributes: `sharing_method`, `link_id`)

#### Feedback Metrics

- `feedback.form.opened`: Counter for feedback form openings
- `feedback.form.closed`: Counter for feedback form closings

#### Database Metrics

- `database.seeding.started`: Counter for database seeding start
- `database.seeding.completed`: Counter for database seeding completion

#### App Health Metrics (System-Level Signals)

These metrics track system-level signals that don't overlap with Sentry's automatic tracing. They provide quick app/runtime health insights.

- `memory.warning.received`: Counter for memory warnings (attributes: `cache_size_at_warning`, `app_state`)
- `device.thermal.transition`: Counter for thermal state changes (attributes: `from_state`, `to_state`, `is_escalation`)
- `network.reachability.changed`: Counter for network connectivity changes (attributes: `status`, `interface`, `is_expensive`, `is_constrained`)
- `app.state.transition`: Counter for app state transitions (attributes: `to_state`, `from_state`)

#### Background Task Metrics

- `background.task.completed`: Counter for completed background tasks (attributes: `task_type`, `task_identifier`)
- `background.task.expired`: Counter for expired background tasks (attributes: `task_type`, `time_remaining`)
- `background.task.duration`: Distribution of background task duration (attributes: `task_type`, `outcome`)

#### Link Metadata Metrics

- `link.metadata.fetched`: Counter for link metadata fetches (attributes: `outcome`, `has_image`, `has_video`, `content_type`)
- `link.metadata.fetch.duration`: Distribution of metadata fetch duration (attributes: `outcome`)

### Recommended Development Metrics

The following metrics are recommended for future implementation to gain deeper insights into app performance, user behavior, and feature adoption. These are organized by priority and category.

#### High Priority Metrics (Immediate Value)

**Performance Metrics**

- `qr_code.generation.duration` (Distribution) - Track QR code generation time
  - Attributes: `cache_hit` (boolean), `image_size` (string)
  - Implementation: Measure in `LinkDetailContainerView.createQRCodeImageInBackground()`

- `qr_code.cache.hit` (Counter) - Track cache hits
  - Implementation: Track in `QRCodeCache.image(forContent:)` when image found

- `qr_code.cache.miss` (Counter) - Track cache misses
  - Implementation: Track in `QRCodeCache.image(forContent:)` when image not found

**Error Rate Metrics**

- `error.rate` (Counter) - Track error frequency by type
  - Attributes: `error_type` ("persistence" | "qr_generation" | "nfc" | "validation" | "data_corruption")
  - Implementation: Aggregate from existing `SentrySDK.capture(error:)` calls

**Feature Adoption Metrics**

- `share_extension.completed` (Counter) - Track successful share extension completions
  - Attributes: `list_selected` (boolean), `name_edited` (boolean)
  - Implementation: Track in `ShareViewController.didSelectPost()` when save succeeds

- `search.performed` (Counter) - Track search usage
  - Attributes: `search_context` ("lists" | "links"), `result_count` (number)
  - Implementation: Track when `searchText` changes from empty to non-empty

#### Medium Priority Metrics (Useful Insights)

**User Behavior Metrics**

- `list.pinned` / `list.unpinned` (Counter) - Track list pinning actions
- `link.deleted` / `list.deleted` (Counter) - Track deletion patterns
  - Attributes: `link_count` (for lists), `list_link_count` (for links)
- `link.opened` (Counter) - Track Safari link opens
  - Attributes: `sharing_method` (optional)

**Feature Adoption Metrics**

- `nfc.share.initiated` / `nfc.share.success` / `nfc.share.failed` (Counter) - Track NFC usage
- `nfc.available` (Gauge) - Track devices with NFC capability

**Performance Metrics**

- `database.query.duration` (Distribution) - Track SwiftData query performance
  - Attributes: `query_type` ("fetch_lists" | "fetch_links" | "save" | "delete")
- `database.save.duration` (Distribution) - Track save operation performance
  - Attributes: `entity_type`, `operation` ("create" | "update" | "delete")

#### Low Priority Metrics (Nice to Have)

**User Flow Metrics**

- `flow.creation.abandoned` (Counter) - Track abandoned creation flows
  - Attributes: `flow_type` ("link" | "list"), `step` ("name" | "url" | "customization")
- `flow.creation.completed` (Counter) - Track completed creation flows
  - Attributes: `flow_type`, `duration_seconds`

**App Health Metrics** ✅ IMPLEMENTED

The following metrics are now implemented via `AppHealthObserver`:

- ✅ `memory.warning.received` (Counter) - Track memory warnings
  - Attributes: `cache_size_at_warning` (number), `app_state` (string)
- ✅ `device.thermal.transition` (Counter) - Track thermal state changes
  - Attributes: `from_state`, `to_state`, `is_escalation`
  - Reference: [sentry-cocoa#7000](https://github.com/getsentry/sentry-cocoa/issues/7000)
- ✅ `network.reachability.changed` (Counter) - Track network connectivity changes
  - Attributes: `status`, `interface`, `is_expensive`, `is_constrained`
  - Reference: [sentry-cocoa#7000](https://github.com/getsentry/sentry-cocoa/issues/7000)
- ✅ `app.state.transition` (Counter) - Track foreground/background transitions
  - Attributes: `to_state`, `from_state`

**Still TODO:**

- `app.launch` (Counter) - Track app launches (overlaps with App Start Tracing, consider if needed)
- `app.session.duration` (Distribution) - Track session duration

**Data Health Metrics**

- `data.links.per_list` (Distribution) - Average links per list (periodic calculation)
- `data.lists.count` (Distribution) - Number of lists per user (periodic calculation)
- `data.total.links` (Distribution) - Total links per user (periodic calculation)

See the [Implementation Notes](#implementation-notes) section for detailed implementation guidance for each metric.

## Data Structure Standards

### Entity Identification

```swift
"entity_id": uuid.uuidString     // Link or list UUID
"entity_type": "link" | "list"   // Enables cross-entity analytics
```

### Sharing Method Taxonomy

```swift
"sharing_method": [
    "copy_url",        // Copy URL to clipboard
    "qr_code_share",   // Share QR code via system share sheet
    "qr_code_save",    // Save QR code to Photos
    "nfc",             // Share via NFC
    "system_share"     // System share sheet for URL
]
```

### Customization Tracking

```swift
"color": color.rawValue          // Color selection (when changed)
"symbol": symbol.rawValue        // Symbol selection (when changed)
"color_changed": boolean         // Whether customization actually occurred
"symbol_changed": boolean        // Whether customization actually occurred
```

### Flow Differentiation

```swift
"creation_flow": [
    "direct",          // Created directly in a list
    "list_picker"      // Created via list picker flow
]
```

## Implementation Examples

### Link Creation Tracking

```swift
// Breadcrumb for debugging context
let breadcrumb = Breadcrumb(level: .info, category: "link_management")
breadcrumb.message = "Link created successfully"
breadcrumb.data = [
    "link_id": link.id.uuidString,
    "list_id": list.id.uuidString,
    "has_color": false,
    "has_symbol": false
]
SentrySDK.addBreadcrumb(breadcrumb)

// Track creation using metrics (preferred for analytics)
SentryMetricsHelper.trackLinkCreated(creationFlow: "direct", listId: list.id.uuidString)
```

### Sharing Tracking

```swift
// Track specific sharing method
let breadcrumb = Breadcrumb(level: .info, category: "link_sharing")
breadcrumb.message = "QR code shared"
breadcrumb.data = [
    "link_id": item.id.uuidString,
    "sharing_method": "qr_code_share"
]
SentrySDK.addBreadcrumb(breadcrumb)

// Track sharing using metrics (preferred for analytics)
SentryMetricsHelper.trackLinkShared(sharingMethod: "qr_code_share", linkId: item.id.uuidString)
```

### Customization Tracking

```swift
// Only track when user actually makes changes
if colorChanged {
    // Track using metrics (preferred for analytics)
    SentryMetricsHelper.trackColorSelected(color: color.rawValue, entityType: "link")
}
```

### NFC Sharing (Dual Metrics)

```swift
// NFC sharing generates dual metrics for comprehensive analysis
SentryMetricsHelper.trackLinkSharedNFC(linkId: link.id.uuidString)  // NFC-specific
SentryMetricsHelper.trackLinkShared(sharingMethod: "nfc", linkId: link.id.uuidString)  // General sharing
```

## Special Considerations

### NFC Sharing

NFC sharing generates **dual events** for comprehensive analysis:

1. **Specific NFC Event** (`link_shared_nfc`): Detailed NFC success/failure patterns
2. **General Sharing Event** (`link_shared`): Inclusion in overall sharing metrics

### ShareLink Integration

System ShareLink requires `simultaneousGesture` instead of `onTapGesture` to avoid interfering with built-in tap handling while still capturing analytics.

### Error Context

Error events include sanitized context with entity IDs only:

```swift
event.context = [
    "link": [
        "link_id": item.id.uuidString  // No URLs or names
    ]
]
```

## Analytics Queries & Insights

### User Engagement

- Link creation frequency and patterns
- Sharing method popularity comparison
- Customization feature adoption rates

### Feature Performance

- Sharing success rates by method
- Error patterns and recovery flows
- Cross-platform behavior differences

### Product Development

- Most/least used features for prioritization
- User flow optimization opportunities
- Feature rollout impact measurement

## Compliance & Privacy

### GDPR Compliance

- No personal data stored in analytics
- Entity IDs are app-specific, non-correlatable
- User content never transmitted

### Data Retention

- **Breadcrumbs**: Session-scoped, cleared on app restart
- **Metrics**: Aggregated counters for analytics (no PII)
- **Error Events**: Sanitized technical information only

### Debugging Capability

- Full technical debugging via entity IDs
- Error reproduction without privacy concerns
- Performance analysis with user behavior context

## Metrics Migration

### Migration from Events to Metrics

As of the metrics migration, analytics tracking has moved from individual `SentrySDK.capture(event:)` calls to Sentry Metrics API. This provides:

- **Better Aggregation**: Built-in aggregation and querying capabilities
- **Reduced Noise**: Metrics don't create individual "issues" in Sentry
- **Performance**: More efficient than individual events
- **Cost**: Potentially lower cost than individual events

### Migration Checklist

All analytics events have been migrated to metrics:

- ✅ Link creation events → `link.created` metric
- ✅ List creation events → `list.created` metric
- ✅ Sharing events → `link.shared` metric
- ✅ Customization events → `link.color.selected`, `link.symbol.selected`, etc.
- ✅ Feedback events → `feedback.form.opened`, `feedback.form.closed` metrics
- ✅ Database seeding events → `database.seeding.started`, `database.seeding.completed` metrics

Error events (`SentrySDK.capture(error:)`) remain as events since they represent actual issues that need investigation.

## Implementation Notes

### Metric Naming Convention

Follow the established pattern: `category.subcategory.metric`

- Use dot-delimited lowercase
- Be descriptive but concise
- Group related metrics by category
- Examples:
  - `qr_code.generation.duration`
  - `link.deleted.bulk`
  - `share_extension.completed`

### Attributes Best Practices

- Keep attributes minimal (max 5-7 per metric)
- Use consistent attribute names across metrics
- Prefer enums/strings over free-form text
- Include context that enables filtering/grouping
- Examples:
  - `entity_type`: "link" | "list"
  - `error_type`: "persistence" | "qr_generation" | "nfc"
  - `search_context`: "lists" | "links"

### Real-time vs Periodic Metrics

- **Real-time**: User actions, errors, performance measurements
- **Periodic**: Data distribution metrics (calculate on app launch or background)

### Leveraging Existing Infrastructure

- **Sentry Tracing**: Use for view rendering performance (already implemented)
- **Error Events**: Aggregate existing error captures for error rate metrics
- **QRCodeCache**: Add metrics tracking directly in cache class
- **SwiftData**: Wrap operations for database performance metrics

### Questions These Metrics Answer

1. **Performance**: Are QR codes generating fast enough? Is cache effective?
2. **Adoption**: Are users discovering and using key features (NFC, search, customization)?
3. **Reliability**: What's the error rate? Are errors recoverable?
4. **Usage Patterns**: How do users organize their links? How many links/lists do they have?
5. **Feature Value**: Which features provide the most value? Which are rarely used?
6. **User Experience**: Where do users abandon flows? How deep do they navigate?
7. **Data Health**: Are users creating empty lists? How often do they update links?

## Future Considerations

### Adding New Metrics

1. Use `SentryMetricsHelper` for common patterns when possible
2. Follow established naming convention: `entity.action.detail` (dot-delimited lowercase)
3. Include standard attributes: `entity_type`, `creation_flow`, etc.
4. Exclude any PII or user-generated content
5. Document in this file with examples
6. Add helper function to `SentryMetricsHelper` if pattern is reusable
7. Prioritize high-value metrics that answer specific development questions

### Privacy Reviews

- All new tracking must pass privacy audit
- Any user-generated content is strictly prohibited
- Entity IDs and interaction types only

### Analytics Evolution

- Maintain backward compatibility in event schemas
- Version analytics events if breaking changes needed
- Keep privacy protections as non-negotiable constraints

## Implementation Checklist

When adding new analytics:

- [ ] Uses privacy-safe data only (no URLs, names, content)
- [ ] Uses metrics (not events) for analytics tracking
- [ ] Follows established metric naming conventions (`entity.action.detail`)
- [ ] Includes standard entity identification attributes
- [ ] Has both breadcrumb (debugging) and metric (analytics) tracking
- [ ] Uses `SentryMetricsHelper` when possible, or metrics API directly
- [ ] Includes explanatory comments explaining the tracking rationale
- [ ] Tested to ensure compilation and runtime success
- [ ] Documented in this file with examples

---

This analytics implementation provides **comprehensive product insights** while maintaining **strict privacy protection** for user data. The approach enables data-driven product decisions without compromising user trust or regulatory compliance.
