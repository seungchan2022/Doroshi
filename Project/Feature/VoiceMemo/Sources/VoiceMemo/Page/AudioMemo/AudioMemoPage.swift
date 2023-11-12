import Architecture
import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - AudioMemoPage

struct AudioMemoPage {

  init(store: StoreOf<AudioMemoStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<AudioMemoStore>
  @ObservedObject private var viewStore: ViewStoreOf<AudioMemoStore>
}

extension AudioMemoPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.audioMemo.rawValue)
  }

  private var title: String {
    "음성 메모"
  }

}

// MARK: View

extension AudioMemoPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: "음성 메모") { }
        .overlay(alignment: .bottomTrailing) {
          Circle()
            .fill(.red)
            .frame(width: 50, height: 50)
            .padding(.trailing, 30)
            .padding(.bottom, 40)
        }
      TabNavigationComponent(
        viewState: tabNavigationComponeentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
    }
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}
