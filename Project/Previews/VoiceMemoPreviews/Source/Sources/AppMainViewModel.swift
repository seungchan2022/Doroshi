import Foundation
import Domain
import VoiceMemo
import LinkNavigator

@Observable
final class AppMainViewModel {
  
  let linkNavigator: SingleLinkNavigator
  
  init() {
    linkNavigator = .init(
      routeBuilderItemList: AppRouteBuilderGroup().release,
      dependency: AppSideEffect.build())
  }
}
