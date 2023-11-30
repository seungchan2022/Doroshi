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

      case .getRecordList:
        return env.recordList()
          .cancellable(pageID: pageID, id: CancelID.requestGetRecordList)

      case .onTapRecordStart:
        let id = UUID().uuidString
        return .concatenate(
          .cancel(pageID: pageID, id: CancelID.requestAudioRecord),
          env.recordStart(id)
            .cancellable(pageID: pageID, id: CancelID.requestAudioRecord))

      case .onTapRecordStop:
        return .concatenate(
          env.recordStop()
            .cancellable(pageID: pageID, id: CancelID.requestAudioRecord),
          .run { await $0(.getRecordList) }
        )

      case .onTapPlayStart(let id):
        return .concatenate(
          .cancel(pageID: pageID, id: CancelID.requestAudioPlay),
          env.playStart(id)
            .cancellable(pageID: pageID, id: CancelID.requestAudioPlay))

      case .onTapPlayStop:
        return env.playStop()
          .cancellable(pageID: pageID, id: CancelID.requestAudioPlay)

      case .onTapDelete(let id):
        return .concatenate(
          .cancel(pageID: pageID, id: CancelID.requestDelete),
          env.deleteRecording(id)
            .cancellable(pageID: pageID, id: CancelID.requestDelete))

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

      case .fetchPlay(let result):
        state.fetchPlay.isLoading = false
        switch result {
        case .success(let isPlaying):
          state.isPlaying = isPlaying
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchRecordList(let result):
        switch result {
        case .success(let list):
          state.fetchRecordList = list
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchDelete(let result):
        switch result {
        case .success(let item):
          state.fetchDelete = item
          state.fetchRecordList = state.fetchRecordList.filter { $0 != item }
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
      _fetchPlay = .init(.init(isLoading: false))

      fetchRecordList = []
      fetchDelete = ""
    }

    var isRecording = false
    var isPlaying = false
    var fetchRecordList: [String]
    var fetchDelete: String

    @Heap var fetchRecord: FetchState.Empty
    @Heap var fetchPlay: FetchState.Empty
  }
}

// MARK: AudioMemoStore.Action

extension AudioMemoStore {
  enum Action: Equatable, BindableAction {

    case binding(BindingAction<State>)
    case teardown

    case getRecordList

    case onTapRecordStart
    case onTapRecordStop

    case onTapPlayStart(String)
    case onTapPlayStop

    case onTapDelete(String)

    case routeToTabBarItem(String)

    case fetchRecord(Result<Bool, CompositeErrorRepository>)
    case fetchPlay(Result<Bool, CompositeErrorRepository>)

    case fetchRecordList(Result<[String], CompositeErrorRepository>)

    case fetchDelete(Result<String, CompositeErrorRepository>)

    case throwError(CompositeErrorRepository)
  }
}

// MARK: AudioMemoStore.CancelID

extension AudioMemoStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestAudioRecord
    case requestAudioPlay
    case requestGetRecordList
    case requestDelete
  }
}
