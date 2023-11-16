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
  
  @State private var isSettedTimer = false
  @State private var timer: Timer?
  @State private var passedTime = 0
  @State private var hour = 0
  @State private var minute = 0
  @State private var second = 0
  @State private var isPaused = false
  
  
}

extension TimerPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.timer.rawValue)
  }
  
  private var title: String {
    "타이머"
  }
  
  private var settedTime: Int {
    (hour * 3600) + (minute * 60) + second
  }
  
  private var remainingTime: Int {
    ((hour * 3600) + (minute * 60) + second) - passedTime
  }
}

// MARK: View

extension TimerPage: View {
  var body: some View {
    VStack {
      
      if !isSettedTimer {
        
        DesignSystemNavigation(title: title) {
          Divider()
            .background(DesignSystemColor.palette(.gray(.lv100)).color)
          
          HStack {
            Picker("Hours", selection: $hour) {
              ForEach(0..<24) { hour in
                Text("\(hour)시간").tag(hour)
              }
            }
            
            Picker("Minutes", selection: $minute) {
              ForEach(0..<60) { minute in
                Text("\(minute)분").tag(minute)
              }
            }
            
            Picker("Seconds", selection: $second) {
              ForEach(0..<60) { second in
                Text("\(second)초").tag(second)
              }
            }
          }

          .pickerStyle(WheelPickerStyle())
          
          Divider()
            .background(DesignSystemColor.palette(.gray(.lv100)).color)
          
          Button(action: {
            isSettedTimer = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
              // 카운터를 감소시킵니다.
              if !isPaused {
                if passedTime < settedTime {
                  passedTime = passedTime + 1
                }
              }
            }
          }) {
            Text("설정하기")
              .font(.system(size: 18, weight: .medium))
              .foregroundStyle(DesignSystemColor.label(.default).color)
          }
          .padding(.top, 20)
        }
        .scrollDisabled(true)
      } else {
        DesignSystemNavigation(title: "") {
          VStack {
            ZStack {
              Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
              
              Circle()
                .trim(from: 0, to: CGFloat(min(1, Double(remainingTime) / Double(settedTime))))
                .stroke(
                  DesignSystemColor.tint(.default).color,
                  style: StrokeStyle(
                    lineWidth: 10,
                    lineCap: .round,
                    lineJoin: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: Double(remainingTime) / Double(settedTime))
            }
            .frame(width: 320, height: 320)
            .overlay {
              VStack {
                HStack(spacing: 10) {
                  // 남은 시간
                  Text("\(remainingTime.formattedTimeString)")
                    .font(.system(size: 28))
                    .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
                }
                
                // 끝나는 시간
                HStack {
                  Image(systemName: "bell")
                    .frame(width: 36, height: 20)
                  
                  Text("\(settedTime.formattedSettingTime)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
                }
              }
            }
            
            HStack {
              
              Circle()
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv250)).color.opacity(0.3))
                .frame(width: 70, height: 70)
                .overlay {
                  Button(action: {
                    isSettedTimer = false
                    timer?.invalidate()
                    timer = .none
                    
                    /// 이거를 설정하지 않으면 이전 시간이 빼진 상태로 나타남
                    /// 예를 들어 3초가 지나고 취소 하고 다시 누르면 passeTime이 0초가 아닌 3초부터 시작함
                    passedTime = .zero
                    isPaused = false
                  }) {
                    Text("취소")
                      .font(.system(size: 14))
                      .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
                  }
                }
              
              Spacer()
              
              Circle()
                .fill(DesignSystemColor.tint(.default).color.opacity(0.3))
                .frame(width: 70, height: 70)
                .overlay {
                  Button(action: {
                    isPaused.toggle()
                  }) {
                    Text(isPaused ? "재개" : "일시정지")
                      .font(.system(size: 14))
                      .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
                  }
                }
            }
            .padding(.top, 30)
          }
          .padding(.top, 60)
          .padding(.horizontal, 30)
        }
      }
      
      TabNavigationComponent(
        viewState: tabNavigationComponeentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
    }
    
    .navigationTitle("")
    .navigationBarHidden(true)
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
