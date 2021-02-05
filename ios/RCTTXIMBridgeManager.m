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
RCT_EXPORT_METHOD(login:(NSString *)userId
                  userName:(NSString *)userName userSig:(NSString *)userSig resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 登录
  [[RCTTXIMCoreManager sharedInstance] login:userId
                                          userName:userName userSig:userSig];
  resolve(@"1");

}
RCT_EXPORT_METHOD(joinChannel:(NSString *)classId userId:(NSString *)userId
                  userName:(NSString *)userName userSig:(NSString *)userSig resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 加入到频道里面
  [[RCTTXIMCoreManager sharedInstance] joinChannel: classId userId:userId
                                          userName:userName userSig:userSig];
  resolve(@"1");

}
RCT_EXPORT_METHOD(getGroupMemberList: (NSString *)classId callback:(RCTResponseSenderBlock) callback)
{
  // 获取群成员信息
    [[RCTTXIMCoreManager sharedInstance] getGroupMemberList:classId callback:callback];

}
RCT_EXPORT_METHOD(logout)
{
  // 退出登录里面
  [[RCTTXIMCoreManager sharedInstance] logout];

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
  return @[ @"joinChannelSuccess", @"joinChannelError", @"groupMessage", @"leaveChannelSuccess", @"leaveChannelError", @"onMemberInfoChanged", @"onMemberEnter"];
}

- (void)ImCallback: (NSDictionary *) body
{
  RCTLogInfo(@"加入频道的状态回调 %@", body);
    [self sendEventWithName:[body objectForKey:@"type"] body:body];
}
@end
