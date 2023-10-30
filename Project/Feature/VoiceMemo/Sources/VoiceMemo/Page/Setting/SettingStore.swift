import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct SettingStore {

  init(env: SettingEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: SettingEnvType
}

extension SettingStore: Reducer {
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

extension SettingStore {
  struct State: Equatable {

  }
}

extension SettingStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown
    
    case routeToTabBarItem(String)

    case throwError(CompositeErrorRepository)
  }
}

extension SettingStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
