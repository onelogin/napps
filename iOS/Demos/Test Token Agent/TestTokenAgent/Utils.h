//
//  Utils.h
//  OneLogin SDK
//
//  Created by Oscar Swanros on 5/27/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Utils : NSObject

+ (NSDictionary *)parseQueryString:(NSString *)query;
+ (NSString *)randomStringWithLength:(int)length;
+ (NSError *)errorForErrorCode:(OLNAPPSError)error;

+ (void)postNotificationWithName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;
+ (void)triggerNetworkActivityIndicator;

@end

inline __attribute__((always_inline)) void executeOnMainThread(void (^block)())
{
    if (block) {
        if ([NSThread isMainThread]) { block(); } else { dispatch_sync(dispatch_get_main_queue(), block); }
    }
}