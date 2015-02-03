//
//  APIManager.m
//  Signal
//
//  Created by Oscar Swanros on 2/3/15.
//  Copyright (c) 2015 OneLogin. All rights reserved.
//

#import "APIManager.h"

#import "Tweet.h"
@import UIKit;

inline __attribute__((always_inline)) void executeOnMainThread(void (^block)()) {
    if ([NSThread isMainThread]) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

inline __attribute__((always_inline)) void toggleNetworkActivityIndicator() {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:![UIApplication sharedApplication].networkActivityIndicatorVisible];
}

static NSString *const kBaseURL = @"http://192.34.58.163:5000/index";

@implementation APIManager

+ (instancetype) sharedManager
{
    static APIManager *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[APIManager alloc] init];
    });
    
    return __instance;
}

- (void)downloadTweetsWithBlock:(void (^)(NSArray *tweets))block
{
    toggleNetworkActivityIndicator();
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kBaseURL]];
    [request setValue:_authToken forHTTPHeaderField:@"Auth-Token"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        toggleNetworkActivityIndicator();
        
        if (error) {
            NSLog(@"%@", error);
        }else{
            NSError *JSONError;
            NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&JSONError];
            
            NSArray *tweetList = JSONArray[0][@"list"];
            
            NSMutableArray *tweets = [[NSMutableArray alloc] init];
            
            for (NSDictionary *tweet in tweetList) {
                Tweet *newTweet = [[Tweet alloc] init];
                newTweet.date = tweet[@"date"];
                newTweet.username = tweet[@"user_name"];
                newTweet.text = tweet[@"text"];
                newTweet.pictureUrl = [NSURL URLWithString:tweet[@"picture_url"]];
                newTweet._id = [NSString stringWithFormat:@"%@", tweet[@"tweet_id"]];
                
                [tweets addObject:newTweet];
            }
            
            if (block) {
                executeOnMainThread(^{
                    block(tweets);
                });
            }
        }
    }];
    
    [dataTask resume];
}

@end
