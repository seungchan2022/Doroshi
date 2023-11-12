import Foundation

// MARK: - CompositeErrorRepository

public enum CompositeErrorRepository: Error {

  public var message: String {
    ""
  }

}

// MARK: Equatable

extension CompositeErrorRepository: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.message == rhs.message
  }
}
