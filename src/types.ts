export type AccessControl =
  | 'UserPresence'
  | 'BiometryAny'
  | 'BiometryCurrentSet'
  | 'DevicePasscode'
  | 'ApplicationPassword'
  | 'BiometryAnyOrDevicePasscode'
  | 'BiometryCurrentSetOrDevicePasscode';

export type Accessible =
  | 'WhenUnlocked'
  | 'AfterFirstUnlock'
  | 'Always'
  | 'WhenPasscodeSetThisDeviceOnly'
  | 'WhenUnlockedThisDeviceOnly'
  | 'AfterFirstUnlockThisDeviceOnly';

export type AuthenticationType =
  | 'AuthenticationWithBiometricsDevicePasscode'
  | 'AuthenticationWithBiometrics';

export type StorageType =
  | 'FacebookConceal'
  | 'KeystoreAESCBC'
  | 'KeystoreRSAECB'
  | 'keychain'; // iOS only

export type SecurityLevel = 'software' | 'hardware' | 'any';

export type SecurityRules = 'none' | 'automaticUpgradeToMoreSecuredStorage';

export type AuthenticationPrompt = {
  title: string;
  subtitle: string;
  description: string;
  cancel: string;
};

export type Options = {
  accessControl: AccessControl;
  accessGroup: string;
  accessible: Accessible;
  authenticationPrompt: string | AuthenticationPrompt;
  authenticationType: AuthenticationType;
  service: string;
  securityLevel: SecurityLevel;
  storage: StorageType;
  rules: SecurityRules;
};

export type Result = {
  service: string;
  storage: string;
};

export interface UserCredentials extends Result {
  account: string;
  password: string;
}
