import Architecture
import LinkNavigator

struct TimerRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.timer.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        TimerPage(store: .init(
          initialState: TimerStore.State(),
          reducer: {
            TimerStore(env: TimerEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}
