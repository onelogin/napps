//
//  OLNetworkImageLoader.h
//  Launcher
//
//  Created by Oscar Swanros on 11/14/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface OLNetworkImageLoader : NSOperationQueue

+ (void)loadImageAtURL:(NSURL *)url toImageView:(UIImageView *)imageView withPlaceHolderImage:(UIImage *)placeholder;
+ (void)loadImageAtURL:(NSURL *)url toImageView:(UIImageView *)imageView withPlaceHolderImage:(UIImage *)placeholder cachePolicy:(NSURLRequestCachePolicy)cachePolicy;

+ (void)cancelLoadForImageView:(UIImageView *)imageView;

@end
