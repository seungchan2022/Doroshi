import Domain
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
  }

  // MARK: Internal

  let linkNavigator: SingleLinkNavigator
}
