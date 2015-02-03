
/*!
 @header    OneLogin.h
 @abstract  OneLogin iOS SDK Header
 @version   1.0
 @copyright Copyright 2014 OneLogin Inc. All rights reserved.
 */


#import <Foundation/Foundation.h>
@import UIKit;

FOUNDATION_EXTERN NSString *const kOLTokenAgentIsInstalledNotification;
FOUNDATION_EXTERN NSString *const kOLTokenAgentIsNotInstalledNotification;
FOUNDATION_EXTERN NSString *const kOLTokenIsValidNotification;
FOUNDATION_EXTERN NSString *const kOLTokenIsInvalidNotification;
FOUNDATION_EXTERN NSString *const kOLSecondaryTokenKey;

@interface OneLogin : NSObject
/*!
 @brief @c BOOL value indicating wether the OneLogin SDK should run on test mode.
 
 If @c YES, the SDK interacts with the Test Token Agent.
 
 This property defaults to @c NO.
 */
@property (assign) BOOL testMode;


/*!
 @brief OneLogin SDK dispatched instance.
 */
+ (instancetype)SDK;


/*!
 Checks wether the OneLogin Token Agent is installed on the device.
 Example usage:
 @code
 if ([[OneLogin SDK] isTokenAgentInstalled]) {
    // Notify the user somehow, or else.
 }
 @endcode
 Depending on the result, either the @c kOLTokenAgentIsInstalledNotification or @c kOLTokenAgentIsNotInstalledNotification notification names will be posted to the main thread too.
 @return BOOL
 */
- (BOOL)isTokenAgentInstalled;


/*!
 Checks wether the OneLogin Token Agent is installed on the device and then executes the given block (if any).
 Example usage:
 @code
 [[OneLogin SDK] verifyTokenAgentIsInstalledWithBlock:^(BOOL isInstalled) {
    if (isInstalled) {
        // The OneLogin Token Agent is installed on the device
    }else{
        // The OneLogin Token Agent is not installed on the device
    }
 }];
 @endcode
 Depending on the result, either the @c kOLTokenAgentIsInstalledNotification or the @c kOLTokenAgentIsNotInstalledNotification notification names will be posted to the main thread too.
 @param block
        Block with a @c BOOL param. It is executed after verifying that the OneLogin Token Agent is installed on the device, and the param reflects that verification.
 */
- (void)verifyTokenAgentIsInstalledWithBlock:(void (^)(BOOL isInstalled))block;


/*!
 Requests a Secondary Token from the OneLogin Token Agent (assuming it is installed).
 */
- (void)requestToken;


/*!
 Checks if the token agent is installed on the device. If so, then procceeds to request a Secondary Token from it and the block isn't executed. If the Token Agent is not installed, the block param is executed.
 Example usage:
 @code
 ...
 
 [[OneLogin SDK] requestTokenByCheckingIfTokenAgentIsInstalled:^(NSError *error) {
    if (error) {
        NSLog(@"%@", error);
    }
 }];
 
 ...
 @endcode
 @param block
        Block with a @c NSError* param containing the result of the operation.
 @return void
 */
- (void)requestTokenByCheckingIfTokenAgentIsInstalled:(void (^)(NSError *error))block;


/*!
 This method must be called from the @c -application:openURL:sourceApplication:annotation: method on the App Delegate.
 @param url 
        The URL that's passed to the @c -application:openURL:sourceApplication:annotation method.
 @param successBlock 
        Block with a @c NSString* param that is executed if the Secondary Token Request was successful.
 @param failuerBlock 
        Block with a @c NSerror* param that is executed if the Secondary Token Request was not successful.
 */
- (void)handleURL:(NSURL *)url success:(void (^)(NSString *token))successBlock failure:(void (^)(NSError *error))failureBlock;

@end