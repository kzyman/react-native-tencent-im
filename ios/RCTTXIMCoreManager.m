#import "RCTTXIMCoreManager.h"
#import <React/RCTLog.h>
#import <CoreGraphics/CGBase.h>
#import <ImSDK/ImSDK.h>
@interface RCTTXIMCoreManager ()<V2TIMAdvancedMsgListener, V2TIMGroupListener>
  @property (nonatomic, assign) int sdkAppId;
  @property (nonatomic, strong) id delegate;
  @property (nonatomic, strong) NSString *groupId;
  @property (nonatomic, strong) NSString *userId;
  @property (nonatomic, strong) NSString *userSig;
@end

@implementation RCTTXIMCoreManager
//白板视图容器
+ (instancetype)sharedInstance
{
    static RCTTXIMCoreManager *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[RCTTXIMCoreManager alloc] init];;
    });
    return instance;
}
- (void) initEngine: (int)sdkAppId delegate:(id)delegate{
  V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
  config.logLevel = V2TIM_LOG_INFO;
  [[V2TIMManager sharedInstance] initSDK:sdkAppId config:config listener:self];
  _sdkAppId= sdkAppId;
  _delegate = delegate;
}
- (void) joinChannel: (NSString *)classId userId:(NSString *)userId userName:(NSString *)userName userSig:(NSString *)userSig {
    _userId = userId;
    _userSig = userSig;
    _groupId = classId;

    [self initIMM: classId userId:userId userName:userName userSig:userSig];

}
- (void) leaveChannel {
      [[TIMGroupManager sharedInstance] quitGroup: _groupId succ:^{
        // 退出IM群组
        // NSDictionary *body =@{@"type": @"leaveChannelSuccess"};
        // [self->_delegate performSelector:@selector(ImCallback:) withObject:body];
      } fail:^(int code, NSString *msg) {
            // NSDictionary *body =@{@"type": @"leaveChannelError", @"msg": msg, @"code": @(code)};
            // [self->_delegate performSelector:@selector(ImCallback:) withObject:body];
      }];

}
- (void) initIMM: (NSString *)classId userId:(NSString *)userId userName:(NSString *)userName userSig:(NSString *)userSig  {
  RCTTXIMCoreManager *ws = self;
  [[V2TIMManager sharedInstance] login:userId userSig:userSig succ:^{
      [[V2TIMManager sharedInstance] removeAdvancedMsgListener:ws];
      [[V2TIMManager sharedInstance] addAdvancedMsgListener:ws];
      V2TIMUserFullInfo *info = [[V2TIMUserFullInfo alloc] init];
      info.nickName = userName;
      [[V2TIMManager sharedInstance] setSelfInfo:info succ:^{
          //
      } fail:^(int code, NSString *desc) {
          //
      }];
      [[V2TIMManager sharedInstance] joinGroup: classId msg:nil succ:^{
        // 加入 IM 群组成功
        // 准备发通知
        NSDictionary *body =@{@"type": @"joinChannelSuccess"};
        [self->_delegate performSelector:@selector(ImCallback:) withObject:body];
      } fail:^(int code, NSString *msg) {
        // 加入 IM 群组失败
        if(code == 10013) {
          // 说明已经在群组里了
          // 准备发通知
              NSDictionary *body =@{@"type": @"joinChannelSuccess"};
              [self->_delegate performSelector:@selector(ImCallback:) withObject:body];
        } else {
              NSDictionary *body =@{@"type": @"joinChannelError", @"msg": msg, @"code": @(code)};
              [self->_delegate performSelector:@selector(ImCallback:) withObject:body];
        }
      }];
  } fail:^(int code, NSString *msg) {
    // 登录 IMSDK 失败
  }];
}
- (void) logout {
    [[V2TIMManager sharedInstance] logout:^{
        // 退出成功
    } fail:^(int code, NSString *desc) {
        // 退出失败
    }];
};
- (void) getGroupMemberList: (NSString *)classId callback:(RCTResponseSenderBlock)callback{
    [[V2TIMManager sharedInstance] getGroupMemberList:classId filter:V2TIM_GROUP_MEMBER_FILTER_ALL nextSeq:0 succ:^(uint64_t nextSeq, NSArray<V2TIMGroupMemberFullInfo *> *memberList) {
        NSMutableArray * copy = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < memberList.count; ++i) {
            if (memberList[i]) {
                NSString *nickName =  @"";
                if (memberList[i].nickName) {
                    nickName = memberList[i].nickName;
                };
                copy[i] = @{
                    @"userId":memberList[i].userID,
                    @"nickName":nickName
                };
            }

        };
        callback(@[@{@"memberList": copy, @"type": @"success"}]);

    } fail:^(int code, NSString *desc) {
        callback(@[@{@"code": @(code), @"desc": desc, @"type": @"error"}]);
    }];
}
#pragma mark - V2TIMAdvancedMsgListener
- (void)onRecvNewMessage:(V2TIMMessage *)msg {
  if (!msg.textElem) {
    return;
  }
  NSDictionary *body =@{@"type": @"groupMessage", @"msg": msg.textElem.text, @"groupId": msg.groupID, @"sneder":msg.sender};
  
  [self->_delegate performSelector:@selector(ImCallback:) withObject:body];
};
#pragma mark - onMemberEnter
- (void)onMemberEnter:(NSString *)groupID memberList:(NSArray<V2TIMGroupMemberInfo *>*)memberList {
    NSDictionary *body =@{@"type": @"onMemberEnter", @"memberList": memberList, @"groupId": groupID};
    
    [self->_delegate performSelector:@selector(ImCallback:) withObject:body];
};
#pragma mark - onMemberInfoChanged
- (void)onMemberInfoChanged:(NSString *)groupID changeInfoList:(NSArray <V2TIMGroupMemberChangeInfo *> *)changeInfoList {
    NSDictionary *body =@{@"type": @"onMemberInfoChanged", @"changeInfoList": changeInfoList, @"groupId": groupID};
    
    [self->_delegate performSelector:@selector(ImCallback:) withObject:body];
};

// 设置用户信息
- (void) setSelfInfo: (NSString *)nickName callback:(RCTResponseSenderBlock)callback {
    V2TIMUserFullInfo *info =[[V2TIMUserFullInfo alloc] init];
    info.nickName = nickName;
    [[V2TIMManager sharedInstance] setSelfInfo:info succ:^ (){
        //
        
    } fail:^(int code, NSString *desc) {
        //
    }];
};

// 发送消息
- (void) sendMessage: (NSString *)message callback:(RCTResponseSenderBlock)callback {

//  NSData *jsonData = [RCTConvert NSData: message];
  V2TIMMessage *sendData = [[V2TIMManager sharedInstance] createTextMessage:message];
//  V2TIMMessage *sendData = [[V2TIMManager sharedInstance] createCustomMessage:jsonData];
  [[V2TIMManager sharedInstance] sendMessage:sendData
                                    receiver:nil
                                     groupID:_groupId
                                    priority:V2TIM_PRIORITY_HIGH
                              onlineUserOnly:YES
                             offlinePushInfo:nil
                                    progress:nil
                                        succ:^{
    if (callback) {
        NSDictionary *body =@{@"type": @"success", @"msg":@"消息发送成功"};
        callback(@[body]);
    };
  } fail:^(int code, NSString *desc) {
      if (callback) {
          NSDictionary *body =@{@"type": @"success", @"mesg":desc, @"code":@(code)};
          callback(@[body]);
      };
  }];
}

// 释放引擎
- (void) unInitEngine {
  dispatch_sync(dispatch_get_main_queue(), ^{
    [[V2TIMManager sharedInstance] unInitSDK];
  });
}

@end

