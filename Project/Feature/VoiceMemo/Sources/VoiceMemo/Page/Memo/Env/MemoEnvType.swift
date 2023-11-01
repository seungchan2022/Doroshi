import Foundation
import ComposableArchitecture
import Domain

protocol MemoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var routeToTabItem: (String) -> Void { get }
  var routeToMemoEditor: () -> Void { get }
}


extension MemoEnvType {
  
}
