import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - TimerDetailPage

struct TimerDetailPage {

  init(store: StoreOf<TimerDetailStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<TimerDetailStore>
  @ObservedObject private var viewStore: ViewStoreOf<TimerDetailStore>
  
  @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

extension TimerDetailPage { 
  private var isTimerZero: Bool {
    viewStore.hour == .zero
    && viewStore.minute == .zero
    && viewStore.second == .zero
  }
}

// MARK: View

extension TimerDetailPage: View {
  var body: some View {
    VStack {
      Text("TimerDetail")
      
      HStack {
        Button(action: {}) {
          Text("취소")
        }
        
        Spacer()
        
        switch viewStore.isPause {
        case true:
          Button(action: { start() }) {
            Text("재개")
          }

        case false:
          Button(action: { pause() }) {
            Text("일시정지")
          }

        }
      }
    }
    .onReceive(timer, perform: { _ in
      guard !isTimerZero else { return }
      viewStore.send(.onPullTimer)
    })
    .onAppear {
      start()
    }
    .onDisappear {
      pause()
      viewStore.send(.teardown)
    }
    
  }
  
  func pause() {
    timer.upstream.connect().cancel()
    viewStore.send(.set(\.$isPause, true))
  }
  
  func start() {
    pause()
    self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    viewStore.send(.set(\.$isPause, false))
  }
}
