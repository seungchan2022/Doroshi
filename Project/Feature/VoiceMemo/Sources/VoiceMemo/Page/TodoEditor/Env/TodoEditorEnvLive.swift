import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - TodoEditorEnvLive

struct TodoEditorEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

// MARK: TodoEditorEnvType

extension TodoEditorEnvLive: TodoEditorEnvType {
  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }

}
