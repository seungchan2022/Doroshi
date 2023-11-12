import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MemoStore

struct MemoStore {

  init(env: MemoEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: MemoEnvType
}

// MARK: Reducer

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
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .onTapDeleteTarget(let item):
        let new = MemoEntity.Item(
          isChecked: !(item.isChecked ?? false),
          title: item.title,
          date: item.date,
          content: item.content)
        state.fetchMemoList = state.fetchMemoList.map { $0.id != item.id ? $0 : new }
        return .none

      case .onTapDeleteList(let list):
        state.isEditing.toggle()
        return env.deleteList(list)
          .cancellable(pageID: pageID, id: CancelID.requestDeleteList)

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

// MARK: MemoStore.State

extension MemoStore {
  struct State: Equatable {
    init() {
      fetchMemoList = []
    }

    var fetchMemoList: [MemoEntity.Item]

    var isEditing = false
  }
}

// MARK: MemoStore.Action

extension MemoStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case getMemoList

    case routeToTabBarItem(String)
    case onTapMemoEditor

    case onTapDeleteTarget(MemoEntity.Item)
    case onTapDeleteList([MemoEntity.Item])

    case fetchMemoList(Result<[MemoEntity.Item], CompositeErrorRepository>)

    case throwError(CompositeErrorRepository)
  }
}

// MARK: MemoStore.CancelID

extension MemoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestGetMemoList
    case requestDeleteList
  }
}
