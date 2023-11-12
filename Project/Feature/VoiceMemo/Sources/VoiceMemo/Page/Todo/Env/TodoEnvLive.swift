import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct TodoEnvLive {
  
  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

extension TodoEnvLive: TodoEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.todo.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
    }
  }
  
  // Todo 작성
  var routeToTodoEditor: (TodoEntity.Item?) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.VoiceMemo.Path.todoEditor.rawValue,
          items: item?.encoded() ?? ""),
        isAnimated: true)
    }
  }
}
