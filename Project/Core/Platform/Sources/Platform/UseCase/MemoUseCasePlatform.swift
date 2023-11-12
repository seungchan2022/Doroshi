import Foundation
import Domain

public struct MemoUseCasePlatform {
  
  public init() { }
  
  let client: StorageClient<[MemoEntity.Item]> = .init(type: .memo, defaultValue: [])
}

extension MemoUseCasePlatform: MemoUseCase {
  
  public var create: (MemoEntity.Item) -> MemoEntity.Item {
    { new in
      let currentItemList = client.getItem()
      let newItemList = currentItemList.add(new: new).sorted(by: <)
      client.savedItem(new: newItemList)
      return new
    }
  }
  
  public var deleteTargetList: ([MemoEntity.Item]) -> [MemoEntity.Item] {
    { targetList in
      let currentItemList = client.getItem()
      let newItemList = currentItemList.delete(targetList: targetList)
      return client.savedItem(new: newItemList)
    }
  }
  
  public var edit: (MemoEntity.Item) -> MemoEntity.Item {
    { create($0) }
  }
  
  public var get: () -> [MemoEntity.Item] {
    {
      client.getItem()
    }
  }
}

extension [MemoEntity.Item] {
  fileprivate func add(new: MemoEntity.Item) -> Self {
    self.filter { $0.id != new.id } + [new]
  }
  
  fileprivate func delete(targetList: [MemoEntity.Item]) -> Self {
    self.filter { item in
      !targetList.contains(where: { $0.id == item.id })
    }
  }
}
