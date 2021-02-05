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
- (void) login: (NSString *)userId userName:(NSString *)userName userSig:(NSString *)userSig;
- (void) joinChannel: (NSString *)classId userId:(NSString *)userId userName:(NSString *)userName userSig:(NSString *)userSig;
- (void) unInitEngine;
- (void) leaveChannel;
- (void) logout;
- (void) getGroupMemberList:(NSString *)classId callback:(RCTResponseSenderBlock)callback;
- (void) sendMessage: (NSString *)message callback:(RCTResponseSenderBlock)callback;
- (void) setSelfInfo: (NSString *)nickName callback:(RCTResponseSenderBlock)callback;
@end
