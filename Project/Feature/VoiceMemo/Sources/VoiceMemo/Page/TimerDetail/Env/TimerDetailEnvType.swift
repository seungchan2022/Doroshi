import ComposableArchitecture
import Domain
import Foundation

// MARK: - TimerDetailEnvType

protocol TimerDetailEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }

  var routeToBack: () -> Void { get }
  var routeToTabItem: (String) -> Void { get }
}

extension TimerDetailEnvType { }
