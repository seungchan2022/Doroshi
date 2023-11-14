import Foundation
import Combine
import Domain

public struct VoiceUseCasePlatform {
  private let recordClient = VoiceRecordClient()
  private let playCliennt = VoicePlayClient()
  
  public init() { }
}

extension VoiceUseCasePlatform: VoiceUseCase {
  public  var startRecording: (String) -> AnyPublisher<URL, CompositeErrorRepository> {
    { id in
      recordClient
        .prepare()
        .map { _ in id }
        .flatMap(recordClient.start(id:))
        .eraseToAnyPublisher()
    }
  }
  
  public var stopRecording: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      recordClient
        .stop()
        .eraseToAnyPublisher()
    }
  }
  
  public var startPlaying: (String) -> AnyPublisher<URL, CompositeErrorRepository> {
    { id in
      playCliennt
        .start(id: id)
        .eraseToAnyPublisher()
    }
  }
  
  public var stopPalying: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      playCliennt
        .stop()
        .eraseToAnyPublisher()
    }
  }
}
