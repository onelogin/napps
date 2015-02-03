//
//  OLModel.m
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/19/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "OLModel.h"

@implementation OLModel

+ (instancetype)model
{
    static OLModel *__instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[OLModel alloc] init];
    });
    
    return __instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *documentDirectory = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentDirectory = [paths objectAtIndex:0];
        _path = [documentDirectory stringByAppendingPathComponent:@"olapps.dat"];
        NSLog(@"PATH: %@", _path);
    }
    
    return self;
}

#pragma mark -
#pragma Methods

- (BOOL)appWithScopeHasAccess:(NSString *)scope
{
    return [[self enabledApps] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"scope = %@", scope]].count > 0;
}

- (void)appWithScopeHasAccess:(NSString *)scope withBlock:(CompletionBlock)block
{
    if ([self appWithScopeHasAccess:scope]){
        if (block) block(YES);
    }else
        if (block) block(NO);
}



- (NSArray *)enabledApps
{
    if (!_apps) [self loadApps];
    
    NSArray *apps = [NSArray arrayWithArray:_apps];
    
    return [apps filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"enabled = TRUE"]];
}

- (void)saveApp:(OLApplication *)app
{
    if (!_apps) [self loadApps];
    
    [NSKeyedArchiver archiveRootObject:_apps toFile:_path];
}

- (BOOL)addApp:(OLApplication *)app
{
    if (!_apps) [self loadApps];

    [_apps addObject:app];
    
    if ([NSKeyedArchiver archiveRootObject:_apps toFile:_path]) return YES;
    
    return NO;
}


- (void)addApp:(OLApplication *)app withBlock:(CompletionBlock)block
{
    if ([self addApp:app]){
        if (block) block(YES);
    }else
        if (block) block(NO);
}

- (BOOL)deleteApp:(OLApplication *)app
{
    if (!_apps) [self loadApps];
    
    for (OLApplication *a in _apps) {
        if (a == app) {
            [_apps removeObject:app];
            
            if ([NSKeyedArchiver archiveRootObject:_apps toFile:_path])
                return YES;
        }
    }
    
    return NO;
}

- (void)deleteApp:(OLApplication *)app withBlock:(CompletionBlock)block
{
    if ([self deleteApp:app]){
        if (block)
            block(YES);
    }else
        if (block)
            block(NO);
}

#pragma mark - 
#pragma Getters

- (NSArray *)apps
{
    if (!_apps) [self loadApps];
    
    return _apps;
}

- (void)loadApps
{
    _apps = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
    if (!_apps) {
        _apps = [NSMutableArray array];
    }
}

@end
