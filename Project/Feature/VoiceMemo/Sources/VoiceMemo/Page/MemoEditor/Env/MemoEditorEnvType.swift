import Combine
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MemoEditorEnvType

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
            .flatMap(useCaseGroup.memoUseCase.createOrUpdate)
            .receive(on: mainQueue)
            .mapToResult()
            .map(MemoEditorStore.Action.fetchCreate)
        }
        
    }
  }
}

extension MemoEditorStore.State {
  fileprivate func serialized() -> MemoEntity.Item {
    .init(isChecked: .none, title: title, date: date.timeIntervalSince1970, content: content)
  }
}

