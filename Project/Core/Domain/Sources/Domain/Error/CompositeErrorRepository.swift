import Foundation

// MARK: - CompositeErrorRepository

public enum CompositeErrorRepository: Error {

  case notFoundFilePath
  case invalidTypeCast
  case other(Error)

  public var message: String {
    switch self {
    case .notFoundFilePath:
      return "notFoundFilePath"
    case .invalidTypeCast:
      return "invalidTypeCast"
    case .other(let error):
      return "\(error)"
    }
  }

}

// MARK: Equatable

extension CompositeErrorRepository: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.message == rhs.message
  }
}
