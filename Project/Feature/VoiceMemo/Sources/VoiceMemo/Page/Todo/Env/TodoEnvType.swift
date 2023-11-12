import Foundation
import ComposableArchitecture
import Domain
import Combine
import CombineExt

protocol TodoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var todoList: () -> Effect<TodoStore.Action> { get }
  
  var deleteList: ([TodoEntity.Item]) -> Effect<TodoStore.Action> { get }
  
  var routeToTabItem: (String) -> Void { get }
  var routeToTodoEditor: (TodoEntity.Item?) -> Void { get }
}

extension TodoEnvType {
  var todoList: () -> Effect<TodoStore.Action> {
    {
      .publisher {
        useCaseGroup.todoUseCase.get()
          .receive(on: mainQueue)
          .mapToResult()
          .map(TodoStore.Action.fetchTodoList)
      }
    }
  }
  
  var deleteList: ([TodoEntity.Item]) -> Effect<TodoStore.Action> {
    { targetList in
        .publisher {
          Just(targetList.filter { $0.isChecked == true })
            .flatMap(useCaseGroup.todoUseCase.deleteTargetList)
            .receive(on: mainQueue)
            .mapToResult()
            .map(TodoStore.Action.fetchTodoList)
        }
    }
  }
}

