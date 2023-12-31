import AVFoundation
import Combine
import Domain
import Foundation

// MARK: - VoiceRecordClient

final class VoiceRecordClient: NSObject {

  // MARK: Lifecycle

  override init() {
    super.init()
  }

  // MARK: Private

  private var audioRecorder: AVAudioRecorder? = .none
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

  func pathRecordingList() -> AnyPublisher<[String], CompositeErrorRepository> {
    Future<[String], CompositeErrorRepository> { promise in
      guard let pathDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
      else { return promise(.failure(.notFoundFilePath)) }

      print("녹음된 파일들 주소: ", pathDirectory.absoluteString)

      do {
        let url = try FileManager.default.contentsOfDirectory(at: pathDirectory, includingPropertiesForKeys: .none)
        let recordingList = url.filter { $0.pathExtension == "wav" }.map { $0.lastPathComponent }
        return promise(.success(recordingList))
      } catch {
        return promise(.failure(.other(error)))
      }
    }
    .eraseToAnyPublisher()
  }

  func deleteRecording(id: String) -> AnyPublisher<String, CompositeErrorRepository> {
    Future<String, CompositeErrorRepository> { promise in
      guard let path = FileManager.default.findPath(id) else { return promise(.failure(.notFoundFilePath)) }
      do {
        try FileManager.default.removeItem(at: path)
        return promise(.success(id))
      } catch {
        return promise(.failure(.other(error)))
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: AVAudioRecorderDelegate

extension VoiceRecordClient: AVAudioRecorderDelegate {
  func audioRecorderEncodeErrorDidOccur(_: AVAudioRecorder, error: Error?) {
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

  fileprivate var findPath: (String) -> URL? {
    { name in
      self.urls(for: .documentDirectory, in: .userDomainMask)
        .first?
        .appending(component: "\(name)")
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
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
    ]
  }
}
