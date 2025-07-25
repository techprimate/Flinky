import SwiftUI

public struct AlertToastStackModifier: ViewModifier {
    @Binding var stack: [AlertToastStackItem]

    var offsetY: CGFloat = 0

    @State private var workItems: [AlertToastStackItem.ID: DispatchWorkItem] = [:]

    @State private var hostRect: CGRect = .zero
    @State private var alertRect: CGRect = .zero

    private var screen: CGRect {
        UIScreen.main.bounds
    }

    @ViewBuilder
    public func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                Color.clear.onAppear {
                    let rect = proxy.frame(in: .global)
                        .offsetBy(dx: 0, dy: -proxy.safeAreaInsets.top)
                    guard rect.integral != hostRect.integral else {
                        return
                    }
                    DispatchQueue.main.async {
                        hostRect = rect
                    }
                }
            })
            .overlay(overlayView)
            .onChange(of: stack) {
                onAppearAction()
            }
    }

    private var overlayView: some View {
        ZStack(alignment: .top) {
            mainView
                .readFrame(in: .global) { rect in
                    guard rect.integral != alertRect.integral else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.alertRect = rect
                    }
                }
        }
        .frame(maxWidth: screen.width, maxHeight: screen.height)
        .offset(y: -hostRect.midY + alertRect.height / 2)
    }

    @ViewBuilder
    public var mainView: some View {
        VStack(alignment: .center, spacing: 10) {
            ForEach(Array(stack.enumerated()), id: \.element) { idx, item in
                AlertToast(item: item.asToastItem)
                    .zIndex(Double(idx))
                    .onTapGesture {
                        guard item.tapToDismiss else {
                            return
                        }
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.workItems[item.id]?.cancel()
                            self.workItems[item.id] = nil
                            stack.removeAll(where: { $0.id == item.id })
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .opacity.combined(with: .scale(scale: 0.8))
                    ))
            }
            Spacer(minLength: 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .animation(.easeInOut(duration: 0.3), value: stack)
    }

    private func onAppearAction() {
        for item in stack {
            guard workItems[item.id] == nil, item.duration > 0 else {
                return
            }
            workItems[item.id]?.cancel()
            let task = DispatchWorkItem {
                withAnimation(.easeInOut(duration: 0.3)) {
                    stack.removeAll(where: { $0.id == item.id })
                    workItems[item.id] = nil
                }
            }
            workItems[item.id] = task
            DispatchQueue.main.asyncAfter(deadline: .now() + item.duration, execute: task)
        }
    }
}

// MARK: - Window-Based Toast Stack

/// Simple toast stack view for use in window-based approach
public struct ToastStackView: View {
    @ObservedObject var toastManager: ToastManager
    
    public var body: some View {
        VStack(spacing: 0) {
            // Toast container at the top
            VStack(spacing: 10) {
                ForEach(Array(toastManager.toastStack.enumerated()), id: \.element) { idx, item in
                    AlertToast(item: item.asToastItem)
                        .zIndex(Double(idx))
                        .allowsHitTesting(item.tapToDismiss) // Only allow hits if tap to dismiss is enabled
                        .onTapGesture {
                            guard item.tapToDismiss else { return }
                            withAnimation(.easeInOut(duration: 0.3)) {
                                toastManager.dismiss(item.id)
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .opacity.combined(with: .scale(scale: 0.8))
                        ))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16) // Simple top padding - let safe area be handled naturally
            .frame(maxWidth: .infinity, alignment: .center)
            .animation(.easeInOut(duration: 0.3), value: toastManager.toastStack)
            
            Spacer()
        }
        .ignoresSafeArea(.all, edges: .bottom) // Only ignore bottom safe area
    }
}

public extension View {
    func toastStack(
        stack: Binding<[AlertToastStackItem]>,
        offsetY _: CGFloat = 12,
        duration _: Double = 2
    ) -> some View {
        modifier(AlertToastStackModifier(stack: stack))
    }
}

struct AlertToastStackModifier_Previews: PreviewProvider {
    struct Container: View {
        @State var stack: [AlertToastStackItem] = []
        @State var counter = 0

        var body: some View {
            NavigationView {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Present Toast") {
                            counter += 1
                            let duration = TimeInterval.random(in: 0 ..< 5)
                            stack.append(.init(title: "Message \(counter) - \(duration)s", duration: duration))
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Some Title")
            }
            .toastStack(stack: $stack)
        }
    }

    static var previews: some View {
        Container()
    }
}

