import Architecture
import LinkNavigator

struct AudioMemoRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.audioMemo.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        AudioMemoPage(store: .init(
          initialState: AudioMemoStore.State(),
          reducer: {
            AudioMemoStore(env: AudioMemoEnvLive(useCaseGroup: env))
          }))
      }
    }
  }
}
