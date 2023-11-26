import DesignSystem
import SwiftUI
import UserNotifications

struct SettingButton {
  let viewState: ViewState
  let tapAction: () -> Void
  
  @State private var isShowAlert = false
}

extension SettingButton {
  
  /// 알림 권한을 비동기적으로 확인하고 요청하는 메서드
  private func checkNotificationAuthorization() async -> Bool {
    let current = UNUserNotificationCenter.current()
    let settings = await current.notificationSettings()
    
    switch settings.authorizationStatus {
    case .notDetermined:
      /// 권한이 아직 요청되지 않았으면 권한 요청
      return await requestAuthorizaion()
      
    case .authorized, .provisional:
      /// 권한이 이미 승인되었으며, true 반환
      return true
      
    default:
      /// 그 외의 경우 (거부됨, 제한됨 등) false 반환
      return false
    }
  }
 
  /// 사용자에게 알림 권한을 요청하는 비동기 메서드
  private func requestAuthorizaion() async -> Bool {
    await withCheckedContinuation { continuation in
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
        continuation.resume(returning: granted)
      }
    }
  }
  
  private var pleaseAllowMessage: String {
    """
    현재 권한이 비활성화 되어있습니다. 권환을 활성화 시키시고 다시 눌러시주실 바랍니다.
    """
  }
}

extension SettingButton: View {
  var body: some View {
    Button(action: {
      
      /// 비동기 작업을 시작하는 Task 블록
      Task {
        switch await checkNotificationAuthorization() {
        case true:
          tapAction()
        case false:
          isShowAlert = true
        }
      }
    }) {
      Text("설정하기")
        .font(.system(size: 18, weight: .medium))
        .foregroundStyle(DesignSystemColor.label(.default).color)
    }
    
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("안내"),
        message: Text(pleaseAllowMessage),
        primaryButton: .cancel(),
        secondaryButton: .default(Text("설정으로 이동"), action: {
          guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
             
             if UIApplication.shared.canOpenURL(settingURL) {
                 UIApplication.shared.open(settingURL)
             }
        })
      )
    }
    .onDisappear {
      isShowAlert = false
    }
  }
}

extension SettingButton {
  struct ViewState: Equatable {
  }
}
