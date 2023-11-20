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
  
}
