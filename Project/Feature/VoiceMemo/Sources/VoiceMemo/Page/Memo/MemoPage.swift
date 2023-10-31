import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Architecture

struct MemoPage {

  init(store: StoreOf<MemoStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<MemoStore>
  @ObservedObject private var viewStore: ViewStoreOf<MemoStore>
}

extension MemoPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.memo.rawValue)
  }
  
  private var title: String {
    """
    메모를
    추가해보세요
    """
  }
}

extension MemoPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: title) {
        
      }
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