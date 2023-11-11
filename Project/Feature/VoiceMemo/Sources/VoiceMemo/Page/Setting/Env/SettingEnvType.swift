import Foundation
import ComposableArchitecture
import Domain
import Combine

protocol SettingEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var todoList: () -> Effect<SettingStore.Action> { get }
  var memoList: () -> Effect<SettingStore.Action> { get }
  
  var routeToTabItem: (String) -> Void { get }
  
  var routeToTodo: () -> Void { get }
  var routeToMemo: () -> Void { get }
  var routeToAudioMemo: () -> Void { get }
  var routeToTimer: () -> Void { get }
}


extension SettingEnvType {
  var todoList: () -> Effect<SettingStore.Action> {
    {
      .publisher {
        Just(useCaseGroup.settingUseCase.getTodoList())
          .receive(on: mainQueue)
          .map { .fetchTodoList(.success($0)) }
      }
    }
    
    
  }
  
  
  var memoList: () -> Effect<SettingStore.Action> {
    {
      .publisher {
        Just(useCaseGroup.settingUseCase.getMemoList())
          .receive(on: mainQueue)
          .map { .fetchMemoList(.success($0)) }
      }
    }
  }

}
