#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(GoogleNavigationSdk, NSObject)

RCT_EXTERN_METHOD(provideAPIKey:(NSString)apiKey
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

@end
