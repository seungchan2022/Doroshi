import Foundation
import Domain
import VoiceMemo
import Platform
import LinkNavigator

struct AppSideEffect: DependencyType, VoiceMemoEnvironmentUseable {
  let todoUseCase: TodoUseCase
}

extension AppSideEffect {
  static func build() -> Self {
    .init(todoUseCase: TodoUseCasePlatform())
  }
}
