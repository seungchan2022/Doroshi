import Foundation

// MARK: - TimerEntity

public enum TimerEntity { }

// MARK: TimerEntity.AlarmItem

extension TimerEntity {

  public struct AlarmItem: Equatable, Codable {

    public let hour: Int
    public let minute: Int
    public let second: Int

    public init(hour: Int, minute: Int, second: Int) {
      self.hour = hour
      self.minute = minute
      self.second = second
    }
  }

  public struct AlarmItem2: Equatable, Codable {
    let endDate: Date? // 현재시간 + 설정한 시간
    let elapsedTime: Double // EndDate(알람울리는 시간) - 현재시간 => 차이값
  }
}
