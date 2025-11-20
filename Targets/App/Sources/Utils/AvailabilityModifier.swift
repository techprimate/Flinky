import SwiftUI

/// A set of iOS versions that can be checked for availability.
struct AvailabilityOSVersion: OptionSet {
    let rawValue: UInt

    /// iOS 18 availability flag.
    static var iOS18 = Self(rawValue: 1 << 0)

    /// iOS 26 availability flag.
    static var iOS26 = Self(rawValue: 1 << 1)
}

extension View {

    /// Conditionally applies a view modifier when all specified iOS versions are available.
    ///
    /// - Parameter versions: A set of iOS versions that must all be available for the modifier to be applied.
    /// - Parameter modify: A closure that takes the view and returns a modified view.
    /// - Returns: The modified view if all versions are available, otherwise returns the original view.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .ifAvailable(.iOS18) { view in
    ///         view.someNewModifier()
    ///     }
    /// ```
    func ifAvailable<T: View>(_ versions: AvailabilityOSVersion, @ViewBuilder modify: (Self) -> T) -> some View {
        return ifAvailable(versions, modify: modify, elseModify: { $0 })
    }

    /// Conditionally applies a view modifier when all specified iOS versions are available.
    ///
    /// - Parameter versions: A set of iOS versions that must all be available for the modifier to be applied.
    /// - Parameter modify: A closure that takes the view and returns a modified view.
    /// - Returns: The modified view if all versions are available, otherwise returns the original view.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .ifAvailable(.iOS18) { view in
    ///         view.someNewModifier()
    ///     }
    /// ```
    @ViewBuilder func ifAvailable<T: View, U: View>(
        _ versions: AvailabilityOSVersion,
        @ViewBuilder modify: (Self) -> T,
        @ViewBuilder elseModify: (Self) -> U
    ) -> some View {
        if areVersionsAvailable(versions) {
            modify(self)
        } else {
            elseModify(self)
        }
    }

    /// Conditionally applies a view modifier when all specified iOS versions are unavailable.
    ///
    /// - Parameter versions: A set of iOS versions that must all be unavailable for the modifier to be applied.
    /// - Parameter modify: A closure that takes the view and returns a modified view.
    /// - Returns: The modified view if all versions are unavailable, otherwise returns the original view.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .ifUnvailable(.iOS26) { view in
    ///         view.fallbackModifier()
    ///     }
    /// ```
    func ifUnavailable<T: View>(_ versions: AvailabilityOSVersion, @ViewBuilder modify: (Self) -> T) -> some View {
        return ifUnavailable(versions, modify: modify, elseModify: { $0 })
    }

    /// Conditionally applies a view modifier when all specified iOS versions are unavailable.
    ///
    /// - Parameter versions: A set of iOS versions that must all be unavailable for the modifier to be applied.
    /// - Parameter modify: A closure that takes the view and returns a modified view.
    /// - Returns: The modified view if all versions are unavailable, otherwise returns the original view.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .ifUnvailable(.iOS26) { view in
    ///         view.fallbackModifier()
    ///     }
    /// ```
    @ViewBuilder func ifUnavailable<T: View, U: View>(
        _ versions: AvailabilityOSVersion,
        @ViewBuilder modify: (Self) -> T,
        @ViewBuilder elseModify: (Self) -> U
    ) -> some View {
        if areVersionsUnavailable(versions) {
            modify(self)
        } else {
            elseModify(self)
        }
    }
}

/// Checks if all specified iOS versions are available on the current platform.
///
/// - Parameter versions: A set of iOS versions to check.
/// - Returns: `true` if all specified versions are available, `false` if the set is empty or any version is unavailable.
private func areVersionsAvailable(_ versions: AvailabilityOSVersion) -> Bool {
    guard !versions.isEmpty else { return false }

    var allAvailable = true
    if versions.contains(.iOS18) {
        if #unavailable(iOS 18) {
            allAvailable = false
        }
    }
    if versions.contains(.iOS26) {
        if #unavailable(iOS 26) {
            allAvailable = false
        }
    }

    return allAvailable
}

/// Checks if all specified iOS versions are unavailable on the current platform.
///
/// - Parameter versions: A set of iOS versions to check.
/// - Returns: `true` if all specified versions are unavailable, `false` if the set is empty or any version is available.
private func areVersionsUnavailable(_ versions: AvailabilityOSVersion) -> Bool {
    guard !versions.isEmpty else { return false }

    var allUnavailable = true
    if versions.contains(.iOS18) {
        if #available(iOS 18, *) {
            allUnavailable = false
        }
    }
    if versions.contains(.iOS26) {
        if #available(iOS 26, *) {
            allUnavailable = false
        }
    }

    return allUnavailable
}
