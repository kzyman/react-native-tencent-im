#import "RCTTICBridgeView.h"
#import <UIKit/UIKit.h>
#import "RCTTICCoreManager.h"
#import <React/RCTLog.h>
#import <CoreGraphics/CGBase.h>
@implementation TICBridgeViewManager
//白板视图容器

RCT_EXPORT_MODULE(TICBridgeView);

- (UIView *)view
{
  UIView * a= [[[RCTTICCoreManager sharedInstance] getBoardController] getBoardRenderView];
  RCTLogInfo(@"sdkAppId: %@ 是什么 %d", a,  [[[RCTTICCoreManager sharedInstance] getBoardController] isDataSyncEnable]);
  return a;
}

@end

