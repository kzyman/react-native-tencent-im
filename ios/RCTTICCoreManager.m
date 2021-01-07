#import "RCTTICCoreManager.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <React/RCTLog.h>
#import <CoreGraphics/CGBase.h>
@interface RCTTICCoreManager ()
  @property (nonatomic, assign) int sdkAppId;
  @property (nonatomic, strong) id delegate;
  @property (nonatomic, strong) NSString *groupId;
  @property (nonatomic, strong) NSString *userId;
  @property (nonatomic, strong) NSString *userSig;
  @property (nonatomic, strong) TEduBoardController *boardController;
  @property (nonatomic, strong) UIView *boardView;
  @property (nonatomic, strong) UIView *imController;
@end

@implementation RCTTICCoreManager
//白板视图容器
+ (instancetype)sharedInstance
{
    static RCTTICCoreManager *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[RCTTICCoreManager alloc] init];;
    });
    return instance;
}
- (void) initEngine: (int)sdkAppId delegate:(id)delegate{
  _sdkAppId= sdkAppId;
  _delegate = delegate;
}
- (void) joinChannel: (NSString *)classId userId:(NSString *)userId userSig:(NSString *)userSig {
  dispatch_sync(dispatch_get_main_queue(), ^{
    _userId = userId;
    _userSig = userSig;
    _groupId = classId;
    [self initIMM: classId userId:userId userSig:userSig];
  });
}
- (void) joinChannelReal: (NSString *)classId userId:(NSString *)userId userSig:(NSString *)userSig {
  TEduBoardAuthParam *authParam = [[TEduBoardAuthParam alloc] init];
  authParam.sdkAppId = _sdkAppId;
  authParam.userId = _userId;
  authParam.userSig = _userSig;
  RCTLogInfo(@"成功到最后一步");
  TEduBoardInitParam *initParam = [[TEduBoardInitParam alloc] init];
  _boardController = [[TEduBoardController alloc] initWithAuthParam:authParam roomId:[classId integerValue] initParam:initParam];
  [_boardController addDelegate: self];
}
- (void) initIMM: (NSString *)classId userId:(NSString *)userId userSig:(NSString *)userSig  {
  TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
  config.sdkAppId = _sdkAppId;
  [[TIMManager sharedInstance] initSdk:config];
  TIMLoginParam *loginParam = [TIMLoginParam new];
  loginParam.identifier = userId;
  loginParam.userSig = userSig;
  loginParam.appidAt3rd = [@(_sdkAppId) stringValue];
  RCTTICCoreManager *ws = self;
  [[TIMManager sharedInstance] login:loginParam succ:^{
    TIMCreateGroupInfo *groupInfo = [[TIMCreateGroupInfo alloc] init];
    groupInfo.group = classId;
    groupInfo.groupName = classId;
    groupInfo.groupType = @"Public";
    groupInfo.setAddOpt = YES;
    groupInfo.addOpt = TIM_GROUP_ADD_ANY;
    [[TIMGroupManager sharedInstance] createGroup:groupInfo succ:^(NSString *classId) {
      // 创建 IM 群组成功
      [[TIMGroupManager sharedInstance] joinGroup: classId msg:nil succ:^{
        // 加入 IM 群组成功
        // 此时可以调用白板初始化接口创建白板
//        RCTLogInfo(@"成功到最后一11");
        [ws joinChannelReal: classId userId:userId userSig:userSig];

      } fail:^(int code, NSString *msg) {
        // 加入 IM 群组失败
        if(code == 10013){
          [ws joinChannelReal: classId userId:userId userSig:userSig];
        }
      }];
    } fail:^(int code, NSString *msg) {
      // 创建 IM 群组失败
      [[TIMGroupManager sharedInstance] joinGroup: classId msg:nil succ:^{
        // 加入 IM 群组成功
        // 此时可以调用白板初始化接口创建白板
        [ws joinChannelReal: classId userId:userId userSig:userSig];
      } fail:^(int code, NSString *msg) {
        // 加入 IM 群组失败
        if(code == 10013){
          [ws joinChannelReal: classId userId:userId userSig:userSig];
        }
      }];
    }];  
  } fail:^(int code, NSString *msg) {
    // 登录 IMSDK 失败
  }];
}
- (void)onTEBInit
{
  // 赋值白板，别处通过单例获取这个白板
  _boardView = [_boardController getBoardRenderView];
  [_delegate performSelector:@selector(viewReady)];
}
- (TEduBoardController *)getBoardController
{
    return _boardController;
}
// 解散群组
- (void) dismissGroup {
  dispatch_sync(dispatch_get_main_queue(), ^{
    [[V2TIMManager sharedInstance] dismissGroup:_groupId succ:^{
      // 解散 IM 群组成功
      RCTLogInfo(@"成功");
    } fail:^(int code, NSString *msg) {
      // 解散 IM 群组失败
      RCTLogInfo(@"失败原因: %@", msg);
    }];
  });
//  [TIMManager sharedInstance];
//  [[TIMManager sharedInstance] dismissGroup: _groupId];
}
- (void) addListener: (NSString *) name callback:(RCTResponseSenderBlock)callback {
  
}
// 释放引擎
- (void) unInitEngine {
  dispatch_sync(dispatch_get_main_queue(), ^{
    [[TIMManager sharedInstance] unInit];
    [_boardController unInit];
  });
}
- (void) callMethod: (NSString *) methodName params:(NSMutableDictionary *) params {
    // 动态调用各个方法
  dispatch_sync(dispatch_get_main_queue(), ^{
    if ([methodName isEqualToString:@"setToolType"]) {
      // 设置白板工具, 这里包含直线，随意曲线，椭圆,方形, 鼠标等
      [_boardController setToolType : [RCTConvert int: [params objectForKey:@"type"]]];
    } else if ([methodName isEqualToString:@"clearBackground"]) {
      // 清空选中或者全屏
      [_boardController clearBackground : [RCTConvert BOOL:[params objectForKey:@"background"]] andSelected:[RCTConvert BOOL: [params objectForKey:@"selected"]]];
    } else if ([methodName isEqualToString:@"setBrushColor"]) {
      // 设置刷子颜色
      NSArray *color = [params objectForKey:@"color"];
      [_boardController setBrushColor : [UIColor colorWithRed:[[color objectAtIndex: 0] integerValue]/255.0
                                                        green:[[color objectAtIndex: 1] integerValue]/255.0
                                                        blue:[[color objectAtIndex: 2] integerValue]/255.0
                                                        alpha:[[color objectAtIndex: 3] integerValue]]];
    } else if ([methodName isEqualToString:@"setBrushThin"]) {
      // 设置刷子粗细
      [_boardController setBrushThin : [RCTConvert float: [params objectForKey:@"thin"]]];
    } else if ([methodName isEqualToString:@"setTextColor"]) {
      // 设置文本颜色
      NSArray *color = [params objectForKey:@"color"];
      [_boardController setTextColor : [UIColor colorWithRed:[[color objectAtIndex: 0] integerValue]/255.0
                                                        green:[[color objectAtIndex: 1] integerValue]/255.0
                                                        blue:[[color objectAtIndex: 2] integerValue]/255.0
                                                        alpha:[[color objectAtIndex: 3] integerValue]]];
    } else if ([methodName isEqualToString:@"setTextSize"]) {
      // 设置字体大小
      [_boardController setTextSize : [RCTConvert int: [params objectForKey:@"size"]]];
    } else if ([methodName isEqualToString:@"undo"]) {
      // 撤销
      [_boardController undo];
    } else if ([methodName isEqualToString:@"redo"]) {
      // 重做
      [_boardController redo];
    } else if ([methodName isEqualToString:@"addElement"]) {
      // 添加元素
      [_boardController addElement :  [RCTConvert NSString: [params objectForKey:@"url"]] type: [RCTConvert int: [params objectForKey:@"type"]]];
    } else if ([methodName isEqualToString:@"setDrawEnable"]) {
      // 是否允许涂鸦
      [_boardController setDrawEnable: [RCTConvert BOOL:[params objectForKey:@"enable"]]];
    }
  });
}
@end

