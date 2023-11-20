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

        ForEach(viewStore.fetchRecordList, id: \.self) { item in
          Button(action: {
            viewStore.send(
              viewStore.isPlaying ? .onTapPlayStop : .onTapPlayStart(item))
            
          }) {
            Text(item)
              .opacity(viewStore.isPlaying ? 0.2 : 1)
          }
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
    .onAppear {
      viewStore.send(.getRecordList)
    }
  }
}
