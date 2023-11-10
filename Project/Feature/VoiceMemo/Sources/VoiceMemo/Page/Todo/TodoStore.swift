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
          return .none
          
        case .failure(let error):
          return .run { await $0(.throwError(error))}
        }
        
      case .onTapEdit:
        // env에서 edit에 대한 로직 구현
        return .none
        
      case .onTapDeleteTarget(let item):
        let new = TodoEntity.Item(isChecked: !(item.isChecked ?? false), title: item.title, date: item.date)
        state.fetchTodoList = state.fetchTodoList.map { $0.id != item.id ? $0 : new }
        return .none

      case .onTapDeleteList(let list):
        state.isEditing.toggle()
        return env.deleteList(list)
          .cancellable(pageID: pageID, id: CancelID.requestDeleteList)
        
      case .editTodo(let item):
        env.editTodo(item)
        
        return .none
        
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
    var isEditing: Bool = false
  }
}

extension TodoStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown
    
    case getTotoList
    
    case routeToTabBarItem(String)
    
    case onTapTodoEditor  // 투두 작성 버튼
    
    case onTapEdit  // 네비게이션 버튼
    
    case onTapDeleteTarget(TodoEntity.Item)  // Item의 isChecked(entity) 토글
    case onTapDeleteList([TodoEntity.Item]) // 선택된 아이템들 삭제
    
    
    case editTodo(TodoEntity.Item)  // 해당 투두로 들어가는
    
    case fetchTodoList(Result<[TodoEntity.Item], CompositeErrorRepository>)
    
    case throwError(CompositeErrorRepository)
    
  }
}

extension TodoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestGetTodoList
    case requestDeleteList
  }
}
