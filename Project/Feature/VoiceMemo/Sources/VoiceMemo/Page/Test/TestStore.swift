import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct TestStore {

  init(env: TestEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: TestEnvType
}

extension TestStore: Reducer {
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

extension TestStore {
  struct State: Equatable {

  }
}

extension TestStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case throwError(CompositeErrorRepository)
  }
}

extension TestStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
