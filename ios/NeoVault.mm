#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NeoVault, NSObject)

RCT_EXTERN_METHOD(setGenericPassword:(NSString*)password
                  for:(NSString*)account
                  with:(NSDictionary*)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getGenericPassword:
                  (NSDictionary*)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(resetGenericPassword:
                  with (NSDictionary*)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getAllGenericPasswords:
                  (RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
