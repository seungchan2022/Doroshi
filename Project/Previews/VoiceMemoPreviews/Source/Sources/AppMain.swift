import Architecture
import LinkNavigator
import SwiftUI

@main
struct AppMain: App {

  @State private var viewModel = AppMainViewModel()

//  let notification = NotificationDelegate()

  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: viewModel.linkNavigator,
        item: .init(path: Link.VoiceMemo.Path.audioMemo.rawValue))
      .ignoresSafeArea(.all, edges: .bottom)
    }
  }
}
