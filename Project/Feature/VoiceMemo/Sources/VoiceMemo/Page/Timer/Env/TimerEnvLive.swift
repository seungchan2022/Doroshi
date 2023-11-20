import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - TimerEnvLive

struct TimerEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

// MARK: TimerEnvType

extension TimerEnvLive: TimerEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.timer.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
    }
  }
  
  var routeToDetail: (TimerEntity.AlarmItem) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.VoiceMemo.Path.timerDetail.rawValue,
          items: item.encoded()),
        isAnimated: true)
    }
  }
}
