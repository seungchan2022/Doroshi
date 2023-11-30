import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
  /// 앱이 활성 상태일 대 알림이 도착하면 호출되는 메서드
  func userNotificationCenter(
    _: UNUserNotificationCenter,
    willPresent _: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
  {
    /// 앱이 포그라운드에 있을 때도 알림을 표시하도록 설정
    completionHandler([.banner, .sound])
  }
}
