import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - TodoEnvLive

struct TodoEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  let navigator: RootNavigatorType
}

// MARK: TodoEnvType

extension TodoEnvLive: TodoEnvType {
  var routeToTabItem: (String) -> Void {
    { path in
      guard path != Link.VoiceMemo.Path.todo.rawValue else { return }
      
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

  var routeToAlert: () -> Void {
    {
      navigator.alert(
        target: .root,
        model: .init(
          message: "test",
          buttons: [
            .init(title: "취소", style: .cancel, action: { }),
            .init(title: "삭제", style: .default, action: { }),
          ],
          flagType: .default))
    }
  }
}
