//
//  OLApplication.m
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/19/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "OLApplication.h"

static NSString *const name    = @"name";
static NSString *const enabled = @"enabled";
static NSString *const scope   = @"uri";

@implementation OLApplication

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:name];
        self.enabled = [aDecoder decodeBoolForKey:enabled];
        self.scope = [aDecoder decodeObjectForKey:scope];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (self.name) [aCoder encodeObject:self.name forKey:name];
    [aCoder encodeBool:self.enabled forKey:enabled];
    if (self.scope) [aCoder encodeObject:self.scope forKey:scope];
}

@end
