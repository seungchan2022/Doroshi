import Foundation

public protocol SettingUseCase {
  var getTodoList: () -> [TodoEntity.Item] { get }
  var getMemoList: () -> [MemoEntity.Item] { get }
}
