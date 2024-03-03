import Security
import LocalAuthentication

@objc(NeoVault)
class NeoVault: NSObject {

  private struct Constants {
    static var service = "service"
    static var storage = "storage"
    static var account = "account"
    static var password = "password"
    static var accessGroup = "accessGroup"
    static var accessible = "accessible"
    static var accessControl = "accessControl"
    static var authenticationPrompt = "authenticationPrompt"
  }

  private var bundleId: String {
    return Bundle.main.bundleIdentifier ?? ""
  }

  typealias Options = [String: String]
}

extension NeoVault {
  // MARK: - Set Generic Password
  @objc
  func setGenericPassword(_ password: String,
                          for account: String,
                          with options: Options,
                          resolve:RCTPromiseResolveBlock,
                          reject:RCTPromiseRejectBlock) {
    let service = options[Constants.service] ?? bundleId
    let attributes = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecValueData: password.data(using: .utf8)!
    ] as [CFString : Any]

    let _ =  deletePasswords(for: service)
    let osStatus = insertEntry(attributes, with: options)
    if osStatus == noErr {
      resolve([
        Constants.service: service,
        Constants.storage: "keychain"
      ])
    }
  }

  // MARK: - Get Generic Password
  @objc
  func getGenericPassword(_ options: Options,
                          resolve:RCTPromiseResolveBlock,
                          reject:RCTPromiseRejectBlock) {
    let service = options[Constants.service] ?? bundleId
    var authenticationPrompt: String?
    if let authentication = options[Constants.authenticationPrompt] as? [String: Any],
       authentication["title"] != nil {
      authenticationPrompt = authentication["title"] as? String
    }

    let query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecReturnAttributes: kCFBooleanTrue,
      kSecReturnData: kCFBooleanTrue,
      kSecMatchLimit: kSecMatchLimitOne,
      kSecUseOperationPrompt: authenticationPrompt
    ] as [CFString : Any]

    var typeRef: CFTypeRef?
    let osStatus = SecItemCopyMatching(query as CFDictionary, &typeRef)

    if osStatus != noErr && osStatus != errSecItemNotFound {
      let error = NSError(domain: NSOSStatusErrorDomain, code: Int(osStatus))
      reject("Error", VaultError.getGenericPasswordFailure.localizedDescription, error)
      return
    }
    var result = [
      Constants.storage: "keychain",
      Constants.service: service
    ]
    guard let found = typeRef as? [String: Any] else { return }
    let account = found[kSecAttrAccount as String] as? String
    let password = String(data: found[kSecValueData as String] as! Data, encoding: .utf8)
    result[Constants.account] = account
    result[Constants.password] = password

    resolve(result)
  }

  // MARK: - Reset Generic Password
  @objc
  func resetGenericPassword(with options: Options,
                            resolve:RCTPromiseResolveBlock,
                            reject:RCTPromiseRejectBlock) {
    let service = options[Constants.service] ?? bundleId
    let osStatus = deletePasswords(for: service)
    if osStatus != noErr && osStatus != errSecItemNotFound {
      let error = NSError(domain: NSOSStatusErrorDomain, code: Int(osStatus))
      reject("Error", VaultError.deleteGenericPasswordFailure.localizedDescription, error)
      return
    }
    resolve(true)
  }

  // MARK: - Get All Generic Passwords
  @objc
  func getAllGenericPasswords(_ resolve:RCTPromiseResolveBlock,
                              reject:RCTPromiseRejectBlock) {
    let secItemClasses = [kSecClassGenericPassword]
    do {
      let services = try getAllServices(for: secItemClasses)
      resolve(services)
    } catch let err {
      reject("Error", VaultError.getAllGenericPasswordsFailure.localizedDescription, err)
    }
  }
}

extension NeoVault {
  // MARK: - Delete passwords
  func deletePasswords(for service: String) -> OSStatus {
    let query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecReturnAttributes: kCFBooleanTrue!,
      kSecReturnData: kCFBooleanFalse!
    ] as CFDictionary
    return SecItemDelete(query)
  }

  // MARK: - Insert Entry
  func insertEntry(_ attributes: [CFString: Any],
                   with options: Options) -> OSStatus {
    var mAttributes = attributes
    mAttributes[kSecUseDataProtectionKeychain] = true

    if let accessGroup = options[Constants.accessGroup] {
      mAttributes[kSecAttrAccessGroup] = accessGroup
    }
    var accessible = kSecAttrAccessibleAfterFirstUnlock
    if let accessibleKey = options[Constants.accessible],
       let acc = Accessible(rawValue: accessibleKey)  {
      accessible = acc.value
    }

    if let type = options[Constants.accessControl],
       let accessControl = AccessControl(rawValue: type)?.value {
      var aerr: NSError?
      let canAuthenticate = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: &aerr)
      if (aerr != nil) || !canAuthenticate {
        return errSecWrPerm
      }

      var error: Unmanaged<CFError>?
      let accessControlRef = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessible, accessControl, &error)
      if error != nil {
        return errSecWrPerm
      }
      mAttributes[kSecAttrAccessControl] = accessControlRef
    } else {
      mAttributes[kSecAttrAccessible] = accessible
    }

    return SecItemAdd(mAttributes as CFDictionary, nil)
  }

  // MARK: - Get All Services
  func getAllServices(for securityClasses: [CFString]) throws -> [String]? {
    var query = [
      kSecReturnAttributes: kCFBooleanTrue,
      kSecMatchLimit: kSecMatchLimitAll
    ] as [String: Any]
    var services: [String]?
    try? securityClasses.forEach { secItemClass in
      query[kSecClass as String] = secItemClass
      var resultRef: CFTypeRef?
      let osStatus = SecItemCopyMatching(query as CFDictionary, &resultRef)

      if osStatus != noErr && osStatus != errSecItemNotFound {
        let error = NSError(domain: NSOSStatusErrorDomain, code: Int(osStatus))
        throw error
      } else if osStatus != errSecItemNotFound {
        if let result = resultRef as? [[String: Any]] {
          result.forEach { entry in
            if let service = entry[kSecAttrService as String] as? String {
              services?.append(service)
            }
          }
        }

      }
    }
    return services
  }
}


