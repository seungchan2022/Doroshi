import Foundation

// MARK: - Link.VoiceMemo

extension Link {
  public enum VoiceMemo { }
}

// MARK: - Link.VoiceMemo.Path

extension Link.VoiceMemo {
  public enum Path: String, Equatable {
    case landing
    case audioMemo
    case todo
    case todoEditor
    case memo
    case memoEditor
    case timer
    case timerDetail
    case setting
  }
}
