//
//  Constants.h
//  OneLogin SDK
//
//  Created by Oscar Swanros on 5/27/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - URL Components

static NSString *const kTokenRequestURLHost                   = @"tokenRequest";
static NSString *const kTokenResponseURLHost                  = @"tokenResponse";
static NSString *const kTokenRequestReturningAppURLQueryKey   = @"a";
static NSString *const kTokenRequestReturningAppScopeQueryKey = @"s";
static NSString *const kTokenResponseURLTokenQueryKey         = @"t";
static NSString *const kTokenResponseURLErrorQueryKey         = @"e";


#pragma mark - Error Declarations

typedef NS_ENUM(NSInteger, OLNAPPSError) {
    OLNAPPSErrorNetworkNotAvailable                = 1000,
    OLNAPPSErrorIDPDidNotRespond                   = 1100,
    OLNAPPSErrorRequestingAppDoesNotHavePermission = 1201,
    OLNAPPSErrorSecondaryTokenRequestRejected      = 1202,
    OLNAPPSErrorAppInfoListRefreshFailed           = 1203,
    OLNAPPSErrorBearerTokenExpired                 = 1204,
    OLNAPPSErrorBearerTokenRevoked                 = 1205,
    OLNAPPSErrorUserDisabled                       = 1206,
    OLNAPPSErrorCouldNotFindBearerToken            = 1207,
    OLNAPPSErrorNoSessionActive                    = 1208,
    OLNAPPSErrorDeviceCouldNotBeEnrolled           = 1209,
    OLNAPPSErrorTokenAgentNotInstalled             = 1300,
    OLNAPPSErrorNone                               = 0
};

inline __attribute__((always_inline)) OLNAPPSError OLNAPPSErrorCodeFromNSString(NSString *errorCode)
{
    if ([errorCode isEqualToString:@"network_not_available"]) {
        return OLNAPPSErrorNetworkNotAvailable;
    }else if ([errorCode isEqualToString:@"idp_did_not_respond"]) {
        return OLNAPPSErrorIDPDidNotRespond;
    }else if ([errorCode isEqualToString:@"requesting_app_does_not_have_permission"]) {
        return OLNAPPSErrorRequestingAppDoesNotHavePermission;
    }else if ([errorCode isEqualToString:@"secondary_token_request_rejected"]) {
        return OLNAPPSErrorSecondaryTokenRequestRejected;
    }else if ([errorCode isEqualToString:@"app_info_list_refresh_failed"]) {
        return OLNAPPSErrorAppInfoListRefreshFailed;
    }else if ([errorCode isEqualToString:@"bearer_token_expired"]) {
        return OLNAPPSErrorBearerTokenExpired;
    }else if ([errorCode isEqualToString:@"bearer_token_revoked"]) {
        return OLNAPPSErrorBearerTokenRevoked;
    }else if ([errorCode isEqualToString:@"user_disabled"]) {
        return OLNAPPSErrorUserDisabled;
    }else if ([errorCode isEqualToString:@"bearer_token_not_found"]) {
        return OLNAPPSErrorCouldNotFindBearerToken;
    }else if ([errorCode isEqualToString:@"token_agent_not_installed"]) {
        return OLNAPPSErrorTokenAgentNotInstalled;
    }else if ([errorCode isEqualToString:@"no_session_active"]) {
        return OLNAPPSErrorNoSessionActive;
    }else if ([errorCode isEqualToString:@"device_could_not_be_enrolled"]) {
        return OLNAPPSErrorDeviceCouldNotBeEnrolled;
    }else {
        return OLNAPPSErrorNone;
    }
}

inline __attribute__((always_inline)) NSString * NSStringFromOLNAPPSErrorCode(OLNAPPSError error)
{
    switch (error) {
        case OLNAPPSErrorNetworkNotAvailable:
            return @"network_not_available";
            break;
            
        case OLNAPPSErrorIDPDidNotRespond:
            return @"idp_did_not_respond";
            break;
            
        case OLNAPPSErrorRequestingAppDoesNotHavePermission:
            return @"requesting_app_does_not_have_permission";
            break;
            
        case OLNAPPSErrorSecondaryTokenRequestRejected:
            return @"secondary_token_request_rejected";
            break;
            
        case OLNAPPSErrorAppInfoListRefreshFailed:
            return @"app_info_list_refresh_failed";
            break;
            
        case OLNAPPSErrorBearerTokenExpired:
            return @"bearer_token_expired";
            break;
            
        case OLNAPPSErrorBearerTokenRevoked:
            return @"bearer_token_revoked";
            break;
            
        case OLNAPPSErrorUserDisabled:
            return @"user_disabled";
            break;
            
        case OLNAPPSErrorCouldNotFindBearerToken:
            return @"bearer_token_not_found";
            break;
            
        case OLNAPPSErrorTokenAgentNotInstalled:
            return @"token_agent_not_installed";
            break;
            
        case OLNAPPSErrorNoSessionActive:
            return @"no_session_active";
            break;
            
        case OLNAPPSErrorDeviceCouldNotBeEnrolled:
            return @"device_could_not_be_enrolled";
            break;
            
        default:
            return @"no_error";
            break;
    }
}