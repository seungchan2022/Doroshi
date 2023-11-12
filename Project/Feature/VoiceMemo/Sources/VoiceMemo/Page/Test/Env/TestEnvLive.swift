import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - TestEnvLive

struct TestEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

// MARK: TestEnvType

extension TestEnvLive: TestEnvType { }
