import ComposableArchitecture
import Domain
import Foundation

// MARK: - TimerDetailEnvType

protocol TimerDetailEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  
}

extension TimerDetailEnvType { }
