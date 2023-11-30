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

  @State private var isEditingFocus: String? = .none

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

  private var maxDragDistance: CGFloat {
    100
  }
}

// MARK: View

extension AudioMemoPage: View {
  var body: some View {
    VStack(spacing: .zero) {
      DesignSystemNavigation(title: title) {

        ScrollView {
          LazyVStack(alignment: .leading, spacing: .zero) {
            ForEach(viewStore.fetchRecordList, id: \.self) { item in
              RecordItem(
                viewState: .init(
                  id: item,
                  isPlaying: viewStore.isPlaying,
                  isLastItem: viewStore.fetchRecordList.last == item,
                  isEdit: isEditingFocus == item),
                swipeAction: { self.isEditingFocus = $0 },
                playingAction: {
                  viewStore.send(
                      $0 ? .onTapPlayStop : .onTapPlayStart(item))
                },
                deleteAction: { viewStore.send(.onTapDelete($0)) })
            }
          }
          .animation(.spring(), value: viewStore.fetchRecordList)
        }
      }
      .overlay(alignment: .bottomTrailing) {
        RecordButton(
          viewState: recordButtonViewState,
          tapAction: { viewStore.send($0 ? .onTapRecordStop : .onTapRecordStart) })
      }
      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .navigationTitle("")
    .navigationBarHidden(true)
    .onAppear {
      viewStore.send(.getRecordList)
    }
  }
}
