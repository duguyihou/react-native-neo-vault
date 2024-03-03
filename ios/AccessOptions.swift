import Security
@objc
enum AccessOptions: Int, RawRepresentable {

  case accessibleWhenUnlocked
  case accessibleWhenUnlockedThisDeviceOnly
  case accessibleAfterFirstUnlock
  case accessibleAfterFirstUnlockThisDeviceOnly
  case accessibleWhenPasscodeSetThisDeviceOnly

  static var defaultOption: AccessOptions {
    return .accessibleWhenUnlocked
  }

  var value: String {
    switch self {
    case .accessibleWhenUnlocked:
      return kSecAttrAccessibleWhenUnlocked as String

    case .accessibleWhenUnlockedThisDeviceOnly:
      return kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String

    case .accessibleAfterFirstUnlock:
      return kSecAttrAccessibleAfterFirstUnlock as String

    case .accessibleAfterFirstUnlockThisDeviceOnly:
      return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String

    case .accessibleWhenPasscodeSetThisDeviceOnly:
      return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String
    }
  }
}
