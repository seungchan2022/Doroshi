import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct SettingStore {
  
  init(env: SettingEnvType) {
    self.env = env
  }
  
  let pageID = UUID().uuidString
  let env: SettingEnvType
}

extension SettingStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })
        
      case .getTodoList:
        return env.todoList()
          .cancellable(pageID: pageID, id: CancelID.requestGetTodoList)
        
      case .getMemoList:
        return env.memoList()
          .cancellable(pageID: pageID, id: CancelID.requestGetMemoList)
        
      case .routeToTabBarItem(let matchPath):
        env.routeToTabItem(matchPath)
        return .none
        
      case .onTapTodo:
        env.routeToTodo()
        return .none
        
      case .onTapMemo:
        env.routeToMemo()
        return .none
        
      case .onTapAudioMemo:
        env.routeToAudioMemo()
        return .none
        
      case .onTapTimer:
        env.routeToTimer()
        return .none
        
      case .fetchTodoList(let result):
        switch result {
        case .success(let list):
          state.fetchTodoList = list
          return .none
          
        case .failure(let error):
          return .run { await $0(.throwError(error))}
        }
        
      case .fetchMemoList(let result):
        switch result {
        case .success(let list):
          state.fetchMemoList = list
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

extension SettingStore {
  struct State: Equatable {
    init() {
      self.fetchTodoList = []
      self.fetchMemoList = []
    }
    
    var fetchTodoList: [TodoEntity.Item]
    var fetchMemoList: [MemoEntity.Item]
  }
}

extension SettingStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown
    
    case getTodoList
    case getMemoList
    
    case routeToTabBarItem(String)
    
    case onTapTodo
    case onTapMemo
    case onTapAudioMemo
    case onTapTimer
    
    case fetchTodoList(Result<[TodoEntity.Item], CompositeErrorRepository>)
    case fetchMemoList(Result<[MemoEntity.Item], CompositeErrorRepository>)
    
    case throwError(CompositeErrorRepository)
  }
}

extension SettingStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestGetTodoList
    case requestGetMemoList
  }
}
