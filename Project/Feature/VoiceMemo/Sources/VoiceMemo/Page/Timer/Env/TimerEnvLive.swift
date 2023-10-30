import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct TimerEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

extension TimerEnvLive: TimerEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.timer.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
      
    }
  }
}
