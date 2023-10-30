import Foundation

extension Link {
  public enum VoiceMemo { }
}

extension Link.VoiceMemo {
  public enum Path: String, Equatable {
    case landing
    case todo
    case memo
    case audioMemo
    case timer
    case setting
  }
}
