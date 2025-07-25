import UIKit
import SwiftUI

open class PassThroughWindow: UIWindow {
    /// Used to identify the window by name while debugging
    let name: String

    public init(name: String, windowScene: UIWindowScene) {
        self.name = name
        super.init(windowScene: windowScene)

        // Ensure window stays at correct level and handles safe area properly
        self.backgroundColor = .clear
        self.isOpaque = false
    }

    @available(*, unavailable)
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        // Force a layout update when safe area changes
        DispatchQueue.main.async {
            self.rootViewController?.view.setNeedsLayout()
            self.rootViewController?.view.layoutIfNeeded()
        }
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event), let rootView = rootViewController?.view else {
            return nil
        }

        guard let event else {
            assertionFailure("Hit testing without an event is not supported at this time")
            return super.hitTest(point, with: nil)
        }

        if #available(iOS 18, *) {
            // Hit testing has changed in iOS 18, therefore we need to add a workaround.
            // More context is based on this forum thread: https://forums.developer.apple.com/forums/thread/762292
            //
            // Based on observations, we have found that if an initial hitTest on UIWindow returns a view, then a 2nd hitTest is triggered
            // For hit testing to succeed both calls must return a view, if either test fails then this window will not handle the event
            // Prior to iOS 18 the views returned by super.hitTest on both calls were the same. However, under iOS 18 if the rootViewController of the
            // window is a UIHostingController the 2nd hit test can return the rootViewController.view instead of the view returned in the first call.
            // This behavior breaks the original passthrough implementation that was working in earlier iOS versions since the 2nd hitTest would
            // return nil, thus invalidating the 1st test
            // The solution to this difference in behavior is to return the value provided by super.hitTest on the 2nd test regardless of whether or
            // not it is the rootViewController.view
            for subview in rootView.subviews.reversed() {
                let convertedPoint = subview.convert(point, from: rootView)
                if subview.hitTest(convertedPoint, with: event) != nil {
                    return hitView
                }
            }
            return nil
        } else {
            return hitView == rootView ? nil : hitView
        }
    }
}

