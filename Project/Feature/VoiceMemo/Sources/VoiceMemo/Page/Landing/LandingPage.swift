import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

struct LandingPage {

  init(store: StoreOf<LandingStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<LandingStore>
  @ObservedObject private var viewStore: ViewStoreOf<LandingStore>
}

extension LandingPage {
}

extension LandingPage: View {
  var body: some View {
    VStack {
      Spacer()
      Text("Landing")
      Spacer()
      Button(action: { viewStore.send(.routeToAudioMemo) }) {
        Text("시작하기")
      }
      .padding(.bottom, 30)
    }
  }
}
