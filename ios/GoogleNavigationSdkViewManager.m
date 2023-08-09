#import <React/RCTViewManager.h>

@interface RCT_EXTERN_REMAP_MODULE(GoogleNavigationSdkView, GoogleNavigationSdkViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(color, reactColor, NSString)
RCT_REMAP_VIEW_PROPERTY(onEnableTakePicture, reactOnEnableTakePicture, RCTBubblingEventBlock)
RCT_REMAP_VIEW_PROPERTY(onImageCaptured, reactOnImageCaptured, RCTBubblingEventBlock)

RCT_EXTERN_METHOD(takePicture:(nonnull NSNumber *)reactTag)
//RCT_EXTERN_METHOD(testMethod
//                  : (NSNumber *)tag
//                  : NSString)


@end
