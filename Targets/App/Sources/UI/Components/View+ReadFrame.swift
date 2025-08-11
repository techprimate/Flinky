import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .null

    static func reduce(value _: inout CGRect, nextValue _: () -> CGRect) {}
}

extension View {
    func readFrame(in coordinateSpaceName: CoordinateSpace, onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(
                        key: FramePreferenceKey.self,
                        value:
                            geometryProxy
                            .frame(in: coordinateSpaceName)
                    )
            }
        ).onPreferenceChange(
            FramePreferenceKey.self,
            perform: { arg in
                DispatchQueue.main.async {
                    onChange(arg)
                }
            }
        )
    }
}
