//
//  TokenManager.h
//  Signal
//
//  Copyright (c) 2015 OneLogin, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kServiceConfigDidChangeNotification @"kServiceConfigDidChangeNotification"

/**
 *  This manager stores the secondary token provided by NAPPS.
 *  The particular token storage is open to fit app design.
 *  In this application, the token manager contains the functionality
 *  for sending token requests.
 */

@interface TokenManager : NSObject

/**
 *  The token returned by the NAPPS token agent
 */
@property (nonatomic,copy) NSString * token;

/**
 *  The TokenManager singleton
 *
 *  @return The TokenManager singleton
 */
+(instancetype)sharedManager;

/**
 *  This method calls into the NAPPS SDK and requests a token if the
 *  token agent is available. This method will not recieve the token
 *  directly, as the token agent will return the token through the
 *  AppDelegate openURL callback.
 */
+(void)requestToken;

@end
