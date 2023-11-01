import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct MemoEditorEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

extension MemoEditorEnvLive: MemoEditorEnvType {
  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }

}
