//
//  UIColor+OLUIKit.h
//  Launcher
//
//  Created by Oscar Swanros on 11/3/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (OLUIKit)

+ (UIColor *)colorFromHexCode:(NSString *)hexString;
+ (UIColor *)ol_blackColor;
+ (UIColor *)ol_whiteColor;
+ (UIColor *)ol_cyanColor;
+ (UIColor *)ol_greenColor;
+ (UIColor *)ol_redColor;
+ (UIColor *)ol_darkBlueColor;
+ (UIColor *)ol_lightBlueColor;
+ (UIColor *)ol_separatorColor;
+ (UIColor *)ol_superLightGray;

@end
