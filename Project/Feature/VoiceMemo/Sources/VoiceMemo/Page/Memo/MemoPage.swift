import Architecture
import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - MemoPage

struct MemoPage {
  
  init(store: StoreOf<MemoStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
  
  private let store: StoreOf<MemoStore>
  @ObservedObject private var viewStore: ViewStoreOf<MemoStore>
}

extension MemoPage {
  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.memo.rawValue)
  }
  
  private var title: String {
    """
    메모를
    추가해보세요
    """
  }
}

// MARK: View

extension MemoPage: View {
  var body: some View {
    VStack {
      VStack {
        if !viewStore.fetchMemoList.isEmpty {
          DesignSystemNavigation(
            barItem: .init(
              moreActionList: [
                .init(
                  title: viewStore.isEditing ? "완료" : "편집",
                  action: { viewStore.send(.onTapDeleteList(viewStore.fetchMemoList)) }),
              ]),
            title: "메모 \(viewStore.fetchMemoList.count)개가\n있습니다.")
          {
            // MARK: - 콘텐츠 뷰
            VStack(alignment: .leading) {
              Text("메모 목록")
                .font(.system(size: 16, weight: .bold))
              
              Divider()
                .background(DesignSystemColor.palette(.gray(.lv100)).color)
              
              ForEach(viewStore.fetchMemoList) { item in
                HStack {
                  VStack(alignment: .leading, spacing: 4) {
                    if let title = item.title, !title.isEmpty {
                      Text(item.title ?? "")
                        .font(.system(size: 16))
                    }
                    Text("\(Date(timeInterval: item.date).formattedDate)")
                      .font(.system(size: 12))
                      .foregroundStyle(DesignSystemColor.palette(.gray(.lv200)).color)
                  }
                  
                  Spacer()
                  
                  if viewStore.isEditing {
                    // 편집 모드일 때 각 항목 옆에 체크박스 표시
                    Button(action: { viewStore.send(.onTapDeleteTarget(item)) }) {
                      (item.isChecked ?? false ? DesignSystemIcon.checked : DesignSystemIcon.unChecked).image
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(DesignSystemColor.palette(.gray(.lv200)).color)
                    }
                  }
                }
                .frame(minHeight: 60)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                  viewStore.send(.onTapEdit(item))
                }
                
                Divider()
                  .background(DesignSystemColor.palette(.gray(.lv100)).color)
              }
            }
            .padding(.horizontal, 30)
          }
        } else {
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
        viewState: tabNavigationComponentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
    }
    .onAppear {
      viewStore.send(.getMemoList)
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}

extension Date {
  
  // MARK: Lifecycle
  
  fileprivate init(timeInterval: Double) {
    self.init(timeIntervalSince1970: timeInterval)
  }
  
  // MARK: Fileprivate
  
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
  
  // MARK: Private
  
  private var isDateToday: Bool {
    Calendar.current.isDateInToday(self)
  }
}
