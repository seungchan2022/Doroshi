import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - TestStore

struct TestStore {

  init(env: TestEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: TestEnvType
}

// MARK: Reducer

extension TestStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { _, action in
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

// MARK: TestStore.State

extension TestStore {
  struct State: Equatable { }
}

// MARK: TestStore.Action

extension TestStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case throwError(CompositeErrorRepository)
  }
}

// MARK: TestStore.CancelID

extension TestStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
