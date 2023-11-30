import AVFoundation
import Combine
import CombineExt
import Domain
import Foundation

// MARK: - VoicePlayClient

final class VoicePlayClient: NSObject, ObservableObject {

  // MARK: Lifecycle

  override init() {
    super.init()
  }

  // MARK: Private

  private var audioPlayer: AudioPlayerCoordinator? = .none
}

extension VoicePlayClient {
  func start(id: String) -> AnyPublisher<VoiceEntity.Action, CompositeErrorRepository> {
    .create { observer in
      guard let path = FileManager.default.makePath(id) else {
        observer.send(completion: .failure(.notFoundFilePath))
        return AnyCancellable { }
      }

      do {
        let audioPlayer = AudioPlayerCoordinator(
          path: path,
          action: { observer.send($0) })
        try audioPlayer.start()
        self.audioPlayer = audioPlayer
      } catch {
        observer.send(completion: .failure(.notFoundFilePath))
      }

      return AnyCancellable {
        self.audioPlayer?.stop()
        self.audioPlayer = .none
      }
    }
  }

  func stop() -> AnyPublisher<Void, CompositeErrorRepository> {
    Future<Void, CompositeErrorRepository> { [weak self] promise in
      self?.audioPlayer?.stop()
      promise(.success(Void()))
    }
    .eraseToAnyPublisher()
  }

}

extension FileManager {
  fileprivate var makePath: (String) -> URL? {
    { name in
      self.urls(for: .documentDirectory, in: .userDomainMask)
        .first?
        .appending(component: "\(name)")
    }
  }
}

// MARK: - AudioPlayerCoordinator

private class AudioPlayerCoordinator: NSObject {

  // MARK: Lifecycle

  init(path: URL, action: @escaping (VoiceEntity.Action) -> Void) {
    self.path = path
    self.action = action
  }

  // MARK: Internal

  let path: URL
  let action: (VoiceEntity.Action) -> Void

  func start() throws {
    let audioPlayer = try AVAudioPlayer(contentsOf: path)
    audioPlayer.play()
    audioPlayer.volume = 1
    action(.playing)
    self.audioPlayer = audioPlayer
    self.audioPlayer?.delegate = self
  }

  func stop() {
    audioPlayer?.stop()
  }

  // MARK: Private

  private var audioPlayer: AVAudioPlayer? = .none
}

// MARK: AVAudioPlayerDelegate

extension AudioPlayerCoordinator: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
    action(.idle)
  }
}
