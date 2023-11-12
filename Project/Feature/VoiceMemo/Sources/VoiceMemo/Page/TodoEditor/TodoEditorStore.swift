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
        
      case .onTapUpdateDone:
        return env.save(state)
          .cancellable(pageID: pageID, id: CancelID.requestSaveItem)
        
      case .onTapDateSheet:
        state.route = .datePickerSheet(state.date)
        return .none
        
      case .onChangeDate(let new):
        state.date = new
        return .none
        
      case .onRouteClear:
        state.route = .none
        return .none
        
      case .fetchCreate(let result):
        switch result {
        case .success:
          env.routeToBack()
          return .none
          
        case .failure(let error):
          return .run { await $0(.throwError(error))}
        }
        
      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

extension TodoEditorStore {
  struct State: Equatable {
    init(injectionItem: TodoEntity.Item?) {
      
      self.title = injectionItem?.title ?? ""
      self.date = {
        guard let date = injectionItem?.date else { return .now }
        return .init(timeIntervalSince1970: date)
      }()
      mode = injectionItem == .none ? .create : .edit
      route = route
    }
    
    @BindingState var title = ""
    @BindingState var date = Date.now
    @BindingState var route: Route?
    let mode: Mode
    
  }
}

extension TodoEditorStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown
    
    case onTapBack
    case onTapUpdateDone
    
    case onTapDateSheet
    case onChangeDate(Date)
    
    case onRouteClear
    
    case fetchCreate(Result<TodoEntity.Item, CompositeErrorRepository>)
    case throwError(CompositeErrorRepository)
  }
}

extension TodoEditorStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSaveItem
  }
  
  enum Route: Equatable {
    case datePickerSheet(Date)
  }
  
  enum Mode: Equatable {
    case create
    case edit
  }
}
