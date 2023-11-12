import Foundation
import ComposableArchitecture
import Domain
import Combine
import CombineExt

protocol TodoEditorEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var save: (TodoEditorStore.State) -> Effect<TodoEditorStore.Action> { get }
  
  var routeToBack: () -> Void { get }
}


extension TodoEditorEnvType {
  var save: (TodoEditorStore.State) -> Effect<TodoEditorStore.Action> {
    { state in
        .publisher {
          Just(state.serialized())
            .flatMap(useCaseGroup.todoUseCase.createOrUpdate)
            .receive(on: mainQueue)
            .mapToResult()
            .map(TodoEditorStore.Action.fetchCreate)
        }
    }
  }
}

extension TodoEditorStore.State {
  fileprivate func serialized() -> TodoEntity.Item {
    .init(isChecked: .none, title: title, date: date.timeIntervalSince1970)
  }
}
