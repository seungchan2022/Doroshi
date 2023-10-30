import Architecture
import LinkNavigator

struct LandingRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.landing.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        LandingPage(store: .init(
          initialState: LandingStore.State(),
          reducer: {
            LandingStore(env: LandingEnvLive(useCaseGroup: env))
          }))
      }
    }
  }
}
