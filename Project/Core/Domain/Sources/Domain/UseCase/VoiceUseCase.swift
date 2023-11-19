import Foundation
import Combine

public protocol VoiceUseCase {
  var startRecording: (String) -> AnyPublisher<URL, CompositeErrorRepository> { get }
  var stopRecording: () -> AnyPublisher<Void, CompositeErrorRepository> { get }
  
  var getRecordingList: () -> AnyPublisher<[String], CompositeErrorRepository> { get }
  
  var startPlaying: (String) -> AnyPublisher<URL, CompositeErrorRepository> { get }
  var stopPalying: () -> AnyPublisher<Void, CompositeErrorRepository> { get }
}
