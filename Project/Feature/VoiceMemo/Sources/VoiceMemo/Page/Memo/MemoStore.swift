import Architecture
import ComposableArchitecture
import Domain
import Foundation

struct MemoStore {

  init(env: MemoEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: MemoEnvType
}

extension MemoStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })
        
      case .getMemoList:
        return env.memoList()
          .cancellable(pageID: pageID, id: CancelID.requestGetMemoList)
        
      case .routeToTabBarItem(let matchPath):
        env.routeToTabItem(matchPath)
        return .none

      case .onTapMemoEditor:
        env.routeToMemoEditor(.none)
        return .none
        
      case .fetchMemoList(let result):
        switch result {
        case .success(let list):
          state.fetchMemoList = list
//          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            env.routeToMemoEditor(list.last)
//          }
          return .none
          
        case .failure(let error):
          return .run { await $0(.throwError(error) )}
        }
        
      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

extension MemoStore {
  struct State: Equatable {
    init() {
      self.fetchMemoList = []
    }
    
    var fetchMemoList: [MemoEntity.Item]
  }
}

extension MemoStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case getMemoList
    
    case routeToTabBarItem(String)
    case onTapMemoEditor
    
    case fetchMemoList(Result<[MemoEntity.Item], CompositeErrorRepository>)
    
    case throwError(CompositeErrorRepository)
  }
}

extension MemoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestGetMemoList
  }
}
