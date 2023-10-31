import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct TodoStore {

  init(env: TodoEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: TodoEnvType
}

extension TodoStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })
        
      case .getTotoList:
        return env.todoList()
          .cancellable(pageID: pageID, id: CancelID.requestGetTodoList)
        
      case .routeToTabBarItem(let matchPath):
        env.routeToTabItem(matchPath)
        return .none

      case .onTapTodoEditor:
        env.routeToTodoEditor(.none)
        return .none
        
      case .fetchTodoList(let result):
        switch result {
        case .success(let list):
          state.fetchTodoList = list
//          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            env.routeToTodoEditor(list.last)
//          }
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

extension TodoStore {
  struct State: Equatable {
    init() {
      self.fetchTodoList = []
    }
    
    var fetchTodoList: [TodoEntity.Item]
  }
}

extension TodoStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown
    
    case getTotoList
    
    case routeToTabBarItem(String)
    case onTapTodoEditor
    
    case fetchTodoList(Result<[TodoEntity.Item], CompositeErrorRepository>)
    
    case throwError(CompositeErrorRepository)
  }
}

extension TodoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestGetTodoList
  }
}
