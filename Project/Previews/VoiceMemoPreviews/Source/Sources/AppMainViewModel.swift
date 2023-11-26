import Domain
import UserNotifications
import Foundation
import LinkNavigator
import VoiceMemo

@Observable
final class AppMainViewModel {

  // MARK: Lifecycle

  init() {
    linkNavigator = .init(
      routeBuilderItemList: AppRouteBuilderGroup().release,
      dependency: AppSideEffect.build())
    
    /// 알림 센터에 NotificationDelegate를 지정
    UNUserNotificationCenter.current().delegate = notificationDelegate
  }

  // MARK: Internal

  let linkNavigator: SingleLinkNavigator
  let notificationDelegate = NotificationDelegate()
}
