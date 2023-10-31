import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Architecture

struct TodoPage {
  
  init(store: StoreOf<TodoStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
  
  private let store: StoreOf<TodoStore>
  @ObservedObject private var viewStore: ViewStoreOf<TodoStore>
}

extension TodoPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.todo.rawValue)
  }
  
  private var title: String {
    """
    To do list를
    추가해 보세요.
    """
  }
}

extension TodoPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: title) {
        
      }
      .overlay(alignment: .bottomTrailing) {
        Button(action: { viewStore.send(.onTapTodoEditor) }) {
          DesignSystemIcon.pencil.image
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundStyle(DesignSystemColor.system(.white).color)
            .padding(15)
            .background {
              Circle()
                .fill(DesignSystemColor.label(.default).color)
                .frame(width: 50, height: 50)
            }
        }
        .padding(.trailing, 30)
        .padding(.bottom, 40)

      }
      TabNavigationComponent(
        viewState: tabNavigationComponeentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
//      .ignoresSafeArea(.all, edges: .bottom)
    }
    .navigationTitle("")
    .navigationBarHidden(true)
    
  }
}