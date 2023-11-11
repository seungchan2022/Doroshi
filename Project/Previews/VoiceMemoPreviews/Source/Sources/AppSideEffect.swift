import Foundation
import Domain
import VoiceMemo
import Platform
import LinkNavigator

struct AppSideEffect: DependencyType, VoiceMemoEnvironmentUseable {
  let todoUseCase: TodoUseCase
  let memoUseCase: MemoUseCase
  let settingUseCase: SettingUseCase
}

extension AppSideEffect {
  static func build() -> Self {
    .init(
      todoUseCase: TodoUseCasePlatform(),
      memoUseCase: MemoUseCasePlatform(),
      settingUseCase: SettingUseCasePlatform())
  }
}
