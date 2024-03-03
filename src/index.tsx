import { NativeModules, Platform } from 'react-native';
import type { Options, Result, UserCredentials } from './types';

const LINKING_ERROR =
  `The package 'react-native-neo-vault' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const NeoVault = NativeModules.NeoVault
  ? NativeModules.NeoVault
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function setGenericPassword(
  password: string,
  account: string,
  options?: string | Partial<Options>
): Promise<false | Result> {
  const normalizedOption = (() => {
    if (typeof options === 'string') {
      return { service: options };
    }
    return options ?? {};
  })();
  return NeoVault.setGenericPassword(password, account, normalizedOption);
}

export function getGenericPassword(
  options?: string | Partial<Options>
): Promise<false | UserCredentials> {
  const normalizedOption = (() => {
    if (typeof options === 'string') {
      return { service: options };
    }
    return options ?? {};
  })();
  return NeoVault.getGenericPassword(normalizedOption);
}

export function resetGenericPassword(
  options?: string | Partial<Options>
): Promise<boolean> {
  const normalizedOption = (() => {
    if (typeof options === 'string') {
      return { service: options };
    }
    return options ?? {};
  })();
  return NeoVault.resetGenericPassword(normalizedOption);
}

export function getAllGenericPasswords(): Promise<string[]> {
  return NeoVault.getAllGenericPasswords();
}

export default NeoVault;
