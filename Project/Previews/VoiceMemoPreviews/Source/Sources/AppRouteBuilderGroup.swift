import Architecture
import Foundation
import LinkNavigator
import VoiceMemo

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public var release: [RouteBuilderOf<RootNavigator>] {
    VoiceMemoRouteBuilderGroup.release
  }
}
