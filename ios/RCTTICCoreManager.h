#import <Foundation/Foundation.h>
#import <TEduBoard/TEduBoard.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <ImSDK/ImSDK.h>
@interface RCTTICCoreManager : NSObject
/**
 * 获取单例
 **/
+ (instancetype)sharedInstance;
- (void) initEngine: (int)sdkAppId delegate:(id)delegate;
- (void) joinChannel: (NSString *)classId userId:(NSString *)userId userSig:(NSString *)userSig;
- (TEduBoardController *) getBoardController;
- (void) callMethod: (NSString *) methodName params:(NSDictionary *) params;
- (void) unInitEngine;
- (void) dismissGroup;
@end
