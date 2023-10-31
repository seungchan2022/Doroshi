import Foundation
import ComposableArchitecture
import Domain

protocol TodoEditorEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var routeToBack: () -> Void { get }
}


extension TodoEditorEnvType {
  
}
