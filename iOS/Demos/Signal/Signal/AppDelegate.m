//
//  AppDelegate.m
//  Signal
//
//  Created by Oscar Swanros on 2/3/15.
//  Copyright (c) 2015 OneLogin. All rights reserved.
//

#import "AppDelegate.h"

#import <OneLoginSDK/OneLogin.h>
#import "APIManager.h"

NSString *const kTweetsUpdatedNotification = @"kTweetsUpdatedNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[OneLogin SDK] handleURL:url success:^(NSString *token) {
        [APIManager sharedManager].authToken = token;
        [[APIManager sharedManager] downloadTweetsWithBlock:^(NSArray *tweets) {
            self.tweets = tweets;
        }];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %li", (long)error.code] message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }];
    
    return YES;
}

- (void)setTweets:(NSArray *)tweets
{
    _tweets = tweets;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTweetsUpdatedNotification object:nil];
}

@end
