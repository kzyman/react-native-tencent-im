#import "RCTTXIMBridgeManager.h"
#import <UIKit/UIKit.h>
#import <React/RCTConvert.h>
#import <React/RCTLog.h>

// 这里专门抛出给RN进行调用的接口
#import "RCTTXIMCoreManager.h"
@implementation IMEngineManager
RCT_EXPORT_MODULE();
typedef UInt32 uint32;

RCT_EXPORT_METHOD(initEngine:(int)sdkAppId resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 初始化引擎,初始化单例
  [[RCTTXIMCoreManager sharedInstance] initEngine: sdkAppId delegate:self];
  resolve(@"1");
}

RCT_EXPORT_METHOD(joinChannel:(NSString *)classId userId:(NSString *)userId userSig:(NSString *)userSig resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 加入到频道里面
  [[RCTTXIMCoreManager sharedInstance] joinChannel: classId userId:userId userSig:userSig];
  resolve(@"1");

}
RCT_EXPORT_METHOD(leaveChannel:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 离开频道里面
  [[RCTTXIMCoreManager sharedInstance] leaveChannel];
  resolve(@"1");

}
// 注销引擎
RCT_EXPORT_METHOD(unInitEngine  :(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  [[RCTTXIMCoreManager sharedInstance] unInitEngine];
  resolve(@"1");
}
// 发送消息
RCT_EXPORT_METHOD(sendMessage:(NSString *)message callback:(RCTResponseSenderBlock) callback)
{
    [[RCTTXIMCoreManager sharedInstance] sendMessage:message callback:callback];
}
#pragma mark - listener
- (NSArray<NSString *> *)supportedEvents
{
  return @[ @"joinChannelSuccess", @"joinChannelError", @"groupMessage", @"leaveChannelSuccess", @"leaveChannelError"];
}

- (void)JoinRoomCallback: (NSDictionary *) body
{
  RCTLogInfo(@"加入频道的状态回调 %@", body);
    [self sendEventWithName:[body objectForKey:@"type"] body:body];
}
@end
