import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct MemoEditorStore {

  init(env: MemoEditorEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: MemoEditorEnvType
}

extension MemoEditorStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })
        
      case .onTapBack:
        env.routeToBack()
        return .none
        
      case .onTapCreate:
        return .none
 
      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

extension MemoEditorStore {
  struct State: Equatable {
    @BindingState var title = ""
    @BindingState var date = Date.now
    @BindingState var content = ""
  }
}

extension MemoEditorStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case onTapBack
    case onTapCreate
    
    case throwError(CompositeErrorRepository)
  }
}

extension MemoEditorStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
