import Foundation

public struct MemoClient<T: Codable> {
  
  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  let userDefault = UserDefaults.standard
  let defaultValue: T
  let key: String
  
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
}
