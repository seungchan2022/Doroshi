import SwiftUI

public struct TabNavigationComponent {
  let viewState: ViewState
  let tapAction: (String) -> Void
  
  public init(viewState: ViewState, tapAction: @escaping (String) -> Void) {
    self.viewState = viewState
    self.tapAction = tapAction
  }
}

extension TabNavigationComponent: View {
  public var body: some View {
    HStack(spacing: .zero) {
      ForEach(viewState.itemList) { item in
        Button(action: { tapAction(item.matchPath) }) {
          item.icon.image
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(
              item.matchPath == "audioMemo"
              ? LinearGradient.gradientButtonColor(item.isActive)
              : LinearGradient.defaultButtonColor(item.isActive))
        }
        if viewState.itemList.last != item {
          Spacer()
        }
      }
    }
    .padding(.horizontal, 16)
    .background(
    Rectangle()
      .fill(DesignSystemColor.system(.white).color)
      .shadow(color: .black.opacity(0.2), radius: 10, x: 0.0, y: -1)
      
    )
  }
}

extension TabNavigationComponent {
  public struct ViewState: Equatable {
    let activeMatchPath: String
    fileprivate let itemList: [ItemComponent]
    
    public init(activeMatchPath: String) {
      self.activeMatchPath = activeMatchPath
      self.itemList = [
        .init(
          matchPath: "todo",
          activeMatchPath: activeMatchPath,
          icon: .todo),
        .init(
          matchPath: "memo",
          activeMatchPath: activeMatchPath,
          icon: .memo),
        .init(
          matchPath: "audioMemo",
          activeMatchPath: activeMatchPath,
          icon: .mic),
        .init(
          matchPath: "timer",
          activeMatchPath: activeMatchPath,
          icon: .timer),
        .init(
          matchPath: "setting",
          activeMatchPath: activeMatchPath,
          icon: .setting),
      ]
    }
  }
}

fileprivate struct ItemComponent: Equatable, Identifiable {
  let matchPath: String // 각 tab의 matchPath
  let activeMatchPath: String // 그 tab이 활성화된 탭을 식별 하기 위해
  let icon: DesignSystemIcon
  
  var isActive: Bool {
    matchPath == activeMatchPath
  }
  
  var id: String { matchPath }
}

extension LinearGradient {
  fileprivate static var defaultButtonColor: (Bool) -> LinearGradient {
    { isActive in
      var color: [Color] {
        isActive == true
        ? [DesignSystemColor.palette(.gray(.lv400)).color]
           : [DesignSystemColor.palette(.gray(.lv200)).color]
      }
      return LinearGradient(colors: color, startPoint: .bottom, endPoint: .top)
    }
  }
  
  fileprivate static var gradientButtonColor: (Bool) -> LinearGradient {
    { isActive in
      var color: [Color] {
        isActive == true
        ? [DesignSystemColor.label(.gradient100).color, DesignSystemColor.label(.gradient200).color]
           : [DesignSystemColor.palette(.gray(.lv200)).color]
      }
      return linearGradient(colors: color, startPoint: .bottom, endPoint: .top)
    }
  }
}

#Preview {
  VStack {
    Spacer()
    TabNavigationComponent(
      viewState: .init(activeMatchPath: "audioMemo"),
      tapAction: { _ in })
  }
  .background(.red)
}
