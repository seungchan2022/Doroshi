import Foundation
import ComposableArchitecture
import Domain

protocol TestEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}


extension TestEnvType {
  
}
