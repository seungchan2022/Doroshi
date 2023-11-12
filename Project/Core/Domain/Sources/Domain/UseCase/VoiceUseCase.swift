import Foundation
import Combine

public protocol VoiceUseCase {
  var start: (String) -> AnyPublisher<URL, CompositeErrorRepository> { get }
  var stop: () -> AnyPublisher<Void, CompositeErrorRepository> { get }
}
