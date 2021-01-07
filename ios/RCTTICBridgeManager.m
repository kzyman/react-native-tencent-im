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

RCT_EXPORT_METHOD(initEngine:(int)sdkAppId isCoach:(BOOL)isCoach resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 初始化引擎,初始化单例
  [[RCTTICCoreManager sharedInstance] initEngine: sdkAppId isCoach:isCoach delegate:self];
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
  [[RCTTICCoreManager sharedInstance] callMethod: methodName params:params resolve:resolve reject:reject];
}
// 解散整个组
RCT_EXPORT_METHOD(dismissGroup)
{
//  [RCTTICCoreManager sharedInstance];
  
  [[RCTTICCoreManager sharedInstance] dismissGroup];
}
// 注销引擎
RCT_EXPORT_METHOD(unInitEngine)
{
  // 方法调用
  
  [[RCTTICCoreManager sharedInstance] unInitEngine];
}
#pragma mark - listener
- (NSArray<NSString *> *)supportedEvents
{
  return @[@"BorderviewReady"];
}

- (void)viewReady
{
  RCTLogInfo(@"开始1");
  [self sendEventWithName:@"BorderviewReady" body:@{}];
}
@end
