import Combine
import Domain
import Foundation

// MARK: - TodoUseCasePlatform

public struct TodoUseCasePlatform {

  public init() { }

  let client: StorageClient<[TodoEntity.Item]> = .init(type: .todo, defaultValue: [])
}

// MARK: TodoUseCase

extension TodoUseCasePlatform: TodoUseCase {

  public var createOrUpdate: (TodoEntity.Item) -> AnyPublisher<TodoEntity.Item, CompositeErrorRepository> {
    { new in
      Future<TodoEntity.Item, CompositeErrorRepository> { promise in
        let currItemList = client.getItem() // 현재의 아이템 리스트를 불러오고
        let newItemList = currItemList.add(new: new).sorted(by: <) // new라는 새로운 아이템을 추가하여 새로운 아이템 리스트를 만든다.
        client.savedItem(new: newItemList) // 새로운 아이템 리스트를 저장
        return promise(.success(new))
      }
      .eraseToAnyPublisher()
    }
  }

  public var deleteTargetList: ([TodoEntity.Item]) -> AnyPublisher<[TodoEntity.Item], CompositeErrorRepository> {
    { targetList in
      Future<[TodoEntity.Item], CompositeErrorRepository> { promise in
        let currentItemList = client.getItem()
        let newItemList = currentItemList.delete(targetList: targetList)
        return promise(.success(client.savedItem(new: newItemList)))
      }
      .eraseToAnyPublisher()
    }
  }

  public var get: () -> AnyPublisher<[TodoEntity.Item], CompositeErrorRepository> {
    {
      Future<[TodoEntity.Item], CompositeErrorRepository> { promise in
        promise(.success(client.getItem()))
      }
      .eraseToAnyPublisher()
    }
  }

}

//
extension TodoEntity.Item {
  func mutate(title: String?) -> Self {
    .init(isChecked: isChecked, title: title, date: date)
  }

  func mutate(date: Double) -> Self {
    .init(isChecked: isChecked, title: title, date: date)
  }

  func mutate(isChecked: Bool) -> Self {
    .init(isChecked: isChecked, title: title, date: date)
  }

}

extension [TodoEntity.Item] {
  // id가 다르면 새로 추가
  fileprivate func add(new: TodoEntity.Item) -> Self {
    self.filter { $0.id != new.id } + [new]
  }

  // id가 같은 것들을 포함하지 하지 않는 것들만 새로 배열을 만드는 것 => 현재 배열에서 targerList에 있는 것들을 포함하지 않는 배열을 새로 만듬
  fileprivate func delete(targetList: [TodoEntity.Item]) -> Self {
    self.filter { item in
      !targetList.contains(where: { $0.id == item.id })
    }
  }

  fileprivate func find(id: Double) -> TodoEntity.Item? {
    self.first(where: { $0.id == id })
  }
}
