import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MemoEditorStore

struct MemoEditorStore {

  init(env: MemoEditorEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: MemoEditorEnvType
}

// MARK: Reducer

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

      case .onTapUpdateDone:
        return env.save(state)
          .cancellable(pageID: pageID, id: CancelID.requestSaveItem)

      case .fetchCreate(let result):
        switch result {
        case .success:
          env.routeToBack()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

// MARK: MemoEditorStore.State

extension MemoEditorStore {
  struct State: Equatable {

    init(injectionItem: MemoEntity.Item?) {
      title = injectionItem?.title ?? ""
      date = {
        guard let date = injectionItem?.date else { return .now }
        return .init(timeIntervalSince1970: date)
      }()
      content = injectionItem?.content ?? ""
      
      mode = injectionItem == .none ? .create : .edit
    }

    @BindingState var title = ""
    @BindingState var date = Date.now
    @BindingState var content = ""
    
    let mode: Mode
  }
}

// MARK: MemoEditorStore.Action

extension MemoEditorStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case onTapBack
    case onTapUpdateDone

    case fetchCreate(Result<MemoEntity.Item, CompositeErrorRepository>)
    case throwError(CompositeErrorRepository)
  }
}

// MARK: MemoEditorStore.CancelID

extension MemoEditorStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSaveItem
  }
  
  enum Mode: Equatable {
    case create
    case edit
  }
}
