//
//  NSDictionary+DataEncoding.m
//  Signal
//
//  Created by Joshua Ridenhour on 7/31/15.
//  Copyright (c) 2015 Troy Simon. All rights reserved.
//

#import "NSDictionary+DataEncoding.h"

@implementation NSDictionary (DictionaryEncoding)

- (NSData*)encodeDictionary
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in self.allKeys)
    {
        NSString *encodedValue = [[self objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

@end
