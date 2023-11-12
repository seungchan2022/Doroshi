import Architecture
import LinkNavigator
import Domain

struct TodoEditorRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.todoEditor.rawValue

    return .init(matchPath: matchPath) { navigator, item, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }
      

      return WrappingController(matchPath: matchPath) {
        TodoEditorPage(store: .init(
          initialState: TodoEditorStore.State(injectionItem: item.decoded()),
          reducer: {
            TodoEditorStore(env: TodoEditorEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}
