import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct MemoStore {

  init(env: MemoEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: MemoEnvType
}

extension MemoStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })
        
      case .routeToTabBarItem(let matchPath):
        env.routeToTabItem(matchPath)
        return .none

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

extension MemoStore {
  struct State: Equatable {

  }
}

extension MemoStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case routeToTabBarItem(String)
    
    case throwError(CompositeErrorRepository)
  }
}

extension MemoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
