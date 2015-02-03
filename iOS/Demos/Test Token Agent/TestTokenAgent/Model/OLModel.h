//
//  OLModel.h
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/19/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OLApplication.h"

static NSString *const kErrorKey = @"OLErrorKey";

typedef void (^CompletionBlock) (BOOL success);

@interface OLModel : NSObject{
    NSString *_path;
    NSMutableArray *_apps;
}

+ (instancetype)model;

- (NSArray *)apps;

- (BOOL)addApp:(OLApplication *)app;
- (void)addApp:(OLApplication *)app withBlock:(CompletionBlock)block;

- (void)saveApp:(OLApplication *)app;

- (BOOL)deleteApp:(OLApplication *)app;
- (void)deleteApp:(OLApplication *)app withBlock:(CompletionBlock)block;

- (BOOL)appWithScopeHasAccess:(NSString *)scope;
- (void)appWithScopeHasAccess:(NSString *)scope withBlock:(CompletionBlock)block;
@end
