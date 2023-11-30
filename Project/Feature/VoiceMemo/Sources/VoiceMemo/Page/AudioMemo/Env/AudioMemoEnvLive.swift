import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - AudioMemoEnvLive

struct AudioMemoEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType

}

// MARK: AudioMemoEnvType

extension AudioMemoEnvLive: AudioMemoEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.audioMemo.rawValue else { return }
navigator.replace(linkItem: .init(path: path), isAnimated: false)   
    }
  }
}
