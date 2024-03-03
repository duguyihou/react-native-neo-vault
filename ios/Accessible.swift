enum Accessible: String {
  case WhenUnlocked
  case AfterFirstUnlock
  case Always
  case WhenPasscodeSetThisDeviceOnly
  case WhenUnlockedThisDeviceOnly
  case AfterFirstUnlockThisDeviceOnly

  var value: CFString {
    switch self {
    case .WhenUnlocked:
      return kSecAttrAccessibleWhenUnlocked
    case .AfterFirstUnlock:
      return kSecAttrAccessibleAfterFirstUnlock
    case .Always:
      return kSecAttrAccessibleAlways
    case .WhenPasscodeSetThisDeviceOnly:
      return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
    case .WhenUnlockedThisDeviceOnly:
      return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    case .AfterFirstUnlockThisDeviceOnly:
      return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    }
  }
}
