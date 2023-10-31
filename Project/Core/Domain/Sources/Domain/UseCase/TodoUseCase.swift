import Foundation

public protocol TodoUseCase {
  var create: (TodoEntity.Item) -> TodoEntity.Item { get }
  var delete: ([TodoEntity.Item]) -> [TodoEntity.Item] { get }
  var edit: (TodoEntity.Item) -> TodoEntity.Item { get }
  var get: () -> [TodoEntity.Item] { get }
}
