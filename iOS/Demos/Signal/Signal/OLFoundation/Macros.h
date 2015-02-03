//
//  Macros.h
//  Launcher
//
//  Created by Oscar Swanros on 11/3/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define user_defaults_get_bool(key)    [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define user_defaults_get_int(key)     ((int) [[NSUserDefaults standardUserDefaults] integerForKey:key])
#define user_defaults_get_integer(key) [[NSUserDefaults standardUserDefaults] integerForKey:key]
#define user_defaults_get_double(key)  [[NSUserDefaults standardUserDefaults] doubleForKey:key]
#define user_defaults_get_string(key)  ol_safeString([[NSUserDefaults standardUserDefaults] stringForKey:key])
#define user_defaults_get_array(key)   [[NSUserDefaults standardUserDefaults] arrayForKey:key]
#define user_defaults_get_object(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define user_defaults_set_bool(key, b)   { [[NSUserDefaults standardUserDefaults] setBool:b    forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_int(key, i)    { [[NSUserDefaults standardUserDefaults] setInteger:i forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_double(key, d) { [[NSUserDefaults standardUserDefaults] setDouble:d  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_string(key, s) { [[NSUserDefaults standardUserDefaults] setObject:s  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_array(key, a)  { [[NSUserDefaults standardUserDefaults] setObject:a  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_object(key, o) { [[NSUserDefaults standardUserDefaults] setObject:o  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }

#define is_ipad()   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define is_iphone() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define APP_DISPLAY_NAME    [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION     	[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_BUILD_NUMBER    [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"]

inline __attribute__((always_inline)) NSString *ol_safeString(NSString *str) { return str ? str : @""; }

inline __attribute__((always_inline)) NSString *ol_dictionaryValueToString(NSObject *cfObj)
{
    if ([cfObj isKindOfClass:[NSString class]]) return (NSString *)cfObj;
    else return [(NSNumber *)cfObj stringValue];
}

inline __attribute__((always_inline)) void ol_executeOnMainThread(void (^block)())
{
    if (block) {
        if ([NSThread isMainThread]) block(); else dispatch_sync(dispatch_get_main_queue(), block);
    }
}

inline __attribute__((always_inline)) void ol_postNotificationName(NSString *notificationName)
{
    ol_executeOnMainThread(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    });
}

inline __attribute__((always_inline)) void ol_clearAllNetworkCacheForDomain(NSString *domain)
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    void (^deleteCookie)(NSHTTPCookie *cookie) = ^(NSHTTPCookie *cookie) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    };
    
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if (domain) {
            if ([[cookie domain] isEqualToString:domain]) {
                deleteCookie(cookie);
            }
        }else{
            deleteCookie(cookie);
        }
    }
    
}