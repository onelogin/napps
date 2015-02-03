//
//  OLApplication.h
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/19/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLApplication : NSObject <NSCoding>
@property (nonatomic, copy) NSString *name;
@property (assign) BOOL enabled;
@property (nonatomic, copy) NSString *scope;
@end
