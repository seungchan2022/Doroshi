import Foundation
import ComposableArchitecture
import Domain

protocol LandingEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}


extension LandingEnvType {
  
}
