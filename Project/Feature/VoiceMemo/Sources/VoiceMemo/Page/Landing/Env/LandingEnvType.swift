import ComposableArchitecture
import Domain
import Foundation

// MARK: - LandingEnvType

protocol LandingEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }

  var routeToAudioMemo: () -> Void { get }
}

extension LandingEnvType { }
