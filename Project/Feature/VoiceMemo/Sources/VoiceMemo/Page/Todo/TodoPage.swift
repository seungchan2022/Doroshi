import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Architecture

struct TodoPage {
  
  init(store: StoreOf<TodoStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
  
  private let store: StoreOf<TodoStore>
  @ObservedObject private var viewStore: ViewStoreOf<TodoStore>
}

extension TodoPage {
  private var tabNavigationComponeentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.VoiceMemo.Path.todo.rawValue)
  }
  
  private var title: String {
    """
    To do list를
    추가해 보세요.
    """
  }
}

extension TodoPage: View {
  var body: some View {
    VStack {
      
      VStack {
        if !viewStore.fetchTodoList.isEmpty {
          DesignSystemNavigation(
            barItem: .init(
              moreActionList: [
                .init(title: "삭제", action: { }),
              ]),
            title: "To do list \(viewStore.fetchTodoList.count)개가\n있습니다.")
          {
            VStack(alignment: .leading) {
              Text("할일 목록")
                .font(.system(size: 16, weight: .bold))
              
              Divider()
                .background(DesignSystemColor.palette(.gray(.lv100)).color)
              
              
              ForEach(viewStore.fetchTodoList) { item in
                HStack {
                  Button(action: {  }) {
                    DesignSystemIcon.unChecked.image
                      .resizable()
                      .frame(width: 25, height: 25)
                      .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
                  }
                  
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
                  
                  
                  Button(action: { viewStore.send(.onTapDelete(item))
                    print("tapped")}) {
                    Text("삭제")
                  }
                }
                .frame(minHeight: 50)
                .frame(maxWidth: .infinity)
                
                // 수정하기 수정
                .onTapGesture {
                  viewStore.send(.editTodo(item))
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
              Text("\"매일 아침 8시 운동가라고 알려줘\"")
              Text("\"내일 8시 수강신청하라고 알려줘\"")
              Text("\"1시 반 점심약속 리마인드 해줘\"")
            }
            .foregroundStyle(DesignSystemColor.palette(.gray(.lv400)).color)
            
          }
        }
      }
      
      .overlay(alignment: .bottomTrailing) {
        Button(action: { viewStore.send(.onTapTodoEditor) }) {
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
      
      Spacer()
      
      TabNavigationComponent(
        viewState: tabNavigationComponeentViewState,
        tapAction: { viewStore.send(.routeToTabBarItem($0)) })
      
    }
    
    .navigationTitle("")
    .navigationBarHidden(true)
    .onAppear {
      viewStore.send(.getTotoList)
    }
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
