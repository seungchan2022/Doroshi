import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - MemoEditorEnvLive

struct MemoEditorEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

// MARK: MemoEditorEnvType

extension MemoEditorEnvLive: MemoEditorEnvType {
  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}
