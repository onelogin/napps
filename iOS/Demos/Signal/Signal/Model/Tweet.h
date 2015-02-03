//
//  Tweet.h
//  Signal
//
//  Created by Oscar Swanros on 2/3/15.
//  Copyright (c) 2015 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSURL    *pictureUrl;
@property (nonatomic, copy) NSString *_id;
@end
