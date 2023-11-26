import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - TimerDetailStore

struct TimerDetailStore {

  init(env: TimerDetailEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: TimerDetailEnvType
}

// MARK: Reducer

extension TimerDetailStore: Reducer {
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })
        
      case .routeToTabBarItem(let matchPath):
        env.routeToTabItem(matchPath)
        return .none
        
      case .onTapback:
        env.routeToBack()
        return .none
        
      case .onPullTimer:
        print("AAA")
        return .none

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

// MARK: TimerDetailStore.State

extension TimerDetailStore {
  struct State: Equatable {
    
    init(alarmInfo: TimerEntity.AlarmItem) {
      self.hour = alarmInfo.hour
      self.minute = alarmInfo.minute
      self.second = alarmInfo.second
    }
    
    var hour: Int
    var minute: Int
    var second: Int
    
    @BindingState var isPause: Bool = false
  }
}

// MARK: TimerDetailStore.Action

extension TimerDetailStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown
    
    case routeToTabBarItem(String)

    case onTapback
    
    case onPullTimer
    
    case throwError(CompositeErrorRepository)
  }
}

// MARK: TimerDetailStore.CancelID

extension TimerDetailStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
