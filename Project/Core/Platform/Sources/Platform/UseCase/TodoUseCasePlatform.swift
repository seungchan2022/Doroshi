import Foundation
import Domain

public struct TodoUseCasePlatform {
  
  public init() { }
  
  let client: TodoClient<[TodoEntity.Item]> = .init(key: "TodoList", defaultValue: [])
}

extension TodoUseCasePlatform: TodoUseCase {
  public var create: (TodoEntity.Item) -> TodoEntity.Item {
    { new in
      let currItemList = client.getItem()
      let newItemList = currItemList.add(new: new).sorted(by: <)
      client.savedItem(new: newItemList)
      return new
    }
  }
  
  public var delete: ([TodoEntity.Item]) -> [TodoEntity.Item] {
    { targetList in
      let currItemList = client.getItem()
      let newItemList = currItemList.delete(targetLiset: targetList)
      return client.savedItem(new: newItemList)
    }
  }
  
  public var edit: (TodoEntity.Item) -> TodoEntity.Item {
    { create($0) }
  }
  
  public var get: () -> [TodoEntity.Item] {
    {
      client.getItem()
    }
  }
  
}

extension [TodoEntity.Item] {
  fileprivate func add(new: TodoEntity.Item) -> Self {
    self.filter { $0.id != new.id } + [new]
  }
  
  fileprivate func delete(targetLiset: [TodoEntity.Item]) -> Self {
    self.filter { item in
      !targetLiset.contains(where: { $0.id == item.id })
    }
  }
}
