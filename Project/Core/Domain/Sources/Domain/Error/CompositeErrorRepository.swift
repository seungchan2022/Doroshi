import Foundation

public enum CompositeErrorRepository: Error {

  public var message: String {
    return ""
  }

}

extension CompositeErrorRepository: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.message == rhs.message
  }
}
