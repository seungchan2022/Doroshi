import Foundation

public struct SettingEntity {
  public let alarmItem: TimerEntity.AlarmItem?
  
  public init(alarmItem: TimerEntity.AlarmItem?) {
    self.alarmItem = alarmItem
  }
  
  public func mutate(alarmItem: TimerEntity.AlarmItem?) -> Self {
    .init(alarmItem: alarmItem)
  }
}
