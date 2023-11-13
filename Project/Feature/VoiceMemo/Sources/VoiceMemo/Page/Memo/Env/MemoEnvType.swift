import Combine
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MemoEnvType

protocol MemoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var memoList: () -> Effect<MemoStore.Action> { get }
  
  var deleteList: ([MemoEntity.Item]) -> Effect<MemoStore.Action> { get }
  
  var routeToTabItem: (String) -> Void { get }
  var routeToMemoEditor: (MemoEntity.Item?) -> Void { get }
}

extension MemoEnvType {
  var memoList: () -> Effect<MemoStore.Action> {
    {
      .publisher {
        useCaseGroup.memoUseCase.get()
          .receive(on: mainQueue)
          .mapToResult()
          .map(MemoStore.Action.fetchMemoList)
      }
    }
  }
  
  var deleteList: ([MemoEntity.Item]) -> Effect<MemoStore.Action> {
    { targetList in
        .publisher {
          Just(targetList.filter { $0.isChecked == true })
            .flatMap(useCaseGroup.memoUseCase.deleteTargetList)
            .receive(on: mainQueue)
            .mapToResult()
            .map(MemoStore.Action.fetchMemoList)
        }
    }
  }
}
