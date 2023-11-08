import Foundation

public struct TodoEntity {
  public let list: [Item]
  
  public init(list: [Item]) {
    self.list = list
  }
  
}

extension TodoEntity {
  public struct Item: Codable, Equatable, Identifiable {
    
    public let isChecked: Bool
    public let title: String?
    public let date: Double
    
    public init(isChecked: Bool, title: String?, date: Double) {
      self.isChecked = isChecked
      self.title = title
      self.date = date
    }
    
    public var id: Double {
      date
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.id < rhs.id
    }
  }
}
