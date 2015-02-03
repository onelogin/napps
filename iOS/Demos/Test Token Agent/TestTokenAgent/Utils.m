//
//  Utils.m
//  OneLogin SDK
//
//  Created by Oscar Swanros on 5/27/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "Utils.h"

@import UIKit;

static NSString *const letters        = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
static NSString *const kOLErrorDomain = @"OneLoginSDKErrorDomain";

@implementation Utils

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    
    return dict;
}

+ (NSString *)randomStringWithLength:(int)length
{
    NSMutableString *resultString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i < length; i++) {
        [resultString appendFormat: @"%C", [letters characterAtIndex:rand() % letters.length]];
    }
    
    return resultString;
}

+ (void)triggerNetworkActivityIndicator
{
    if ([[UIApplication sharedApplication] isNetworkActivityIndicatorVisible])
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    else
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (NSError *)errorForErrorCode:(OLNAPPSError)errorCode
{
    NSError *error = nil;
    
    switch (errorCode) {
        case OLNAPPSErrorIDPDidNotRespond:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The Identity Provider did not respond.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Try again later.", nil),
                                       };
            error = [NSError errorWithDomain:kOLErrorDomain code:OLNAPPSErrorIDPDidNotRespond userInfo:userInfo];
        }
            break;
            
        case OLNAPPSErrorNetworkNotAvailable:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Network not available.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure your internet connection is enabled and try again.", nil),
                                       };
            error = [NSError errorWithDomain:kOLErrorDomain code:OLNAPPSErrorNetworkNotAvailable userInfo:userInfo];
        }
            break;
            
        case OLNAPPSErrorRequestingAppDoesNotHavePermission:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"This app doesn't have permission.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Contact your system admin.", nil),
                                       };
            error = [NSError errorWithDomain:kOLErrorDomain code:OLNAPPSErrorRequestingAppDoesNotHavePermission userInfo:userInfo];
        }
            break;
            
        case OLNAPPSErrorTokenAgentNotInstalled:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"OneLogin Token Agent not installed on device.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Install the OneLogin Token agent from the App Store and try again.", nil),
                                       };
            
            error = [NSError errorWithDomain:kOLErrorDomain code:OLNAPPSErrorTokenAgentNotInstalled userInfo:userInfo];
        }
            break;
            
        case OLNAPPSErrorNoSessionActive:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"There is no session active at the moment.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Sign in on the Token Agent to create a session", nil)
                                       };
            
            error = [NSError errorWithDomain:kOLErrorDomain code:OLNAPPSErrorNoSessionActive userInfo:userInfo];
        }
            break;
            
        case OLNAPPSErrorSecondaryTokenRequestRejected:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The Primary Token was rejected while executing the request.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Contact OneLogin support.", nil)
                                       };
            
            error = [NSError errorWithDomain:kOLErrorDomain code:OLNAPPSErrorSecondaryTokenRequestRejected userInfo:userInfo];
        }
            break;
            
        case OLNAPPSErrorDeviceCouldNotBeEnrolled:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The device could not be enrolled.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Contact OneLogin support.", nil)
                                       };
            
            error = [NSError errorWithDomain:kOLErrorDomain code:OLNAPPSErrorDeviceCouldNotBeEnrolled userInfo:userInfo];
        }
            break;
            
        case OLNAPPSErrorAppInfoListRefreshFailed:
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Failed to refresh App Info List.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Contact OneLogin support.", nil)
                                       };
            
            error = [NSError errorWithDomain:kOLErrorDomain code:OLNAPPSErrorAppInfoListRefreshFailed userInfo:userInfo];
        }
            break;
            
            
        default:
            break;
    }
    
    return error;
}

+ (void)postNotificationWithName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo
{
    executeOnMainThread(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
    });
}

@end
