import Domain
import Foundation
import LinkNavigator
import Platform
import VoiceMemo

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, VoiceMemoEnvironmentUseable {
  let todoUseCase: TodoUseCase
  let memoUseCase: MemoUseCase
  let settingUseCase: SettingUseCase
  let voiceUseCase: VoiceUseCase
}

extension AppSideEffect {
  static func build() -> Self {
    .init(
      todoUseCase: TodoUseCasePlatform(),
      memoUseCase: MemoUseCasePlatform(),
      settingUseCase: SettingUseCasePlatform(),
      voiceUseCase: VoiceUseCasePlatform())
  }
}
