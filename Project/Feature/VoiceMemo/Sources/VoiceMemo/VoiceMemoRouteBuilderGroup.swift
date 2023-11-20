import Architecture
import LinkNavigator

// MARK: - VoiceMemoRouteBuilderGroup

public struct VoiceMemoRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension VoiceMemoRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      LandingRouteBuilder.generate(),
      AudioMemoRouteBuilder.generate(),
      TodoRouteBuilder.generate(),
      TodoEditorRouteBuilder.generate(),
      MemoRouteBuilder.generate(),
      MemoEditorRouteBuilder.generate(),
      TimerRouteBuilder.generate(),
      TimerDetailRouteBuilder.generate(),
      SettingRouteBuilder.generate(),
    ]
  }
}
