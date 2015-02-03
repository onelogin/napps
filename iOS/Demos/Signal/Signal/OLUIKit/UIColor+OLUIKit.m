//
//  UIColor+OLUIKit.m
//  Launcher
//
//  Created by Oscar Swanros on 11/3/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "UIColor+OLUIKit.h"

@implementation UIColor (OLUIKit)

+ (UIColor *)colorFromHexCode:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)ol_blackColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#1C1F2A"];
    });
    
    return color;
}

+ (UIColor *)ol_whiteColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#FFFFFF"];
    });
    
    return color;
}

+ (UIColor *)ol_cyanColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#00A9E0"];
    });
    
    return color;
}

+ (UIColor *)ol_greenColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#00BFB3"];
    });
    
    return  color;
}

+ (UIColor *)ol_redColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#FF4337"];
    });
    
    return color;
}

+ (UIColor *)ol_darkBlueColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#00629b"];
    });
    
    return color;
}

+ (UIColor *)ol_lightBlueColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#99d6ea"];
    });
    
    return color;
}

+ (UIColor *)ol_separatorColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#C8C7CC"];
    });
    
    return color;
}

+ (UIColor *)ol_superLightGray
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHexCode:@"#FBFBFB"];
    });
    
    return color;
}

@end
