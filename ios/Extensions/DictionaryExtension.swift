
extension Dictionary where Key == String {
  func append(_ accessGroup: String?) -> [String: Any] {
    guard let accessGroup = accessGroup else { return self }
    var result = self
    result[kSecAttrAccessGroup as String] = accessGroup as? Value
    return result
  }

  func append(_ synchronizable: Bool, IsAddItems: Bool) -> [String: Any] {
    if !synchronizable { return self }
    var result = self
    let key = IsAddItems == true ? true as! CFString : kSecAttrSynchronizableAny
    result[kSecAttrSynchronizable as String] = key as? Value
    return result
  }
}
