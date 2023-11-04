import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Architecture

struct SettingPage {
  
  init(store: StoreOf<SettingStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
  
  private let store: StoreOf<SettingStore>
  @ObservedObject private var viewStore: ViewStoreOf<SettingStore>
}

extension SettingPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.setting.rawValue)
  }
  
  private var title: String {
    "설정"
  }
}

extension SettingPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: title) {
        HStack {
          VStack(spacing: 10) {
            Text("To do")
              .font(.system(size: 14))
            
            Text("0")
              .font(.system(size: 30))
          }
          
          Spacer()
          
          VStack(spacing: 10) {
            Text("메모")
              .font(.system(size: 14))
            
            Text("0")
              .font(.system(size: 30))
          }
          
          Spacer()
          
          VStack(spacing: 10) {
            Text("음성메모")
              .font(.system(size: 14))
            
            Text("0")
              .font(.system(size: 30))
          }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 50)
        
        Divider()
          .background(DesignSystemColor.palette(.gray(.lv100)).color)
        
        VStack {
          HStack {
            Button(action: { viewStore.send(.onTapTodo) }) {
              Text("To do 리스트")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(DesignSystemColor.system(.black).color)
              
              Spacer()
              
              DesignSystemIcon.arrow.image
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv250)).color)
            }
          }
          .padding(.horizontal, 20)
          
          HStack {
            Button(action: { viewStore.send(.onTapMemo) }) {
              Text("메모")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(DesignSystemColor.system(.black).color)
              
              Spacer()
              
              DesignSystemIcon.arrow.image
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv250)).color)
            }
          }
          .padding(.horizontal, 20)
          
          HStack {
            Button(action: { viewStore.send(.onTapAudioMemo) }) {
              Text("음성메모")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(DesignSystemColor.system(.black).color)
              
              Spacer()
              
              DesignSystemIcon.arrow.image
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv250)).color)
            }
          }
          .padding(.horizontal, 20)
          
          HStack {
            Button(action: { viewStore.send(.onTapTimer) }) {
              Text("타이머")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(DesignSystemColor.system(.black).color)
              
              Spacer()
              
              DesignSystemIcon.arrow.image
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv250)).color)
            }
          }
          .padding(.horizontal, 20)
          
        }
        
        Divider()
          .background(DesignSystemColor.palette(.gray(.lv100)).color)
        
      }
      TabNavigationComponent(
        viewState: tabNavigationComponeentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
    }
    .navigationTitle("")
    .navigationBarHidden(true)
    
  }
}
