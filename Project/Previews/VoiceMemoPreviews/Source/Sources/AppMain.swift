import Architecture
import SwiftUI
import LinkNavigator

@main
struct AppMain: App {
  
  @State private var viewModel = AppMainViewModel()
  
  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: viewModel.linkNavigator,
        item: .init(path: Link.VoiceMemo.Path.landing.rawValue))
    }
  }
}
