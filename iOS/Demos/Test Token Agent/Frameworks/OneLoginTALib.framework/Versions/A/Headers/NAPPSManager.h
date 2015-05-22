//
//  OneLoginTALib.h
//  OneLoginTALib
//
//  Created by Oscar Swanros on 5/27/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

/*!
 * This library can make calls to Production, QA, Shadow and Staging OneLogin Servers. Which server the requests are sent to is determined via a key on NSUserDefaults.
 *    —> 1337: Point to QA Servers
 *    —> 3557: Point to Shadow Servers
 *    —> 5746: Point to Staging Servers
 *
 * Anything other than those two codes will make the API Calls point to Production Servers, including no value at all.
 */

/*!
 @discussion Enumerator for the request types the Token Agent can handle
 */
typedef NS_ENUM(NSUInteger, OLTokenAgentCallType) {
    OLTokenAgentCallTypeSecondaryTokenRequest = 1
};

@interface NAPPSManager : NSObject

/*!
 @brief Holds the URL Scheme for the app that called the Token Agent
 */
@property (nonatomic, readonly) NSString *requestingAppURLScheme;


/*!
 @brief Holds the Scope for the app that called the Token Agent
 */
@property (nonatomic, readonly) NSString *requestingAppScope;


/*!
 @brief Setting this property to @c YES will trigger a Secondary Token Request the next time the App Info List is downloaded.
 */
@property (nonatomic) BOOL secondaryTokenRequestAwaiting;


/*!
 @brief Dispatched instance of @c NAPPSManager.
 */
+ (instancetype)sharedManager;


/*!
 Handles a call to the Token Agent. This method will return a Secondary Token to the @c successBlock if the request was successful, or a @c OLNAPPSError object to the @c failureBlock if an error is encountered while requesting a Secondary Token.
 Example usage:
 @code
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
    [[NAPPSManager sharedManager] handleTokenAgentCallWithURL:url executeAutomatically:NO success:^(NSString *token) {
        NSLog(@"GOT TOKEN FOR SECONDARY APP: %@", token);
    } failure:^(OLNAPPSError error) {
        switch (error) {
            case OLNAPPSErrorNoSessionActive:{
                [NAPPSManager sharedManager].secondaryTokenRequestAwaiting = YES;
            }
                break;
 
            default:
                break;
        }
    }];
 
    return YES;
 }
 @endcode
 @param url
        The URL that's passed to the @c -application:openURL:sourceApplication:annotation method
 @param automaticExecution
        If @c YES, and, if the Secondary Token request was successful, the @c successBlock won't be executed and the Secondary Token (@c NSString*) will be automatically returned to the requesting application.
 @param successBlock 
        Block that returns @c void and receives a @c NSString* param, which is the Secondary Token requested by an app. This block is executed on the main thread.
 @param failureBlock
        Block tat returns @c void and receives a @c OLNAPPSerror param. This block is executed if something wen't wrong while requesting a Secondary Token. This block is executed on the main thread.
 @return void
 */
- (void)handleTokenAgentCallWithURL:(NSURL *)url executeAutomatically:(BOOL)automaticExecution success:(void (^)(NSString *token))successBlock failure:(void (^)(OLNAPPSError error))failureBlock;


/*!
 Requests a Secondary Token for a specific app with a @c scope. If the request was successful the Secondary Token is passed to the @c successBlock, otherwise a @c OLNAPPSError is passed to the @c failureBlock.
 Example usage:
 @code
 ...
 
 [[NAPPSManager sharedManager] requestSecondaryTokenForAppWithScope:@"com.onelogin.Signal" success:^(NSString *token) {
     NSLog(@"TOKEN: %@", token);
 } failure:^(OLNAPPSError error) {
     NSLog(@"%li", error);
 }];
 
 ...
 @endcode
 @param scope 
        A @c NSString* representing the scope of the application that the Secondary Token is for.
 @param successBlock
        Block that returns @c void and receives a @c NSString* param, which is the
 Secondary Token requested by an app. This block is executed on the main thread.
 @param failureBlock
        Block tat returns @c void and receives a @c OLNAPPSerror param. This block is executed if something wen't wrong while requesting a Secondary Token. This block is executed on the main thread.
 @return void
 */
- (void)requestSecondaryTokenForAppWithScope:(NSString *)scope success:(void (^)(NSString *token))successBlock failure:(void (^)(OLNAPPSError error))failureBlock;


/*!
 Saves the information necessary for NAPPS to work correctly.
 Example usage:
 @code
 // Here you would obtain the dataToken and the dataUserAPIKey somehow, from a login form, for instance.
 
 [[NAPPSManager sharedManager] saveSessionWithDataToken:dataToken dataUserAPIKey:dataUserAPIKey];
 @endcode
 @param dataToken
        @c NSString* obtained after the user has signed in correctly.
 @param dataUserAPIKey
        @c NSString* obtained after the user has signed in correctly.
 @return void
 */
- (void)saveSessionWithDataToken:(NSString *)dataToken JSONWebToken:(NSString *)jwt;


/*!
 Saves the information necessary for NAPPS to work correctly.
 Example usage:
 @code
 // Here you would obtain the dataToken and the dataUserAPIKey somehow, from a login form, for instance.
 
 [[NAPPSManager sharedManager] saveSessionWithDataToken:dataToken dataUserAPIKey:dataUserAPIKey andBlock:^{
    // Custom block to execute after the NAPPS information is saved
 }];
 @endcode
 @param dataToken
        @c NSString* obtained after the user has signed in correctly.
 @param dataUserAPIKey
        @c NSString* obtained after the user has signed in correctly.
 @param block
        Block that returns @c void and receives no parameters. Use this block to execute custom logic after the data has been saved. This block is executed after the data has been saved correctly and is always executed on the main thread.
 @return void
 */
- (void)saveSessionWithDataToken:(NSString *)dataToken JSONWebToken:(NSString *)jwt andBlock:(void (^)())block;


/*!
 Removes all information regarding NAPPS from the current device, except the enrollment.
 */
- (void)removeData;

@end
