import Domain

public protocol VoiceMemoEnvironmentUseable {
  var todoUseCase: TodoUseCase { get }
  var memoUseCase: MemoUseCase { get }
}
