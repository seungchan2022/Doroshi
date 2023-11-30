import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - SettingEnvLive

struct SettingEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

// MARK: SettingEnvType

extension SettingEnvLive: SettingEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.setting.rawValue else { return }
navigator.replace(linkItem: .init(path: path), isAnimated: false)    }
  }

  var routeToTodo: () -> Void {
    {
      navigator.backOrNext(
        linkItem: .init(path: Link.VoiceMemo.Path.todo.rawValue),
        isAnimated: true)
    }
  }

  var routeToMemo: () -> Void {
    {
      navigator.backOrNext(
        linkItem: .init(path: Link.VoiceMemo.Path.memo.rawValue),
        isAnimated: true)
    }
  }

  var routeToAudioMemo: () -> Void {
    {
      navigator.backOrNext(
        linkItem: .init(path: Link.VoiceMemo.Path.audioMemo.rawValue),
        isAnimated: true)
    }
  }

  var routeToTimer: () -> Void {
    {
      navigator.backOrNext(
        linkItem: .init(path: Link.VoiceMemo.Path.timer.rawValue),
        isAnimated: true)
    }
  }
}
