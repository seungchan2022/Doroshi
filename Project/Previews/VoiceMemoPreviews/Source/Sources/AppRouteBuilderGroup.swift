import Foundation
import Architecture
import LinkNavigator
import VoiceMemo

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public var release: [RouteBuilderOf<RootNavigator>] {
    VoiceMemoRouteBuilderGroup.release
  }
}
