import Foundation

// MARK: - StorageClient

public struct StorageClient<T: Codable> {

  // MARK: Lifecycle

  init(type: DimensionType, defaultValue: T) {
    self.type = type
    self.defaultValue = defaultValue
  }

  // MARK: Internal

  let userDefault = UserDefaults.standard
  let defaultValue: T
  let type: DimensionType

  func getItem() -> T {
    guard
      let data = userDefault.object(forKey: key) as? Data,
      let retItem = try? JSONDecoder().decode(T.self, from: data)
    else {
      return savedItem(new: defaultValue)
    }

    return retItem
  }

  @discardableResult
  func savedItem(new: T) -> T {
    let data = try? JSONEncoder().encode(new)
    userDefault.set(data, forKey: key)
    return new
  }

  // MARK: Private

  private var key: String {
    type.rawValue
  }
}

// MARK: StorageClient.DimensionType

extension StorageClient {
  enum DimensionType: String, Equatable {
    case todo = "TodoList"
    case memo = "MemoList"
  }
}
