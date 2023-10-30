import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

struct AudioMemoEnvLive {

  let useCaseGroup: VoiceMemoEnvironmentUseable
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

extension AudioMemoEnvLive: AudioMemoEnvType {

}
