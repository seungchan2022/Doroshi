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
    Text("Landing")
  }
}
