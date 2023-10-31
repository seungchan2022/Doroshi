import Architecture
import LinkNavigator
import Domain

struct TodoEditorRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.todoEditor.rawValue

    return .init(matchPath: matchPath) { navigator, item, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }
      let query: TodoEntity.Item? = item.decoded()
      let mutation = query?.serialized()
      

      return WrappingController(matchPath: matchPath) {
        TodoEditorPage(store: .init(
          initialState: TodoEditorStore.State(title: mutation?.title, date: mutation?.date),
          reducer: {
            TodoEditorStore(env: TodoEditorEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}

extension TodoEntity.Item {
  fileprivate func serialized() -> TodoEditorStore.State {
    .init(
      title: title,
      date: .init(timeIntervalSince1970: date))
  }
}
