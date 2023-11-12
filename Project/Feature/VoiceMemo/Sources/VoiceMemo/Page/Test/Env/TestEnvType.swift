import ComposableArchitecture
import Domain
import Foundation

// MARK: - TestEnvType

protocol TestEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

extension TestEnvType { }
