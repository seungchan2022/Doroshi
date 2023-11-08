import Foundation
import ComposableArchitecture
import Domain
import Combine

protocol TodoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var todoList: () -> Effect<TodoStore.Action> { get }
  
  var delete: (TodoEntity.Item) -> Effect<TodoStore.Action> { get }
  
  var deleteList: ([TodoEntity.Item]) -> Effect<TodoStore.Action> { get }
  
  var editTodo: (TodoEntity.Item?) -> Void { get }
  
  var routeToTabItem: (String) -> Void { get }
  var routeToTodoEditor: (TodoEntity.Item?) -> Void { get }
}

extension TodoEnvType {
  var todoList: () -> Effect<TodoStore.Action> {
    {
      .publisher {
        Just(useCaseGroup.todoUseCase.get())
          .receive(on: mainQueue)
          .map { .fetchTodoList(.success($0)) }
      }
    }
  }
  
  var delete: (TodoEntity.Item) -> Effect<TodoStore.Action> {
    { target in
        .publisher {
          Just(target)
            .map(useCaseGroup.todoUseCase.delete)
            .receive(on: mainQueue)
            .map { .fetchTodoList(.success($0)) }
        }
    }
  }
  
    var deleteList: ([TodoEntity.Item]) -> Effect<TodoStore.Action> {
      { targetList in
          .publisher {
            Just(targetList.filter { $0.isChecked == true })
              .map(useCaseGroup.todoUseCase.deleteTargetList)
              .receive(on: mainQueue)
              .map { .fetchTodoList(.success($0)) }
          }
      }
    }
}

