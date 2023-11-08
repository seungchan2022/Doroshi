import Foundation
import Domain

public struct TodoUseCasePlatform {
  
  public init() { }
  
  let client: TodoClient<[TodoEntity.Item]> = .init(key: "TodoList", defaultValue: [])
}

extension TodoUseCasePlatform: TodoUseCase {
 
  
  public var create: (TodoEntity.Item) -> TodoEntity.Item {
    { new in
      let currItemList = client.getItem() // 현재의 아이템 리스트를 불러오고
      let newItemList = currItemList.add(new: new).sorted(by: <)  // new라는 새로운 아이템을 추가하여 새로운 아이템 리스트를 만든다.
      client.savedItem(new: newItemList)  // 새로운 아이템 리스트를 저장
      return new
    }
  }
  
  public var deleteTargetList: ([TodoEntity.Item]) -> [TodoEntity.Item]  {
    { targetList in
      let currentItemList = client.getItem()
      let newItemList = currentItemList.delete(targetLiset: targetList)
      return client.savedItem(new: newItemList)
    }
  }
  
  
  public var edit: (TodoEntity.Item) -> TodoEntity.Item {
    { create($0) }
  }
  
  public var delete: (TodoEntity.Item) -> [TodoEntity.Item] {
    { target in
      let currentItemList = client.getItem()
      let newItemList = currentItemList.delete(target: target)
      return client.savedItem(new: newItemList)
      
    }
  }
  
  public var get: () -> [TodoEntity.Item] {
    {
      client.getItem()
    }
  }
  
}


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
    fileprivate func delete(targetLiset: [TodoEntity.Item]) -> Self {
      self.filter { item in
        !targetLiset.contains(where: { $0.id == item.id })
       }
    }
  
  // 단일 아이템 삭제
  fileprivate func delete(target: TodoEntity.Item) -> Self {
    self.filter { $0.id != target.id }
  }
  
  
  fileprivate func find(id: Double) -> TodoEntity.Item? {
    self.first(where: { $0.id == id })
  }
}
