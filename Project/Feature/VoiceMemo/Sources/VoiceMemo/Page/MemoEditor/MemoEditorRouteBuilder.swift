import Architecture
import LinkNavigator
import Domain

struct MemoEditorRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.memoEditor.rawValue

    return .init(matchPath: matchPath) { navigator, item, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }
      let query: MemoEntity.Item? = item.decoded()
      let mutation = query?.serialized()
      
      return WrappingController(matchPath: matchPath) {
        MemoEditorPage(store: .init(
          initialState: MemoEditorStore.State(title: mutation?.title, date: mutation?.date, content: mutation?.content),
          reducer: {
            MemoEditorStore(env: MemoEditorEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}

extension MemoEntity.Item {
  fileprivate func serialized() -> MemoEditorStore.State {
    .init(
      title: title,
      date: .init(timeIntervalSince1970: date),
      content: content)
  }
}
