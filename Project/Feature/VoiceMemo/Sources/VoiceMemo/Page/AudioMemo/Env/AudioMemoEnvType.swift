import ComposableArchitecture
import CombineExt
import Domain
import Foundation

// MARK: - AudioMemoEnvType

protocol AudioMemoEnvType {
  var useCaseGroup: VoiceMemoEnvironmentUseable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  
  var recordStart: (String) -> Effect<AudioMemoStore.Action> { get }
  var recordStop: () -> Effect<AudioMemoStore.Action> { get }
  
  var recordList: () -> Effect<AudioMemoStore.Action> { get }
  
  var playStart: (String) -> Effect<AudioMemoStore.Action> { get }
  var playStop: () -> Effect<AudioMemoStore.Action> { get }
  
  var routeToTabItem: (String) -> Void { get }
}

extension AudioMemoEnvType {
  
  var recordStart: (String) -> Effect<AudioMemoStore.Action> {
    { id in
        .publisher{
          useCaseGroup.voiceUseCase
            .startRecording(id)
            .receive(on: mainQueue)
            .map { _ in true }
            .mapToResult()
            .map(AudioMemoStore.Action.fetchRecord)
        }
    }
  }
  
  var recordStop: () -> Effect<AudioMemoStore.Action> {
    {
      .publisher{
        useCaseGroup.voiceUseCase
          .stopRecording()
          .receive(on: mainQueue)
          .map { _ in false }
          .mapToResult()
          .map(AudioMemoStore.Action.fetchRecord)
      }
    }
  }
  
  var recordList: () -> Effect<AudioMemoStore.Action> {
    {
      .publisher {
        useCaseGroup.voiceUseCase
          .getRecordingList()
          .receive(on: mainQueue)
          .mapToResult()
          .map(AudioMemoStore.Action.fetchRecordList)
          
      }
    }
  }
  
  var playStart: (String) -> Effect<AudioMemoStore.Action> {
    { id in
        .publisher {
          useCaseGroup.voiceUseCase
            .startPlaying(id)
            .receive(on: mainQueue)
            .map { item in
              print("AAA: ", item)
              switch item {
              case .idle: return false
              case .playing: return true
              }
            }
            .mapToResult()
            .map(AudioMemoStore.Action.fetchPlay)
        }
    }
    
  }
  
  var playStop: () -> Effect<AudioMemoStore.Action> {
    {
      .publisher {
        useCaseGroup.voiceUseCase
          .stopPlaying()
          .receive(on: mainQueue)
          .map { _ in false }
          .mapToResult()
          .map(AudioMemoStore.Action.fetchPlay)
      }
    }
  }
}
