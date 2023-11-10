import Foundation
import ComposableArchitecture
import Domain
import Combine

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
        Just(useCaseGroup.memoUseCase.get())
          .receive(on: mainQueue)
          .map { .fetchMemoList(.success($0)) }
      }
    }
  }
  
  var deleteList: ([MemoEntity.Item]) -> Effect<MemoStore.Action> {
    { targetList in
        .publisher {
          Just(targetList.filter { $0.isChecked == true })
            .map(useCaseGroup.memoUseCase.deleteTargetList)
            .receive(on: mainQueue)
            .map { .fetchMemoList(.success($0)) }
        }
    }
  }
}
