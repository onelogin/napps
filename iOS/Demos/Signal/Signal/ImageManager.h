//
//  ImageManager.h
//  Signal
//
//  Created by Joshua Ridenhour on 7/31/15.
//  Copyright (c) 2015 Troy Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This simple manager class has one function for acquiring images
 *  from a URL.
 */

@interface ImageManager : NSObject

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end
