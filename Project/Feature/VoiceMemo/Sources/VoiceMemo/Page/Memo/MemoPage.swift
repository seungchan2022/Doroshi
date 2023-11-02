import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Architecture

struct MemoPage {

  init(store: StoreOf<MemoStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  private let store: StoreOf<MemoStore>
  @ObservedObject private var viewStore: ViewStoreOf<MemoStore>
}

extension MemoPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.memo.rawValue)
  }
  
  private var title: String {
    """
    메모를
    추가해보세요
    """
  }
}

extension MemoPage: View {
  var body: some View {
    VStack {
      VStack {
        if !viewStore.fetchMemoList.isEmpty {
          DesignSystemNavigation(
            barItem: .init(
              moreActionList: [
                .init(title: "삭제", action: {  }),
              ]),
            title: "메모 \(viewStore.fetchMemoList.count)개가\n있습니다.")
          {
            VStack(alignment: .leading) {
              Text("메모 목록")
                .font(.system(size: 16, weight: .bold))
              
              Divider()
                .background(DesignSystemColor.palette(.gray(.lv100)).color)
              
              ForEach(viewStore.fetchMemoList) { item in
                HStack {
                
                  
                  VStack(alignment: .leading, spacing: 4) {
                    
                    //                    if item.title != .none && ((item.title?.isEmpty) == nil) {
                    if let title = item.title, !title.isEmpty {
                      Text(item.title ?? "")
                        .font(.system(size: 16))
                    }
                    Text("\(Date(timeInterval: item.date).formattedDate)")
                      .font(.system(size: 12))
                      .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
                  }
                  
                  Spacer()
                  
                  Button(action: {  }) {
                    DesignSystemIcon.unChecked.image
                      .resizable()
                      .frame(width: 25, height: 25)
                      .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
                  }
                }
                .frame(minHeight: 60)
                .frame(maxWidth: .infinity)
//                .onTapGesture {
//                  viewStore.send(.editTodo(item))
//                }
                
                Divider()
                  .background(DesignSystemColor.palette(.gray(.lv100)).color)
              }
            }
            .padding(.horizontal, 30)
          }
        }
        else {
          DesignSystemNavigation(title: title) {
            
            DesignSystemIcon.pencil.image
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
              .padding(.top, 180)
            
            VStack(spacing: 8) {
              Text("\"퇴근 9시간 전 메모\"")
              Text("\"기획서 작성 후 퇴근하기 메모\"")
              Text("\"밀린 집안일 하기 메모\"")
            }
            .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
          }
      }
      }
      .overlay(alignment: .bottomTrailing) {
        Button(action: { viewStore.send(.onTapMemoEditor) }) {
          DesignSystemIcon.pencil.image
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundStyle(DesignSystemColor.system(.white).color)
            .padding(15)
            .background {
              Circle()
                .fill(DesignSystemColor.label(.default).color)
                .frame(width: 50, height: 50)
            }
        }
        .padding(.trailing, 30)
        .padding(.bottom, 40)
        
      }
      TabNavigationComponent(
        viewState: tabNavigationComponeentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
    }
    .onAppear {
      viewStore.send(.getMemoList)
    }
    .navigationTitle("")
    .navigationBarHidden(true)
    
  }
}

extension Date {
  fileprivate var formattedDate: String {
    if isDateToday {
      return "오늘 "
    } else {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "ko_KR")
      dateFormatter.dateFormat = "M월 d일 EEEE"
      return dateFormatter.string(from: self)
    }
  }
  
  fileprivate init(timeInterval: Double) {
    self.init(timeIntervalSince1970: timeInterval)
  }
  
  fileprivate var isDateToday: Bool {
    return Calendar.current.isDateInToday(self)
  }
}
