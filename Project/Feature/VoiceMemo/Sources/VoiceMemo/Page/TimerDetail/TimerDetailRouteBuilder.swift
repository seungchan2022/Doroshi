import Architecture
import Domain
import LinkNavigator

struct TimerDetailRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.VoiceMemo.Path.timerDetail.rawValue

    return .init(matchPath: matchPath) { navigator, item, diContainer -> RouteViewController? in
      guard let env: VoiceMemoEnvironmentUseable = diContainer.resolve() else { return .none }
      guard let query: TimerEntity.AlarmItem = item.decoded() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        TimerDetailPage(store: .init(
          initialState: TimerDetailStore.State(
            alarmInfo: query),
          reducer: {
            TimerDetailStore(env: TimerDetailEnvLive(useCaseGroup: env, navigator: navigator))
          }))
      }
    }
  }
}
