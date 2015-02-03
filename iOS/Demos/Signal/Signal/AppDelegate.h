//
//  AppDelegate.h
//  Signal
//
//  Created by Oscar Swanros on 2/3/15.
//  Copyright (c) 2015 OneLogin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kTweetsUpdatedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSArray *tweets;

@end

