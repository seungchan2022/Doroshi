import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Architecture

struct TimerPage {

  init(store: StoreOf<TimerStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<TimerStore>
  @ObservedObject private var viewStore: ViewStoreOf<TimerStore>
}

extension TimerPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.timer.rawValue)
  }
  
  private var title: String {
    "타이머"    
  }
}

extension TimerPage: View {
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
