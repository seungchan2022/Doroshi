import Foundation

public protocol CacheUseCase {
  var getSetting: () -> SettingEntity { get }
  var setSetting: (SettingEntity) -> Void { get }
}
