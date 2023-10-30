import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Architecture

struct SettingPage {

  init(store: StoreOf<SettingStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<SettingStore>
  @ObservedObject private var viewStore: ViewStoreOf<SettingStore>
}

extension SettingPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.setting.rawValue)
  }
  
  private var title: String {
    "설정"
  }
}

extension SettingPage: View {
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
