import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct LandingEnvLive {
  
  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

extension LandingEnvLive: LandingEnvType {
  var routeToAudioMemo: () -> Void {
    {
      navigator.replace(
        linkItem: .init(path: Link.VoiceMemo.Path.audioMemo.rawValue),
        isAnimated: true)
    }
  }
}
