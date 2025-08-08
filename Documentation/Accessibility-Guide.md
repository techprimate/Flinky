# Accessibility Guide for Flinky

This document outlines the comprehensive accessibility improvements implemented in the Flinky app to ensure excellent VoiceOver support and adherence to iOS accessibility best practices.

## Overview

Flinky has been designed with accessibility as a first-class feature, ensuring that all users, including those who rely on assistive technologies like VoiceOver, can effectively use the app to manage their links and lists.

## Accessibility Features

### 1. Localized Accessibility Strings

All accessibility labels, hints, and descriptions are localized using the `L10n.Accessibility` enum structure, supporting internationalization and providing clear, contextual information to VoiceOver users.

#### Key Accessibility String Categories:

- **Button Labels**: `L10n.Accessibility.Button.*`
  - `cancel`, `done`, `save`, `edit`, `delete`
  - `newLink`, `newList`

- **Form Fields**: `L10n.Accessibility.Form.*`
  - `nameField`, `titleField`, `urlField`

- **Actions**: `L10n.Accessibility.*`
  - `deleteLink(title)`, `editLink(title)`
  - `deleteList(title)`, `editList(title)`
  - `pinList(title)`, `unpinList(title)`
  - `shareLink(title)`

- **Interactive Elements**:
  - `linkItem(title, url)`, `listItem(title, count)`
  - `pinnedListCard(title, count)`

- **Hints**: `L10n.Accessibility.Hint.*`
  - `doubleTabViewDetails`, `doubleTabEdit`
  - `tripleTabActions`

- **Components**:
  - `colorPicker(selection)`, `symbolPicker(selection)`
  - `colorOption(name)`, `symbolOption(name)`
  - `emojiPicker`

- **Toast Notifications**: `L10n.Accessibility.Toast.*`
  - `error(message)`, `success(message)`
  - `warning(message)`, `info(message)`

### 2. Grid Picker Accessibility

Enhanced `GridPicker` and `AdvancedGridPicker` components with:

- **Accessibility Elements**: Each picker item is properly combined using `accessibilityElement(children: .combine)`
- **Selection State**: Items announce their selection state with `.isSelected` trait
- **Button Traits**: All picker items have `.isButton` trait for proper interaction
- **Contextual Hints**: "Double tap to select" hints for clear interaction guidance
- **Emoji Picker**: Special handling for custom emoji selection with descriptive labels

### 3. Form Accessibility

All form elements include:

- **Descriptive Labels**: Clear field identification using `accessibilityLabel`
- **Input Hints**: Helpful guidance using `accessibilityHint`
- **Validation Feedback**: Error messages are properly announced
- **Field Navigation**: Logical tab order with `@FocusState` management
- **Save State Feedback**: Dynamic hints based on form validity

### 4. List Item Accessibility

#### Link Items (`LinkDetailItemView`)

- **Combined Elements**: Link title and URL announced together
- **Action Feedback**: Clear swipe actions with localized labels
- **Context Menus**: Fully accessible with proper role assignments
- **Interaction Hints**: Clear guidance for VoiceOver users

#### List Items (`LinkListItemView`)

- **Item Counts**: List titles include item counts in accessibility labels
- **Pin/Unpin Actions**: Clear state communication for pinned lists
- **Swipe Actions**: Edit, pin, and delete actions with descriptive labels

#### Pinned Cards (`PinnedLinkListCardView`)

- **Card Identity**: Clearly identifies as "Pinned list" with title and count
- **Button Traits**: Proper button behavior for navigation
- **Context Actions**: Full context menu support

### 5. Navigation Accessibility

- **Toolbar Buttons**: All toolbar items have descriptive labels and hints
- **Navigation Titles**: Localized navigation titles throughout the app
- **Cancel/Save Actions**: Consistent accessibility patterns across forms
- **Dynamic Hints**: Save buttons provide context-specific guidance

### 6. QR Code Accessibility

QR code images include:

- **Descriptive Labels**: "QR code for [URL]"
- **Functional Hints**: "QR code that can be scanned to open this link"
- **State Announcements**: Loading and error states properly announced

### 7. Toast Notifications

Alert toasts provide:

- **Status Context**: Error, success, warning, or info prefixes
- **Static Text Trait**: Proper announcement without button confusion
- **Message Content**: Full message content is accessible

## Implementation Best Practices

### 1. Accessibility Element Grouping

```swift
.accessibilityElement(children: .combine)
```

Used strategically to group related content for coherent VoiceOver reading.

### 2. Accessibility Traits

Proper traits applied throughout:

- `.isButton` for interactive elements
- `.isSelected` for selection states
- `.isStaticText` for informational content

### 3. Dynamic Accessibility

Context-sensitive accessibility content:

- Form validation state affects hints
- Selection states are properly announced
- Loading states provide feedback

### 4. Localization Integration

All accessibility strings are:

- Stored in `Localizable.xcstrings`
- Generated using SwiftGen
- Accessible via `L10n.Accessibility.*` structure
- Properly parameterized for dynamic content

## Testing Guidelines

### VoiceOver Testing Checklist

1. **Navigation Flow**
   - [ ] All screens are navigable with VoiceOver
   - [ ] Focus order is logical and intuitive
   - [ ] No unreachable interactive elements

2. **Content Announcement**
   - [ ] All meaningful content is announced
   - [ ] Dynamic content updates are announced
   - [ ] Error states are clearly communicated

3. **Interaction Feedback**
   - [ ] Button presses provide appropriate feedback
   - [ ] Form submissions announce success/failure
   - [ ] Selection changes are announced

4. **Gesture Support**
   - [ ] Standard VoiceOver gestures work as expected
   - [ ] Custom gestures (if any) are accessible
   - [ ] Swipe actions are accessible via rotor

### Accessibility Inspector Testing

Use Xcode's Accessibility Inspector to verify:

- No accessibility warnings or errors
- Proper element hierarchy
- Correct trait assignments
- Adequate contrast ratios

## Maintenance Guidelines

### Adding New UI Components

When adding new components:

1. **Add Accessibility Strings**: Update `Localizable.xcstrings` with appropriate labels and hints
2. **Regenerate Localization**: Run `make generate-localization` to update `L10n` enum
3. **Apply Traits**: Add appropriate accessibility traits (`.isButton`, `.isSelected`, etc.)
4. **Test with VoiceOver**: Verify the new component works correctly with VoiceOver

### Accessibility String Naming Convention

Follow this pattern for consistency:

- **Labels**: `accessibility.[component]_[action]` (e.g., `accessibility.delete_link`)
- **Hints**: `accessibility.hint.[action]` (e.g., `accessibility.hint.double_tap_edit`)
- **Buttons**: `accessibility.button.[action]` (e.g., `accessibility.button.save`)
- **Forms**: `accessibility.form.[field]` (e.g., `accessibility.form.title_field`)

### Regular Accessibility Audits

Perform quarterly accessibility audits:

1. Test all user flows with VoiceOver
2. Verify new features have proper accessibility
3. Update documentation as needed
4. Test with various VoiceOver speech rates

## Resources

### Apple Documentation

- [Accessibility Programming Guide for iOS](https://developer.apple.com/accessibility/ios/)
- [VoiceOver Testing Guide](https://developer.apple.com/documentation/accessibility/accessibility_for_developers/testing_for_accessibility_with_voiceover)
- [Accessibility Modifiers](https://developer.apple.com/documentation/swiftui/view-accessibility)

### Tools

- **Accessibility Inspector**: Built into Xcode for testing
- **VoiceOver**: iOS screen reader for real-device testing
- **Voice Control**: Additional accessibility testing

## Conclusion

The Flinky app demonstrates comprehensive accessibility implementation, ensuring that all users can effectively manage their links and lists regardless of their assistive technology needs. The localized, systematic approach to accessibility ensures maintainability and consistency across the entire app.

Regular testing and adherence to these guidelines will maintain Flinky's excellent accessibility support as the app evolves.
