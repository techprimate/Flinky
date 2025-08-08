import SwiftUI

struct RoundedIconLabelStyle: LabelStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
                .background(color)
                .clipShape(Circle())
            configuration.title
        }
    }
}
