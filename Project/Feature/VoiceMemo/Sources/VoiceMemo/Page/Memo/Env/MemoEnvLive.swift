import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct MemoEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

extension MemoEnvLive: MemoEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.memo.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
      
    }
  }
  
  var routeToMemoEditor: () -> Void {
    {
      navigator.backOrNext(
        linkItem: .init(path: Link.VoiceMemo.Path.memoEditor.rawValue),
        isAnimated: true)
    }
  }
}
