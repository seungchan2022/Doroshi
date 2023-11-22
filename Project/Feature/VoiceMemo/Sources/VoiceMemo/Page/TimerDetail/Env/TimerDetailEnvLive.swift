import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - TimerDetailEnvLive

struct TimerDetailEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

// MARK: TimerDetailEnvType

extension TimerDetailEnvLive: TimerDetailEnvType { 
  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
  
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.timerDetail.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
    }
  }
}
