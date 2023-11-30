import Combine
import Domain
import Foundation

// MARK: - VoiceUseCasePlatform

public struct VoiceUseCasePlatform {
  private let recordClient = VoiceRecordClient()
  private let playClient = VoicePlayClient()

  public init() { }
}

// MARK: VoiceUseCase

extension VoiceUseCasePlatform: VoiceUseCase {
  public var startRecording: (String) -> AnyPublisher<URL, CompositeErrorRepository> {
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

  public var getRecordingList: () -> AnyPublisher<[String], CompositeErrorRepository> {
    {
      recordClient
        .pathRecordingList()
        .eraseToAnyPublisher()
    }
  }

  public var deleteRecord: (String) -> AnyPublisher<String, CompositeErrorRepository> {
    { id in
      recordClient
        .deleteRecording(id: id)
        .eraseToAnyPublisher()
    }
  }

  public var startPlaying: (String) -> AnyPublisher<VoiceEntity.Action, CompositeErrorRepository> {
    { id in
      playClient
        .start(id: id)
        .eraseToAnyPublisher()
    }
  }

  public var stopPlaying: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      playClient
        .stop()
        .eraseToAnyPublisher()
    }
  }
}
