enum AccessControl: String, CaseIterable {
  case UserPresence
  case BiometryAny
  case BiometryCurrentSet
  case DevicePasscode
  case ApplicationPassword
  case BiometryAnyOrDevicePasscode
  case BiometryCurrentSetOrDevicePasscode

  var value: SecAccessControlCreateFlags {
    switch self {
    case .UserPresence:
      return .userPresence
    case .BiometryAny:
      return .biometryAny
    case .BiometryCurrentSet:
      return .biometryCurrentSet
    case .DevicePasscode:
      return .devicePasscode
    case .ApplicationPassword:
      return .applicationPassword
    case .BiometryAnyOrDevicePasscode:
      return SecAccessControlCreateFlags(arrayLiteral: [.biometryAny, .or, .devicePasscode])
    case .BiometryCurrentSetOrDevicePasscode:
      return SecAccessControlCreateFlags(arrayLiteral: [.biometryCurrentSet, .or, .devicePasscode])
    }
  }
}
