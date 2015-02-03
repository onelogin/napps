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
 @brief Setting this property to @c YES will trigger a Secondary Token Request the next time the App Info List is downloaded.
 */
@property (nonatomic)           BOOL    secondaryTokenRequestAwaiting;


/*!
 @brief Indicates wether a session for NAPPS is currently active.
 */
@property (nonatomic, readonly) BOOL    sessionActive;


/*!
 @brief Dispatched instance of @c NAPPSManager.
 */
+ (instancetype)sharedManager;


/*!
 Handles a call to the Token Agent.
 Example usage:
 @code
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
    [[NAPPSManager sharedManager] handleTokenAgentCallWithURL:url withBlock:^(OLNAPPSError error) {
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
 @param block
        Block that returns @c void and receives a @c OLNAPPSError param, which will be @c nil if everything went correctly. The block is executed on the main thread.
 @return void
 */
- (void)handleTokenAgentCallWithURL:(NSURL *)url withBlock:(void (^)(OLNAPPSError error))block;


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
- (void)saveSessionWithDataToken:(NSString *)dataToken dataUserAPIKey:(NSString *)dataUserAPIKey;


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
        Block that returns @c void and receives no parameters. It is executed after the data has been saved correctly. It is always executed on the main thread.
 @return void
 */
- (void)saveSessionWithDataToken:(NSString *)dataToken dataUserAPIKey:(NSString *)dataUserAPIKey andBlock:(void (^)())block;


/*!
 Removes all information regarding NAPPS from the current device, except the enrollment.
 */
- (void)removeData;

@end
