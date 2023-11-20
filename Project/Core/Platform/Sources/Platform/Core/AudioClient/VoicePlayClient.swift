import Foundation
import AVFoundation
import Domain
import Combine
import CombineExt


final class VoicePlayClient: NSObject, ObservableObject {
  
  override init() {
    super.init()
  }
  
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

private class AudioPlayerCoordinator: NSObject {
  let path: URL
  let action: (VoiceEntity.Action) -> Void
  
  private var audioPlayer: AVAudioPlayer? = .none
  
  init(path: URL, action: @escaping (VoiceEntity.Action) -> Void) {
    self.path = path
    self.action = action
  }
  
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
}

extension AudioPlayerCoordinator: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    action(.idle)
  }
}
