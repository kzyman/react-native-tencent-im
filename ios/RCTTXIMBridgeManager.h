#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <React/RCTEventEmitter.h>

@interface IMEngineManager : RCTEventEmitter <RCTBridgeModule>
-(void) ImCallback: (NSDictionary *) body ;
@end

