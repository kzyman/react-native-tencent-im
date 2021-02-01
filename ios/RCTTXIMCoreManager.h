#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <ImSDK/ImSDK.h>
@interface RCTTXIMCoreManager : NSObject
/**
 * 获取单例
 **/
+ (instancetype)sharedInstance;
- (void) initEngine: (int)sdkAppId delegate:(id)delegate;
- (void) joinChannel: (NSString *)classId userId:(NSString *)userId userSig:(NSString *)userSig;
- (void) unInitEngine;
- (void) leaveChannel;
- (void) sendMessage: (NSString *)message callback:(RCTResponseSenderBlock)callback;
@end
