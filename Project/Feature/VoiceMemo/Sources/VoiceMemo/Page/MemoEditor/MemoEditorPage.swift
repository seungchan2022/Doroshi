import Architecture
import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - MemoEditorPage

struct MemoEditorPage {

  init(store: StoreOf<MemoEditorStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<MemoEditorStore>
  @ObservedObject private var viewStore: ViewStoreOf<MemoEditorStore>
}

extension MemoEditorPage {
  private var title: String {
    ""
  }
}

// MARK: View

extension MemoEditorPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(
          backAction: { viewStore.send(.onTapBack) },
          moreActionList: [
            .init(title: "생성", action: { viewStore.send(.onTapCreate) }),
          ]),
        title: title)
      {
        VStack(alignment: .leading, spacing: 20) {
          TextField(
            "",
            text: viewStore.$title,
            prompt: .init("제목을 입력하세요."))
            .font(.system(size: 30))

          Divider()
            .background(DesignSystemColor.palette(.gray(.lv100)).color)

          ZStack(alignment: .topLeading) {
            TextEditor(text: viewStore.$content)
              .font(.system(size: 20))

            if viewStore.content.isEmpty {
              Text("메모를 입력하세요.")
                .font(.system(size: 16))
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv250)).color)
                .padding(.top, 8)
                .padding(.leading, 5)
            }
          }
        }
        .padding(.horizontal, 30)
      }
    }
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}
