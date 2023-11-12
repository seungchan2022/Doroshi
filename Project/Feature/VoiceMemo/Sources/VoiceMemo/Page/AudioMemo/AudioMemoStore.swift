import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - AudioMemoStore

struct AudioMemoStore {

  init(env: AudioMemoEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: AudioMemoEnvType
}

// MARK: Reducer

extension AudioMemoStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .onTapRecordStart:
        let id = UUID().uuidString
        return .concatenate(
          .cancel(pageID: pageID, id: CancelID.requestAudioRecord),
          env.recordStart(id)
            .cancellable(pageID: pageID, id: CancelID.requestAudioRecord)
        )
        
      case .onTapRecordStop:
        return env.recordStop()
          .cancellable(pageID: pageID, id: CancelID.requestAudioRecord)
        
      case .routeToTabBarItem(let matchPath):
        env.routeToTabItem(matchPath)
        return .none

      case .fetchRecord(let result):
        state.fetchRecord.isLoading = false
        switch result {
        case .success(let isRecording):
          state.isRecording = isRecording
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

// MARK: AudioMemoStore.State

extension AudioMemoStore {
  struct State: Equatable {
    init() {
      _fetchRecord = .init(.init(isLoading: false))
    }
    
    var isRecording = false
    
    @Heap var fetchRecord: FetchState.Empty
     
  }
}

// MARK: AudioMemoStore.Action

extension AudioMemoStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case onTapRecordStart
    case onTapRecordStop
    
    case routeToTabBarItem(String)

    case fetchRecord(Result<Bool, CompositeErrorRepository>)
    case throwError(CompositeErrorRepository)
  }
}

// MARK: AudioMemoStore.CancelID

extension AudioMemoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestAudioRecord
  }
}
