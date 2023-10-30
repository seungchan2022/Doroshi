import Foundation
import ComposableArchitecture
import Domain

protocol AudioMemoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}


extension AudioMemoEnvType {
  
}
