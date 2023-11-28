import Architecture
import LinkNavigator

struct TodoRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.todo.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        TodoPage(store: .init(
          initialState: TodoStore.State(),
          reducer: {
            TodoStore(env: TodoEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}
