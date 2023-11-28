import Foundation
import SwiftUI
import DesignSystem

extension AudioMemoPage {
  struct RecordItem {
    let viewState: ViewState
    let swipeAction: (String?) -> Void
    let playingAction: (Bool) -> Void
    let deleteAction: (String) -> Void
    
    private let distance: CGFloat = 30
  }
}

extension AudioMemoPage.RecordItem { }

extension AudioMemoPage.RecordItem: View {
  var body: some View {
    ZStack {
      Rectangle()
        .fill(.red)
        .overlay(alignment: .trailing) {
          Button(action: { deleteAction(viewState.id) }) {
            DesignSystemIcon.delete.image
              .resizable()
          }
          .frame(width: 30, height: 30)
          .padding(.horizontal, 16)
          .tint(.white)
        }
      
      Text(viewState.id)
        .opacity(viewState.isPlaying ? 0.2 : 1)
        .onTapGesture {
          swipeAction(.none)
          playingAction(viewState.isPlaying)
        }
        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(DesignSystemColor.system(.white).color)
        .offset(x: viewState.isEdit ? -64 : .zero)
        .animation(.interactiveSpring(), value: viewState.isEdit)
        .gesture(
          DragGesture()
            .onChanged { value in
              guard let direction = value.translation.width.conver(distance: distance) else { return }
              switch direction {
              case .hiding: swipeAction(.none)
              case .showing: swipeAction(viewState.id)
              }
            }
        )
      
    }
    .overlay(alignment: .bottom, content: {
      if !viewState.isLastItem {
        Divider()
          .background(DesignSystemColor.palette(.gray(.lv100)).color)
          .padding(.leading, 16)
      }
      
    })
    .frame(maxWidth: .infinity)
  }
}

extension AudioMemoPage.RecordItem {
  struct ViewState: Equatable, Identifiable {
    let id: String
    let isPlaying: Bool
    let isLastItem: Bool
    let isEdit: Bool
  }
  
  fileprivate enum Direction: Equatable {
    case showing
    case hiding
  }
}

extension CGFloat {
  fileprivate func conver(distance: CGFloat) -> AudioMemoPage.RecordItem.Direction? {
    if self > distance { return .hiding }
    else if self < -distance { return .showing }
    else { return .none }
  }
}
