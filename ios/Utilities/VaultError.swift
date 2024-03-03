enum VaultError: LocalizedError {
  case getGenericPasswordFailure
  case deleteGenericPasswordFailure
  case getAllGenericPasswordsFailure
  case getAllServicesFailure
  
  var localizedDescription: String {
    switch self {
    case .getGenericPasswordFailure:
      return "\(VaultError.neoVaultError) Error retrieving generic password"
    case .deleteGenericPasswordFailure:
      return "\(VaultError.neoVaultError) Error deleting generic password"
    case .getAllGenericPasswordsFailure:
      return "\(VaultError.neoVaultError) Error retrieving all generic passwords"
    case .getAllServicesFailure:
      return "\(VaultError.neoVaultError) Error retrieving all services"
    }
  }
  
  private static var neoVaultError: String {
    return "[NeoVault Error]"
  }
  
}
