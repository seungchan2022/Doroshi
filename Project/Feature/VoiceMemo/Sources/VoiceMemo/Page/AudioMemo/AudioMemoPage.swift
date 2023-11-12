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
  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.audioMemo.rawValue)
  }
  
  private var title: String {
    "음성 메모"
  }
  
  private var recordButtonViewState: RecordButton.ViewState {
    .init(isPlaying: true)
  }
}

// MARK: View

extension AudioMemoPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: "음성 메모") { }
        .overlay(alignment: .bottomTrailing) {
          RecordButton(
            viewState: recordButtonViewState,
            tapAction: { print($0) }
          )
        }
      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
    }
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}
