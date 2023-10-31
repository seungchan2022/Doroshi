import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct TodoEditorStore {

  init(env: TodoEditorEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: TodoEditorEnvType
}

extension TodoEditorStore: Reducer {
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
        
      case .onTapDateSheet:
        state.route = .datePickerSheet(state.date)
        return .none
        
      case .onChangeDate(let new):
        state.date = new
        return .none
        
      case .onRouteClear:
        state.route = .none
        return .none

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

extension TodoEditorStore {
  struct State: Equatable {
    @BindingState var title = ""
    @BindingState var date = Date.now
    @BindingState var route: Route?
    
  }
}

extension TodoEditorStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown
    
    case onTapBack
    case onTapCreate
    case onTapDateSheet
    case onChangeDate(Date)
    
    case onRouteClear

    case throwError(CompositeErrorRepository)
  }
}

extension TodoEditorStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
  
  enum Route: Equatable {
    case datePickerSheet(Date)
  }
}
