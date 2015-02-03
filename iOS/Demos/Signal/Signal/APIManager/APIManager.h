//
//  APIManager.h
//  Signal
//
//  Created by Oscar Swanros on 2/3/15.
//  Copyright (c) 2015 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

@property (nonatomic, copy) NSString *authToken;

+ (instancetype) sharedManager;
- (void)downloadTweetsWithBlock:(void (^)(NSArray *tweets))block;

@end
