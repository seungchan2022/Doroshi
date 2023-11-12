import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - AudioMemoStore

struct AudioMemoStore {

  init(env: AudioMemoEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: AudioMemoEnvType
}

// MARK: Reducer

extension AudioMemoStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { _, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .onTapRecordStart:
        return .none
        
      case .onTapRecordStop:
        return .none
        
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

// MARK: AudioMemoStore.State

extension AudioMemoStore {
  struct State: Equatable { }
}

// MARK: AudioMemoStore.Action

extension AudioMemoStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case onTapRecordStart
    case onTapRecordStop
    
    case routeToTabBarItem(String)

    case throwError(CompositeErrorRepository)
  }
}

// MARK: AudioMemoStore.CancelID

extension AudioMemoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
