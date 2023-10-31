import Foundation

extension Link {
  public enum VoiceMemo { }
}

extension Link.VoiceMemo {
  public enum Path: String, Equatable {
    case landing
    case audioMemo
    case todo
    case todoEditor
    case memo
    case timer
    case setting
  }
}
