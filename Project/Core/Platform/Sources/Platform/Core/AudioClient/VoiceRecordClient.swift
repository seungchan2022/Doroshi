import Foundation
import AVFoundation
import Domain
import Combine

final class VoiceRecordClient: NSObject {
  private var audioRecorder: AVAudioRecorder? = .none
  
  override init() {
    super.init()
  }
}

extension VoiceRecordClient {
  var prepare: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      Future<Void, CompositeErrorRepository> { promise in
        do {
          let session = AVAudioSession.sharedInstance()
          try session.setCategory(.playAndRecord, mode: .default)
          try session.setActive(true, options: .notifyOthersOnDeactivation)
          return promise(.success(Void()))
        } catch {
          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }
  
  func start(id: String) -> AnyPublisher<URL, CompositeErrorRepository> {
    Future<URL, CompositeErrorRepository> { [weak self] promise in
      guard let path = FileManager.default.makePath(id) else { return promise(.failure(.notFoundFilePath)) }
      
      print("파일 주소: ", path.absoluteString)
      do {
        let audioRecorder = try AVAudioRecorder(url: path, settings: .default)
        audioRecorder.delegate = self
        audioRecorder.record()
        self?.audioRecorder = audioRecorder
        return promise(.success(path))
      } catch {
        return promise(.failure(.other(error)))
      }
      
    }
    .eraseToAnyPublisher()
  }
  
  func stop() -> AnyPublisher<Void, CompositeErrorRepository> {
    Future<Void, CompositeErrorRepository> { [weak self] promise in
      self?.audioRecorder?.stop()
      self?.audioRecorder = .none
      promise(.success(Void()))
    }
    .eraseToAnyPublisher()
  }
}

extension VoiceRecordClient: AVAudioRecorderDelegate {
  func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    print("[Error] VoiceRecordClient: ", error?.localizedDescription ?? "")
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

extension [String: Any] {
  fileprivate static var `default`: Self {
    [
      AVFormatIDKey: Int(kAudioFormatLinearPCM),
      AVSampleRateKey: 44100,
      AVNumberOfChannelsKey: 1,
      AVLinearPCMBitDepthKey: 16,
      AVLinearPCMIsBigEndianKey: false,
      AVLinearPCMIsFloatKey: false,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
  }
}
