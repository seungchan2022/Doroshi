import Foundation
import Domain

public struct SettingUseCasePlatform {
  
  public init() { }
  
  let todoClient: StorageClient<[TodoEntity.Item]> = .init(type: .todo, defaultValue: [])
  let memoClient: StorageClient<[MemoEntity.Item]> = .init(type: .memo, defaultValue: [])
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
