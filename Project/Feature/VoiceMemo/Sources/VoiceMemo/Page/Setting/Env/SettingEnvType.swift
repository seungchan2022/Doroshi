import Foundation
import ComposableArchitecture
import Domain

protocol SettingEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var routeToTabItem: (String) -> Void { get }
}


extension SettingEnvType {

}
