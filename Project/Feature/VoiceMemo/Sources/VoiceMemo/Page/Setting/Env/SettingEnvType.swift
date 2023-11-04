import Foundation
import ComposableArchitecture
import Domain

protocol SettingEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var routeToTabItem: (String) -> Void { get }
  
  var routeToTodo: () -> Void { get }
  var routeToMemo: () -> Void { get }
  var routeToAudioMemo: () -> Void { get }
  var routeToTimer: () -> Void { get }
}


extension SettingEnvType {

}
