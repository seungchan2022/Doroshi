import Foundation
import Domain

public struct SettingUseCasePlatform {
  
  public init() { }
  
  let todoClient: TodoClient<[TodoEntity.Item]> = .init(key: "TodoList", defaultValue: [])
  let memoClient: MemoClient<[MemoEntity.Item]> = .init(key: "MemoList", defaultValue: [])
}

extension SettingUseCasePlatform: SettingUseCase {
  public var getTodoList: () -> [TodoEntity.Item] {
    {
      todoClient.getItem()
    }
  }
  
  public var getMemoList: () -> [MemoEntity.Item] {
    {
      memoClient.getItem()
    }
  }
}
