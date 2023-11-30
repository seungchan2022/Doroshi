import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - MemoEnvLive

struct MemoEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

// MARK: MemoEnvType

extension MemoEnvLive: MemoEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.memo.rawValue else { return }
      switch path {
      case Link.VoiceMemo.Path.timer.rawValue, Link.VoiceMemo.Path.timerDetail.rawValue:
        let setting = useCaseGroup.cacheUseCase.getSetting()
        switch setting.alarmItem {
        case .some(let item):
          navigator.replace(
            linkItem: .init(
              path: Link.VoiceMemo.Path.timerDetail.rawValue,
              items: item.encoded()),
            isAnimated: false)
          
        case .none:
          navigator.replace(
            linkItem: .init(path: Link.VoiceMemo.Path.timer.rawValue),
            isAnimated: false)
        }
        
      default:
        navigator.replace(linkItem: .init(path: path), isAnimated: false)
      }
    }
  }

  var routeToMemoEditor: (MemoEntity.Item?) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.VoiceMemo.Path.memoEditor.rawValue,
          items: item?.encoded() ?? ""),
        isAnimated: true)
    }
  }
}
