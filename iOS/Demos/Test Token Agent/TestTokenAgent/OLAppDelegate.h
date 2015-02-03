//
//  OLAppDelegate.h
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/16/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLAppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *_requestingAppURLScheme;
    NSString *_requestingAppScope;
}

@property (strong, nonatomic) UIWindow *window;

@end
