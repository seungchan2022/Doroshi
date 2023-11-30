import Combine
import Foundation

public protocol MemoUseCase {
  var createOrUpdate: (MemoEntity.Item) -> AnyPublisher<MemoEntity.Item, CompositeErrorRepository> { get }
  var deleteTargetList: ([MemoEntity.Item]) -> AnyPublisher<[MemoEntity.Item], CompositeErrorRepository> { get }
  var get: () -> AnyPublisher<[MemoEntity.Item], CompositeErrorRepository> { get }
}
