import Foundation
import ComposableArchitecture
import Domain

protocol TodoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var routeToTabItem: (String) -> Void { get }
}


extension TodoEnvType {
  
}
