import ComposableArchitecture
import Domain
import Foundation

// MARK: - AudioMemoEnvType

protocol AudioMemoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
//  var recordStart: (String) -> Effect<AudioMemoStore.Action> { get }
//  var recordStop: () -> Effect<AudioMemoStore.Action> { get }

  var routeToTabItem: (String) -> Void { get }
}

extension AudioMemoEnvType { }
