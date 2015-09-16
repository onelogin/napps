//
//  TweetManager.m
//  Signal
//
//  Created by Joshua Ridenhour on 7/30/15.
//  Copyright (c) 2015 Troy Simon. All rights reserved.
//

#import "TweetManager.h"
#import "TokenManager.h"

#import "NSDictionary+DataEncoding.h"

@interface TweetManager ()

@property (nonatomic,strong) NSArray * tweets;

@end

@implementation TweetManager

+(TweetManager*)sharedManager {
    static TweetManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[TweetManager alloc] init];
    });
    
    return __instance;
}

+(NSURLRequest*)tweetRequest {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:@"http://www.evilplancorp.com:5000/index"]];
    /* NAPPS Tutorial:
     * When we make a network request back to our tweet server, we are adding the napps
     * token to the call. This callback is open to design of the server call and it is up to you to include the
     * NAPPS token in a manner that your back-end server can use to validate and extract the needed information
     * from the token.
     */
    
    NSDictionary *d = [NSDictionary dictionaryWithObject:[TokenManager sharedManager].token forKey:@"napps_token"];
    
    NSData *postData = [d encodeDictionary];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    return request;
}

+(void)synchronousUpdate {
    NSURLResponse *response = nil;
    NSError *error = NULL;
    NSData * responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:[self tweetRequest] returningResponse:&response error:&error];
    
    if(responseData) {
        [self updateWithInputData:responseData];
    }
}

+(void)asynchronousUpdateWithCompletion:(void (^)( NSError* connectionError))completion {
    [NSURLConnection sendAsynchronousRequest:[self tweetRequest] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            completion(connectionError);
        } else {
            [self updateWithInputData:data];
            completion(nil);
        }
    }];
}


+(void)updateWithInputData:(NSData*)input {
    [self sharedManager].tweets = [NSJSONSerialization JSONObjectWithData:input options:0 error:nil];
}

+(void)clearTweets {
    [self sharedManager].tweets = @[];
}

@end
