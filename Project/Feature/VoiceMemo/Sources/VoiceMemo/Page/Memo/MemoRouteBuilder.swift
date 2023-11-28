import Architecture
import LinkNavigator

struct MemoRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.memo.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        MemoPage(store: .init(
          initialState: MemoStore.State(),
          reducer: {
            MemoStore(env: MemoEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}
