import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - TimerStore

struct TimerStore {

  init(env: TimerEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: TimerEnvType
}

// MARK: Reducer

extension TimerStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { _, action in
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

// MARK: TimerStore.State

extension TimerStore {
  struct State: Equatable {

    @BindingState var hour = 0
    @BindingState var minute = 0
    @BindingState var second = 0
  }
}

// MARK: TimerStore.Action

extension TimerStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case routeToTabBarItem(String)

    case throwError(CompositeErrorRepository)
  }
}

// MARK: TimerStore.CancelID

extension TimerStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
