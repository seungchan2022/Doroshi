import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - LandingEnvLive

struct LandingEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

// MARK: LandingEnvType

extension LandingEnvLive: LandingEnvType {
  var routeToAudioMemo: () -> Void {
    {
      navigator.replace(
        linkItem: .init(path: Link.VoiceMemo.Path.audioMemo.rawValue),
        isAnimated: true)
    }
  }
}
