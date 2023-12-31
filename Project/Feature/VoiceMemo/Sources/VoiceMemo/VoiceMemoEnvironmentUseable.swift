import Domain

public protocol VoiceMemoEnvironmentUseable {
  var todoUseCase: TodoUseCase { get }
  var memoUseCase: MemoUseCase { get }
  var settingUseCase: SettingUseCase { get }
  var voiceUseCase: VoiceUseCase { get }
  var cacheUseCase: CacheUseCase { get }
}
