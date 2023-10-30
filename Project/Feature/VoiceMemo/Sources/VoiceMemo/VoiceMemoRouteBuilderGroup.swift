import Architecture
import LinkNavigator

public struct VoiceMemoRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension VoiceMemoRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      LandingRouteBuilder.generate(),
    ]
  }
}
