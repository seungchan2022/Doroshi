import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct LandingEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

extension LandingEnvLive: LandingEnvType {

}
