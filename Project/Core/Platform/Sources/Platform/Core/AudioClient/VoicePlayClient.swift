import Foundation
import AVFoundation
import Domain
import Combine


final class VoicePlayClient: NSObject, ObservableObject {
  private var audioPlayer: AVAudioPlayer? = .none
  
  override init() {
    super.init()
  }
}

extension VoicePlayClient {
  func start(id: String) -> AnyPublisher<URL, CompositeErrorRepository> {
    Future<URL, CompositeErrorRepository> { [weak self] promise in
      guard let path = FileManager.default.makePath(id) else { return promise(.failure(.notFoundFilePath)) }
      
      print("파일: ", path.absoluteString)
      
      do {
        let audioPlayer = try AVAudioPlayer(contentsOf: path)
        audioPlayer.play()
        self?.audioPlayer = audioPlayer
      } catch {
        return promise(.failure(.other(error)))
      }
      
    }
    .eraseToAnyPublisher()
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
        .appending(component: "\(name).wav")
    }
  }
}
