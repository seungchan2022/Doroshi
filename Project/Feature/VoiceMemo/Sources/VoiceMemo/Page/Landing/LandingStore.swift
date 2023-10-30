import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct LandingStore {

  init(env: LandingEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: LandingEnvType
}

extension LandingStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

extension LandingStore {
  struct State: Equatable {

  }
}

extension LandingStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case throwError(CompositeErrorRepository)
  }
}

extension LandingStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
