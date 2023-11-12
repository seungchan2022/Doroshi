import Foundation
import Combine
import Domain

public struct VoiceUseCasePlatform {
  private let client = VoiceRecordClient()
  
  public init() { }
}

extension VoiceUseCasePlatform: VoiceUseCase {
  public  var start: (String) -> AnyPublisher<URL, CompositeErrorRepository> {
    { id in
       client
        .prepare()
        .map { _ in id }
        .flatMap(client.start(id:))
        .eraseToAnyPublisher()
    }
  }
  
  public var stop: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      client
        .stop()
        .eraseToAnyPublisher()
    }
  }
}
