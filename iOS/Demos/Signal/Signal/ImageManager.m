//
//  ImageManager.m
//  Signal
//
//  Created by Joshua Ridenhour on 7/31/15.
//  Copyright (c) 2015 Troy Simon. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
        queue:[NSOperationQueue mainQueue]
        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if ( !error )
                {
                    UIImage *image = [[UIImage alloc] initWithData:data];

                                   
                    completionBlock(image!=nil,image);
                }
                else
                {
                    completionBlock(NO,nil);
                }
    }];
}

@end
