import Domain
import Foundation
import Combine

// MARK: - MemoUseCasePlatform

public struct MemoUseCasePlatform {
  
  public init() { }
  
  let client: StorageClient<[MemoEntity.Item]> = .init(type: .memo, defaultValue: [])
}

// MARK: MemoUseCase

extension MemoUseCasePlatform: MemoUseCase {
  
  public var createOrUpdate: (MemoEntity.Item) -> AnyPublisher<MemoEntity.Item, CompositeErrorRepository> {
    { new in
      Future<MemoEntity.Item, CompositeErrorRepository> { promise in
        let currentItemList = client.getItem()
        let newItemList = currentItemList.add(new: new).sorted(by: <)
        client.savedItem(new: newItemList)
        return promise(.success(new))
      }
      .eraseToAnyPublisher()
    }
  }
  
  public var deleteTargetList: ([MemoEntity.Item]) -> AnyPublisher<[MemoEntity.Item], CompositeErrorRepository> {
    { targetList in
      Future<[MemoEntity.Item], CompositeErrorRepository> { promise in
        let currentItemList = client.getItem()
        let newItemList = currentItemList.delete(targetList: targetList)
        return promise(.success(client.savedItem(new: newItemList)))
      }
      .eraseToAnyPublisher()
    }
  }
  
  
  public var get: () -> AnyPublisher<[MemoEntity.Item], CompositeErrorRepository> {
    {
      Future<[MemoEntity.Item], CompositeErrorRepository> { promise in
        promise(.success(client.getItem()))
      }
      .eraseToAnyPublisher()
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
