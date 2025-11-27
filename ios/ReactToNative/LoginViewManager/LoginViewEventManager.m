//
//  LoginViewEventManager.m
//  ReactToNative
//
//  Created by Pierluigi Codella on 16/12/24.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(LoginViewEventManager, NSObject)

RCT_EXTERN_METHOD(onLoginSuccess: (NSDictionary)event)
RCT_EXTERN_METHOD(onLogoutSuccess)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}


@end
