import Foundation
import Domain

public struct CacheUseCasePlatform {
  private let store: CacheStore
  
  public init(setting: SettingEntity = .init(alarmItem: .none)) {
    self.store = .init(setting: setting)
  }
}

extension CacheUseCasePlatform: CacheUseCase {
  public var getSetting: () -> SettingEntity {
    {
      store.setting
    }
  }
  
  public var setSetting: (SettingEntity) -> Void {
    {
      store.setting = $0
    }
  }
}

private final class CacheStore {
  var setting: SettingEntity
  
  init(setting: SettingEntity) {
    self.setting = setting
  }
}
