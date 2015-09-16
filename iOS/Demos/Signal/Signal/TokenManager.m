//
//  TokenManager.m
//  Signal
//
//  Copyright (c) 2015 OneLogin, Inc. All rights reserved.
//

#import "TokenManager.h"

#import <OneLoginSDK/OneLogin.h>

@implementation TokenManager

+(instancetype)sharedManager {
    static TokenManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[TokenManager alloc] init];
    });
    
    return __instance;
}

-(void)setToken:(NSString *)token {
    [self willChangeValueForKey:@"token"];
    
    _token = [token copy];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kServiceConfigDidChangeNotification object:token];
    
    [self didChangeValueForKey:@"token"];
    
}

+(void)requestToken
{
    /* NAPPS Tutorial:
     * Make the request for the NAPPS token. This call will only proceed if
     * a known token agent in discovered on the device. In test mode, this
     * TA is the mock token, otherwise, this is the OneLogin Mobile
     * application.
     * The SDK relies on the values from the first URL Type Scheme defined for
     * the Application and passes that information to the Token Agent.
     * If no URL Scheme is defined, then this will throw an exception.
     */
    [[OneLogin SDK] requestTokenByCheckingIfTokenAgentIsInstalled:^(NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error code %tu", error.code] message:[NSString stringWithFormat:@"%@\n%@", error.localizedDescription, error.localizedRecoverySuggestion] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            });
        }
    }];
}

@end
