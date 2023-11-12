import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - LandingStore

struct LandingStore {

  init(env: LandingEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: LandingEnvType
}

// MARK: Reducer

extension LandingStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { _, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .routeToAudioMemo:
        env.routeToAudioMemo()
        return .none

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

// MARK: LandingStore.State

extension LandingStore {
  struct State: Equatable { }
}

// MARK: LandingStore.Action

extension LandingStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case routeToAudioMemo

    case throwError(CompositeErrorRepository)
  }
}

// MARK: LandingStore.CancelID

extension LandingStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
