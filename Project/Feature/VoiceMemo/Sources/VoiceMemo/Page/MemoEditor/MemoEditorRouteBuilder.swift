import Architecture
import Domain
import LinkNavigator

// MARK: - MemoEditorRouteBuilder

struct MemoEditorRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.memoEditor.rawValue

    return .init(matchPath: matchPath) { navigator, item, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        MemoEditorPage(store: .init(
          initialState: MemoEditorStore.State(injectionItem: item.decoded()),
          reducer: {
            MemoEditorStore(env: MemoEditorEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}

