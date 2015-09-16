//
//  AppDelegate.m
//  Signal
//
//  Created by Troy Simon on 7/15/14.
//  Copyright (c) 2014 OneLogin, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import <OneLoginSDK/OneLogin.h>

#import "TokenManager.h"
#import "TweetManager.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* NAPPS Tutorial:
     * We ensure NAPPS is not set to test mode. Test mode will define which token agent
     * to use, either the mock token agent or the OneLogin Mobile Application.
     * WARNING: Make sure the final, shipping version of your application is NOT set
     * to test mode [[OneLogin SDK] setTestMode:NO];
     *
     */
    [[OneLogin SDK] setTestMode:NO];

    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //Perform a synchronous update of the tweet manager
    [TweetManager synchronousUpdate];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    /* NAPPS Tutorial:
     * This is the code that handles decoding the JWT token from the Token Agent.
     * Send the incoming Callback URL (defined in Signal -> Info -> Url types schema) to this function to extract the token.
     * The NAPPS SDK will handle the token extraction and will pass back the token to success block.
     */
    [[OneLogin SDK] handleURL:url success:^(NSString *token) {
        
        [TokenManager sharedManager].token = token;
        
    } failure:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error code %tu", error.code] message:[NSString stringWithFormat:@"%@\n%@", error.localizedDescription, error.localizedRecoverySuggestion] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }];
    
    return YES;
}

@end
