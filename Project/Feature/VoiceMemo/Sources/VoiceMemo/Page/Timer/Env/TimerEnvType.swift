import ComposableArchitecture
import Domain
import Foundation

// MARK: - TimerEnvType

protocol TimerEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }

  var routeToTabItem: (String) -> Void { get }
}

extension TimerEnvType { }
