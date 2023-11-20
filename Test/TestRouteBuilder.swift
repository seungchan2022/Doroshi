import Architecture
import LinkNavigator

struct TestRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = "test"

    return .init(matchPath: matchPath) { _, _, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        TestPage(store: .init(
          initialState: TestStore.State(),
          reducer: {
            TestStore(env: TestEnvLive(useCaseGroup: env))
          }))
      }
    }
  }
}
