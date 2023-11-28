import Architecture
import LinkNavigator

struct SettingRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.setting.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        SettingPage(store: .init(
          initialState: SettingStore.State(),
          reducer: {
            SettingStore(env: SettingEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}
