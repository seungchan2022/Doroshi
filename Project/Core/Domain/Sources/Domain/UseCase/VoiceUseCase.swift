import Combine
import Foundation

public protocol VoiceUseCase {
  var startRecording: (String) -> AnyPublisher<URL, CompositeErrorRepository> { get }
  var stopRecording: () -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var getRecordingList: () -> AnyPublisher<[String], CompositeErrorRepository> { get }
  var deleteRecord: (String) -> AnyPublisher<String, CompositeErrorRepository> { get }

  var startPlaying: (String) -> AnyPublisher<VoiceEntity.Action, CompositeErrorRepository> { get }
  var stopPlaying: () -> AnyPublisher<Void, CompositeErrorRepository> { get }
}
