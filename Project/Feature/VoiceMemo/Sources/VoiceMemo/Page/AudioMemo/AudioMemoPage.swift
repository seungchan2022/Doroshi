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
  
  // 각 아이템의 오프셋을 저장할 딕셔너리
  @State private var offsetDic = [String: CGFloat]()
  
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
    VStack {
      DesignSystemNavigation(title: title) {
        Divider()
          .background(DesignSystemColor.palette(.gray(.lv100)).color)
        
        ForEach(viewStore.fetchRecordList, id: \.self) { item in
          HStack {
            Text(item)
              .opacity(viewStore.isPlaying ? 0.2 : 1)
              .offset(x: offsetDic[item] ?? .zero)
              .animation(.spring())
              .onTapGesture {
                viewStore.send(
                  viewStore.isPlaying ? .onTapPlayStop : .onTapPlayStart(item))
              }
            
            if (offsetDic[item] ?? .zero) <= -maxDragDistance {
              Button(action: { viewStore.send(.onTapDelete(item)) }) {
                DesignSystemIcon.delete.image
                  .resizable()
                  .frame(width: 30, height: 30)
                  .foregroundColor(.red)
              }
              .frame(width: maxDragDistance, alignment: .trailing)
            }
          }
          .frame(maxWidth: .infinity)
          .frame(height: 30)
          .padding(.horizontal, 16)
          .gesture(
            DragGesture()
              .onChanged { gesture in
                // 최대 드래그 거리 제한
                offsetDic[item] = max(gesture.translation.width, -maxDragDistance)
              }
              .onEnded { _ in
                if (offsetDic[item] ?? 0) != -maxDragDistance {
                  // 원래 위치로
                  offsetDic[item] = 0
                }
              }
          )
          Divider()
            .background(DesignSystemColor.palette(.gray(.lv100)).color)
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
    .ignoresSafeArea(.all, edges: .bottom)
    .navigationTitle("")
    .navigationBarHidden(true)
    .onAppear {
      viewStore.send(.getRecordList)
    }
  }
}
