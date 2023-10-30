import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct SettingEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

extension SettingEnvLive: SettingEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.setting.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
      
    }
  }
}
