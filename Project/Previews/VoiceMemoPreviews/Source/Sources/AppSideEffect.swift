import Foundation
import Domain
import VoiceMemo
import Platform
import LinkNavigator

struct AppSideEffect: DependencyType, VoiceMemoEnvironmentUseable {
}

extension AppSideEffect {
  static func build() -> Self {
    .init()
  }
}
