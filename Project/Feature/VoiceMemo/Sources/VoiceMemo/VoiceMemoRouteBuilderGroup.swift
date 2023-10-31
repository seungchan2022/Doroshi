import Architecture
import LinkNavigator

public struct VoiceMemoRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension VoiceMemoRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      LandingRouteBuilder.generate(),
      TodoRouteBuilder.generate(),
      MemoRouteBuilder.generate(),
      AudioMemoRouteBuilder.generate(),
      TimerRouteBuilder.generate(),
      SettingRouteBuilder.generate(),
      TodoEditorRouteBuilder.generate(),
    ]
  }
}
