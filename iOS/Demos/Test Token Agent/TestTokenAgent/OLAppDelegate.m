//
//  OLAppDelegate.m
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/16/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "OLAppDelegate.h"

#import "OLModel.h"
#import "OLAddAppViewController.h"

#import "Utils.h"

static NSString *const letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation OLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if ([[url host] isEqualToString:kTokenRequestURLHost]) {
            _requestingAppScope = [[Utils parseQueryString:[url query]] objectForKey:kTokenRequestReturningAppScopeQueryKey];
            _requestingAppURLScheme = [[Utils parseQueryString:[url query]] objectForKey:kTokenRequestReturningAppURLQueryKey];
            
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey] == 0) {
                
                [[OLModel model] appWithScopeHasAccess:_requestingAppScope withBlock:^(BOOL success) {
                    if (success) {
                        [self sendTokenToRequestingAppWitherrorCode:OLNAPPSErrorNone];
                    }else{
                        [self sendTokenToRequestingAppWitherrorCode:OLNAPPSErrorRequestingAppDoesNotHavePermission];
                    }
                }];
            }else{
                [self sendTokenToRequestingAppWitherrorCode:(OLNAPPSError)[[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey]];
            }
        }
    });
    
    return YES;
}

- (NSString *)fakeToken {
    
    NSMutableString *randomString = [[NSMutableString alloc] init];
    
    for (int i=0; i<16; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

- (void)sendTokenToRequestingAppWitherrorCode:(OLNAPPSError)errorCode
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?%@=%@&%@=%tu", _requestingAppURLScheme, kTokenResponseURLHost, kTokenResponseURLTokenQueryKey, [self fakeToken], kTokenResponseURLErrorQueryKey, errorCode]]];
}

@end
