import Architecture
import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - TimerPage

struct TimerPage {

  init(store: StoreOf<TimerStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<TimerStore>
  @ObservedObject private var viewStore: ViewStoreOf<TimerStore>

}

extension TimerPage {
  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.timer.rawValue)
  }

  private var title: String {
    "타이머"
  }

  private var settingButtonDisabled: Bool {
    viewStore.hour == .zero
      && viewStore.minute == .zero
      && viewStore.second == .zero
  }

  private var settingButtonViewState: SettingButton.ViewState {
    .init()
  }
}

// MARK: View

extension TimerPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: title) {
        Divider()
          .background(DesignSystemColor.palette(.gray(.lv100)).color)

        HStack {
          Picker("Hours", selection: viewStore.$hour) {
            ForEach(0..<24) { hour in
              Text("\(hour)시간").tag(hour)
            }
          }

          Picker("Minutes", selection: viewStore.$minute) {
            ForEach(0..<60) { minute in
              Text("\(minute)분").tag(minute)
            }
          }

          Picker("Seconds", selection: viewStore.$second) {
            ForEach(0..<60) { second in
              Text("\(second)초").tag(second)
            }
          }
        }

        .pickerStyle(WheelPickerStyle())

        Divider()
          .background(DesignSystemColor.palette(.gray(.lv100)).color)

        SettingButton(
          viewState: settingButtonViewState,
          tapAction: { viewStore.send(.routeToDetail) })

//          Button(action: {
//            viewStore.send(.routeToDetail)
//          }) {
//            Text("설정하기")
//              .font(.system(size: 18, weight: .medium))
//              .foregroundStyle(DesignSystemColor.label(.default).color)
//              .opacity(settingButtonDisabled ? 0.3 : 1)
//          }
//          .padding(.top, 20)
//          .disabled(settingButtonDisabled)
      }
      .scrollDisabled(true)
      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}
