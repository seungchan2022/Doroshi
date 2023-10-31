import Foundation
import ComposableArchitecture
import Domain
import Combine

protocol TodoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var todoList: () -> Effect<TodoStore.Action> { get }
  
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
}
