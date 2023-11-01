import Foundation
import ComposableArchitecture
import Domain
import Combine

protocol MemoEditorEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var save: (MemoEditorStore.State) -> Effect<MemoEditorStore.Action> { get }
  
  var routeToBack: () -> Void { get }
  
}

extension MemoEditorEnvType {
  var save: (MemoEditorStore.State) -> Effect<MemoEditorStore.Action> {
    { state in
        .publisher {
          Just(state.serialized())
            .map(useCaseGroup.memoUseCase.create)
            .receive(on: mainQueue)
            .map {
              MemoEditorStore.Action.fetchCreate(.success($0))
            }
        }
    }
  }
}

extension MemoEditorStore.State {
  fileprivate func serialized() -> MemoEntity.Item {
    .init(isChecked: .none, title: title, date: date.timeIntervalSince1970, content: content)
  }
}
