import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Architecture

// MARK: - TimerDetailPage

struct TimerDetailPage {
  
  init(store: StoreOf<TimerDetailStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
  
  private let store: StoreOf<TimerDetailStore>
  @ObservedObject private var viewStore: ViewStoreOf<TimerDetailStore>
  
  @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @State private var counter: Int = .zero
}

extension TimerDetailPage {
  /// 로컬 알림을 스케줄링하는 메서드
  private func scheduleNotfication() {
    print("Scheduling notification")

    let content = UNMutableNotificationContent()
    content.title = "타이머 종료!"
    content.subtitle = "설정한 타이머가 종료되었습니다."
    content.sound = .default
    
    /// 알림이 발생하도록 트리거 설정
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
    
    /// 알림 요청 생성
    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: content,
      trigger: trigger)
    
    /// 알림 센터에 알림 요청 추가
    UNUserNotificationCenter.current().add(request)
  }
  
  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.timer.rawValue)
  }
  
  private var title: String {
    ""
  }
  
  private var isTimerZero: Bool {
    viewStore.hour == .zero
    && viewStore.minute == .zero
    && viewStore.second == .zero
  }
  
  private var settedTime: Int {
    (viewStore.hour * 3600) + (viewStore.minute * 60) + viewStore.second
  }
  
  private var settingButtonDisabled: Bool {
    (settedTime - counter) == 0
  }
  
  private var remainingTime: Int {
    (settedTime - counter)
  }
}

// MARK: View

extension TimerDetailPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: title) {
        
        VStack {
          
          ZStack {
            Circle()
              .stroke(lineWidth: 6)
              .opacity(0.3)
            
            Circle()
              .trim(from: 0, to: CGFloat(min(1, Double(remainingTime) / Double(settedTime))))
              .trim(from: 0, to: 1)
              .stroke(
                DesignSystemColor.tint(.default).color,
                style: StrokeStyle(
                  lineWidth: 6,
                  lineCap: .round,
                  lineJoin: .round))
              .rotationEffect(.degrees(-90))
              .animation(.linear(duration: 1), value: Double(remainingTime) / Double(settedTime))
          }
          .frame(width: 320, height: 320)
          .overlay {
            VStack {
              Text("\(remainingTime.formattedTimeString)")
                .font(.system(size: 28))
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
              
              HStack(spacing: .zero) {
                DesignSystemIcon.bell.image
                  .frame(width: 36, height: 20)
                
                Text("\(settedTime.formattedSettingTime)")
                  .font(.system(size: 16, weight: .medium))
              }
              .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
            }
          }
          
          HStack {
            Button(action: {
              pause()
              viewStore.send(.onTapback)
              
            }) {
              Circle()
                .fill(DesignSystemColor.palette(.gray(.lv250)).color.opacity(0.3))
                .frame(width: 70, height: 70)
                .overlay {
                  Text("취소")
                    .font(.system(size: 14))
                    .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
                }
            }
            
            Spacer()
            
            switch viewStore.isPause {
            case true:
              Button(action: { start() }) {
                
                Circle()
                  .fill(DesignSystemColor.tint(.default).color.opacity(0.3))
                  .frame(width: 70, height: 70)
                  .overlay {
                    Text("재개")
                      .font(.system(size: 14))
                      .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
                  }
              }
              .disabled(settingButtonDisabled)
              
            case false:
              Button(action: { pause() }) {
                Circle()
                  .fill(DesignSystemColor.tint(.default).color.opacity(0.3))
                  .frame(width: 70, height: 70)
                  .overlay {
                    Text("일시정지")
                      .font(.system(size: 14))
                      .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
                    
                  }
                
              }
              .disabled(settingButtonDisabled)
              
            }
          }
          .padding(.top, 30)
        }
        .padding(.top, 60)
        .padding(.horizontal, 20)
        .onReceive(timer, perform: { _ in
          guard !isTimerZero else {          
//            pause()
//            scheduleNotfication()
            return }
         
          viewStore.send(.onPullTimer)
          counter = counter + 1
          print("\(remainingTime)")
          if counter == settedTime {
            pause()
            scheduleNotfication()
          }
        })
        
        .onAppear {
          start()
        }
        .onDisappear {
          pause()
          viewStore.send(.teardown)
        }
      }
      
      
      
      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0))})
    }
    .ignoresSafeArea(.all, edges: .bottom)
    
    
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

extension Int {
  
  // 00 : 00 : 00 => 얼마나 남았는지
  fileprivate var formattedTimeString: String {
    let hour = self / 3600
    let minute = (self % 3600) / 60
    let second = self % 60
    
    let hourString = String(format: "%02d", hour)
    let minuteString = String(format: "%02d", minute)
    let secondString = String(format: "%02d", second)
    
    return "\(hourString)  :  \(minuteString)  :  \(secondString)"
  }
  
  // 원래 시간 + 내가 설정한 시간
  fileprivate var formattedSettingTime: String {
    let currentDate = Date()
    let settingDate = currentDate.addingTimeInterval(TimeInterval(self))
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "HH:mm"
    
    let formattedTime = formatter.string(from: settingDate)
    return formattedTime
  }
}
