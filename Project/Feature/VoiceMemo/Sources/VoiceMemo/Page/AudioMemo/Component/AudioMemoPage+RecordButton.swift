import DesignSystem
import SwiftUI
import AVFoundation

struct RecordButton {
  let viewState: ViewState
  let tapAction: (Bool) -> Void
//  let permissionDeniedAction: () -> Void  // 권한을 동의 하지 않았을때 액션
  
  @State private var isShowAlert = false
}

extension RecordButton {
  
  private func requestPermission() async -> Bool {
    switch AVAudioApplication.shared.recordPermission {
    case .undetermined:
      /// - Note: 권한 요청이 아직 결정되지 않은 경우
      return await AVAudioApplication.requestRecordPermission()

    case .denied:
      /// -  Note: 이미 권한을 거부한 경우
      return false
      
    case .granted:
      /// - Note: 이미 권한을 받은 경우
      return true
      
    @unknown default:
      // 알수 없는 케이스 처리, 권한 취급 안해~
      return false
    }
  }
  
  private var pleaseAllowMessage: String {
    """
    현재 권한이 비활성화 되어있습니다. 권환을 활성화 시키시고 다시 눌러시주실 바랍니다.
    """
  }
}

extension RecordButton: View {
  var body: some View {
    Button(action: {
      Task {
        switch await requestPermission() {
        case true:
          tapAction(viewState.isRecording)
        case false:
          isShowAlert = true
        }
      }
      
    }) {
      Circle()
        .fill(viewState.isRecording ? .red : .green)
        .frame(width: 50, height: 50)
        .padding(.trailing, 30)
        .padding(.bottom, 40)
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

extension RecordButton {
  struct ViewState: Equatable {
    let isRecording: Bool
  }
}
