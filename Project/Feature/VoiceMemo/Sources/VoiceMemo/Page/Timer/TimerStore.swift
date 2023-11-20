import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - TimerStore

struct TimerStore {

  init(env: TimerEnvType) {
    self.env = env
  }

  let pageID = UUID().uuidString
  let env: TimerEnvType
}

// MARK: Reducer

extension TimerStore: Reducer {
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
        
      case .routeToDetail:
        env.routeToDetail(.init(
          hour: state.hour,
          minute: state.minute,
          second: state.second))
        return .none
        
      
      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

// MARK: TimerStore.State

extension TimerStore {
  struct State: Equatable {
    @BindingState var hour: Int = .zero
    @BindingState var minute: Int = .zero
    @BindingState var second: Int = .zero
    
  }
}

// MARK: TimerStore.Action

extension TimerStore {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case teardown

    case routeToTabBarItem(String)
        
    case routeToDetail
    
    case throwError(CompositeErrorRepository)
  }
}

// MARK: TimerStore.CancelID

extension TimerStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}

extension Int {
  fileprivate func formattedTimeString(time: Int) -> String {
    
    let remainingHours = String(format: "%02d", time / 3600)
    let remainingMinutes = String(format: "%02d", (time % 3600) / 60)
    let remainingSeconds = String(format: "%02d", time % 60)
    
    let formattedTime = "\(remainingHours) : \(remainingMinutes) : \(remainingSeconds)"
    
    return formattedTime
  }
}
