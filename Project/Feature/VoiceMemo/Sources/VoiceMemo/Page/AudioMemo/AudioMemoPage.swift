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
    .init(isRecording: viewStore.isRecording)
  }
}

// MARK: View

extension AudioMemoPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: "음성 메모") {
        Button(action: {
          viewStore.send(viewStore.isPlaying ? .onTapPlayStop : .onTapPlayStart)
        }) {
          Circle()
            .fill(viewStore.isPlaying ? .blue : .gray)
            .frame(width: 50, height: 50)
            .padding(.trailing, 30)
            .padding(.bottom, 40)
        }
      }
      .overlay(alignment: .bottomTrailing) {
        RecordButton(
          viewState: recordButtonViewState,
          tapAction: { viewStore.send($0 ? .onTapRecordStop : .onTapRecordStart) }
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
