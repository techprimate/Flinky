import FlinkyCore
import SentrySwift
import SwiftUI
import os.log

struct LinkDetailNFCSharingContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.toaster) private var toaster

    let link: LinkModel

    @StateObject private var viewModel: LinkDetailNFCSharingViewModel

    init(link: LinkModel) {
        self.link = link
        _viewModel = StateObject(wrappedValue: LinkDetailNFCSharingViewModel(link: link))
    }

    var body: some View {
        LinkDetailNFCSharingRenderView(
            state: viewModel.state,
            linkTitle: link.name,
            retryAction: {
                viewModel.retry()
            }
        )
        .onAppear {
            viewModel.start { appError in
                SentrySDK.capture(error: appError)
                toaster.show(error: appError)
            }
        }
        .sentryTrace("LINK_DETAIL_NFC_SHARING")
        .onDisappear {
            viewModel.stop()
        }
    }
}
