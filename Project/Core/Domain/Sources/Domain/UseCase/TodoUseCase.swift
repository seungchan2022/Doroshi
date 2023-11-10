import Foundation

public protocol TodoUseCase {
  var create: (TodoEntity.Item) -> TodoEntity.Item { get }
  var deleteTargetList: ([TodoEntity.Item]) -> [TodoEntity.Item] { get }
  var edit: (TodoEntity.Item) -> TodoEntity.Item { get }
  var get: () -> [TodoEntity.Item] { get }
}

