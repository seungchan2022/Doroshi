import Foundation

public protocol MemoUseCase {
  var create: (MemoEntity.Item) -> MemoEntity.Item { get }
  var delete: ([MemoEntity.Item]) -> [MemoEntity.Item] { get }
  var edit: (MemoEntity.Item) -> MemoEntity.Item { get }
  var get: () -> [MemoEntity.Item] { get }
}