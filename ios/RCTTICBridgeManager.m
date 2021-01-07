#import "RCTTICBridgeManager.h"
#import <UIKit/UIKit.h>
#import <React/RCTConvert.h>

#import <MapKit/MapKit.h>
#import <React/RCTLog.h>

// 这里专门抛出给RN进行调用的接口
#import "RCTTICCoreManager.h"
@implementation RCTTICBridgeManager
RCT_EXPORT_MODULE();
typedef UInt32 uint32;

RCT_EXPORT_METHOD(initEngine:(int)sdkAppId resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 初始化引擎,初始化单例
  [[RCTTICCoreManager sharedInstance] initEngine: sdkAppId delegate:self];
  resolve(@"1");
//  RCTLogInfo(@"sdkAppId: %d", sdkAppId);
}

RCT_EXPORT_METHOD(joinChannel:(NSString *)classId userId:(NSString *)userId userSig:(NSString *)userSig resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 加入到频道里面
  [[RCTTICCoreManager sharedInstance] joinChannel: classId userId:userId userSig:userSig];
  resolve(@"1");

}

// 方法调用
RCT_EXPORT_METHOD(callMethod:
                  (NSString *) methodName params:(NSDictionary *) params resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 方法调用
//  [RCTTICCoreManager sharedInstance];
  [[RCTTICCoreManager sharedInstance] callMethod: methodName params:params];
  resolve(@"1");
  
}
// 解散整个组
RCT_EXPORT_METHOD(dismissGroup:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
//  [RCTTICCoreManager sharedInstance];
  
  [[RCTTICCoreManager sharedInstance] dismissGroup];
  resolve(@"1");
}
// 注销引擎
RCT_EXPORT_METHOD(unInitEngine  :(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 方法调用
  
  [[RCTTICCoreManager sharedInstance] unInitEngine];
  resolve(@"1");
}
#pragma mark - listener
- (NSArray<NSString *> *)supportedEvents
{
  return @[@"BorderviewReady", @"JoinChannelSuccess", @"JoinChannelError"];
}

- (void)viewReady
{
  [self sendEventWithName:@"BorderviewReady" body:@{}];
}
- (void)JoinChannelCallbac: (NSString *) sendName
{
  RCTLogInfo(@"加入频道的状态回调 %@", sendName);
  [self sendEventWithName:sendName body:@{}];
}
@end
