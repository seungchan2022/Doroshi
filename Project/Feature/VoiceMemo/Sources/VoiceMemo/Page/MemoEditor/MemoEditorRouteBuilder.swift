import Architecture
import LinkNavigator

struct MemoEditorRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.memoEditor.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        MemoEditorPage(store: .init(
          initialState: MemoEditorStore.State(),
          reducer: {
            MemoEditorStore(env: MemoEditorEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}
