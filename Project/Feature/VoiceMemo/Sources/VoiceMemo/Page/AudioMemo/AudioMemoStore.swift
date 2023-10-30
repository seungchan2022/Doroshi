import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct AudioMemoStore {

  init(env: AudioMemoEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: AudioMemoEnvType
}

extension AudioMemoStore: Reducer {
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

extension AudioMemoStore {
  struct State: Equatable {

  }
}

extension AudioMemoStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown
    
    case routeToTabBarItem(String)

    case throwError(CompositeErrorRepository)
  }
}

extension AudioMemoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
