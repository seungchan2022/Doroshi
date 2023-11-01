import Foundation
import ComposableArchitecture
import Domain

protocol MemoEditorEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var routeToBack: () -> Void { get }
  
}


extension MemoEditorEnvType {
  
}
