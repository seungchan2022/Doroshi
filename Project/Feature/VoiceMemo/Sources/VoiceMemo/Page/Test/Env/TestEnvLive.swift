import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct TestEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

extension TestEnvLive: TestEnvType {

}
