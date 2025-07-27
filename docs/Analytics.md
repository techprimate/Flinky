# Analytics & Tracking Documentation

This document describes the analytics and error tracking implementation in the Flinky iOS app using Sentry.

## Overview

Flinky implements a **privacy-first analytics strategy** that captures user behavior patterns and technical metrics while strictly protecting user-generated content (URLs, names, etc.). All tracking is implemented using Sentry with two primary mechanisms:

- **Breadcrumbs**: Session-scoped debugging context for error investigation
- **Analytics Events**: Persistent structured data for product insights

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

### Analytics Event Pattern
```swift
// Structured analytics event for product insights
let event = Event(level: .info)
event.message = SentryMessage(formatted: "event_name")
event.extra = [
    "entity_id": entity.id.uuidString,
    "entity_type": "link|list",
    "feature_context": "relevant_metadata"
]
SentrySDK.capture(event: event)
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

## Event Taxonomy

### Creation Events
- `link_created`: New link added to a list
- `list_created`: New list created

### Update Events  
- `link_color_selected`: Color customization for links
- `link_symbol_selected`: Symbol customization for links
- `list_color_selected`: Color customization for lists
- `list_symbol_selected`: Symbol customization for lists

### Sharing Events
- `link_shared`: Universal sharing event with method specification
- `link_shared_nfc`: NFC-specific sharing event for detailed analysis

### Interaction Events
- Link opening events (tracked via breadcrumbs)
- Navigation patterns (tracked via breadcrumbs)

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

// Analytics event for product insights
let event = Event(level: .info)
event.message = SentryMessage(formatted: "link_created")
event.extra = [
    "link_id": link.id.uuidString,
    "list_id": list.id.uuidString,
    "entity_type": "link",
    "creation_flow": "direct"
]
SentrySDK.capture(event: event)
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

// Universal sharing analytics
let event = Event(level: .info)
event.message = SentryMessage(formatted: "link_shared")
event.extra = [
    "link_id": item.id.uuidString,
    "sharing_method": "qr_code_share"
]
SentrySDK.capture(event: event)
```

### Customization Tracking
```swift
// Only track when user actually makes changes
if colorChanged {
    let colorEvent = Event(level: .info)
    colorEvent.message = SentryMessage(formatted: "link_color_selected")
    colorEvent.extra = [
        "color": color.rawValue,
        "entity_type": "link"
    ]
    SentrySDK.capture(event: colorEvent)
}
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
- **Events**: Persistent analytics data (no PII)
- **Errors**: Sanitized technical information only

### Debugging Capability
- Full technical debugging via entity IDs
- Error reproduction without privacy concerns
- Performance analysis with user behavior context

## Future Considerations

### Adding New Events
1. Follow established naming convention: `entity_action_context`
2. Include standard fields: `entity_id`, `entity_type`
3. Exclude any PII or user-generated content
4. Document in this file with examples

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
- [ ] Follows established event naming conventions
- [ ] Includes standard entity identification fields
- [ ] Has both breadcrumb (debugging) and event (analytics) tracking
- [ ] Includes explanatory comments explaining the tracking rationale
- [ ] Tested to ensure compilation and runtime success
- [ ] Documented in this file with examples

---

This analytics implementation provides **comprehensive product insights** while maintaining **strict privacy protection** for user data. The approach enables data-driven product decisions without compromising user trust or regulatory compliance. 