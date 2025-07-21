import SwiftUI

public struct AlertToast: View {
    private struct Style {
        var backgroundColor: Color
        var foregroundColor: Color
    }
    
    private let item: AlertToastItem
    
    public init(item: AlertToastItem) {
        self.item = item
    }
    
    public var body: some View {
        Group {
            VStack(alignment: .center, spacing: 2) {
                title
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .frame(minHeight: 40)
            .background(style.backgroundColor)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.gray.opacity(0.2), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 6)
            .padding(.horizontal, 8)
            .compositingGroup()
        }
    }
    
    private var title: some View {
        Text(item.title)
            .foregroundColor(style.foregroundColor)
            .font(.system(size: 16, weight: .medium))
            .multilineTextAlignment(.center)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityAddTraits(.isStaticText)
    }
    
    private var accessibilityLabel: String {
        switch item.status {
        case .info:
            return L10n.Accessibility.Toast.info(item.title)
        case .error:
            return L10n.Accessibility.Toast.error(item.title)
        case .success:
            return L10n.Accessibility.Toast.success(item.title)
        case .warning:
            return L10n.Accessibility.Toast.warning(item.title)
        }
    }
    
    private var style: Style {
        switch item.status {
        case .info:
            return .init(
                backgroundColor: .white,
                foregroundColor: .black
            )
        case .error:
            return .init(
                backgroundColor: .red,
                foregroundColor: .white
            )
        case .success:
            return .init(
                backgroundColor: .green,
                foregroundColor: .white
            )
        case .warning:
            return .init(
                backgroundColor: .orange,
                foregroundColor: .white
            )
        }
    }
}

#Preview {
    VStack {
        AlertToast(item: .init(
            title: "kula is going live soon",
            status: .info
        ))
        AlertToast(item: .init(
            title: "Data uploaded to the server!",
            status: .success
        ))
        AlertToast(item: .init(
            title: "Seems your account is about to expire",
            status: .warning
        ))
        AlertToast(item: .init(
            title: "There was an error processing your request",
            status: .error
        ))
    }
}
