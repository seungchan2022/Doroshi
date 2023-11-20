import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - TestPage

struct TestPage {

  init(store: StoreOf<TestStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<TestStore>
  @ObservedObject private var viewStore: ViewStoreOf<TestStore>
}

extension TestPage { }

// MARK: View

extension TestPage: View {
  var body: some View {
    Text("Test")
  }
}
