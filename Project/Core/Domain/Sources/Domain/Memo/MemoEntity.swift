import Foundation

// MARK: - MemoEntity

public struct MemoEntity {
  public let list: [Item]

  public init(list: [Item]) {
    self.list = list
  }
}

// MARK: MemoEntity.Item

extension MemoEntity {
  public struct Item: Codable, Equatable, Identifiable {

    // MARK: Lifecycle

    public init(
      isChecked: Bool?,
      title: String?,
      date: Double,
      content: String?)
    {
      self.isChecked = isChecked
      self.title = title
      self.date = date
      self.content = content
    }

    // MARK: Public

    public let isChecked: Bool?
    public let title: String?
    public let date: Double
    public let content: String?

    public var id: Double {
      date
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.id < rhs.id
    }
  }
}
