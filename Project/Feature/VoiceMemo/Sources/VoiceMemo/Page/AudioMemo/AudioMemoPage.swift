import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

struct AudioMemoPage {

  init(store: StoreOf<AudioMemoStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<AudioMemoStore>
  @ObservedObject private var viewStore: ViewStoreOf<AudioMemoStore>
}

extension AudioMemoPage {
}

extension AudioMemoPage: View {
  var body: some View {
    Text("AudioMemo")
  }
}
