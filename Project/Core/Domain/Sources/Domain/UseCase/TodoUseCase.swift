import Foundation
import Combine

public protocol TodoUseCase {
  var createOrUpdate: (TodoEntity.Item) -> AnyPublisher<TodoEntity.Item, CompositeErrorRepository> { get }
  var deleteTargetList: ([TodoEntity.Item]) -> AnyPublisher<[TodoEntity.Item], CompositeErrorRepository> { get }
  var get: () -> AnyPublisher<[TodoEntity.Item], CompositeErrorRepository> { get }
}

