import SwiftUI
import UIKit

class PassThroughUIHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}
