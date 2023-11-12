import Architecture
import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - TodoEditorPage

struct TodoEditorPage {

  init(store: StoreOf<TodoEditorStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<TodoEditorStore>
  @ObservedObject private var viewStore: ViewStoreOf<TodoEditorStore>
}

extension TodoEditorPage {
  private var title: String {
    switch viewStore.mode {
    case .create:
      """
        To do list를
        추가해 보세요.
      """

    case .edit:
      """
        To do list를
        변경해 보세요.
      """
    }
  }

  private var updateButtonTitle: String {
    switch viewStore.mode {
    case .create:
      "생성"
    case .edit:
      "완료"
    }
  }

  private var disPlayDate: String {
    guard !viewStore.date.isDateToday else { return "오늘" }
    return viewStore.date.displayFormat
  }
}

// MARK: View

extension TodoEditorPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(
          backAction: { viewStore.send(.onTapBack) },
          moreActionList: [
            .init(title: updateButtonTitle, action: { viewStore.send(.onTapUpdateDone) }),
          ]),
        title: title)
      {
        VStack(alignment: .leading, spacing: 16) {
          TextField("", text: viewStore.$title, prompt: .init("제목을  입력해주세요"))

          Divider()
            .background(DesignSystemColor.palette(.gray(.lv100)).color)

          DatePicker("", selection: viewStore.$date, displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())

          Divider()
            .background(DesignSystemColor.palette(.gray(.lv100)).color)

          VStack(alignment: .leading, spacing: 8) {
            Text("날짜")
              .font(.system(size: 16, weight: .medium))
              .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
            Button(action: { viewStore.send(.onTapDateSheet) }) {
              Text(disPlayDate)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(DesignSystemColor.label(.default).color)
            }
          }
        }
        .padding(.horizontal, 30)
      }
      .scrollDisabled(true)
    }
    .sheet(
      unwrapping: viewStore.$route,
      case: /TodoEditorStore.Route.datePickerSheet,
      onDismiss: { viewStore.send(.onRouteClear) },
      content: { dateBinder in
        VStack {
          Spacer()
          DatePicker(
            "",
            selection: .init(
              get: { dateBinder.wrappedValue },
              set: {
                viewStore.send(.onChangeDate($0))
                viewStore.send(.onRouteClear)
              }),
            displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
          Spacer()
        }
      })

    .navigationTitle("")
    .navigationBarHidden(true)
  }
}

extension Date {
  fileprivate var displayFormat: String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "M월 d일 EEEE"

    return dateFormatter.string(from: self)
  }

  fileprivate var isDateToday: Bool {
    Calendar.current.isDateInToday(self)
  }
}
