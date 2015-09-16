//
//  TweetManager.h
//  Signal
//
//  Created by Joshua Ridenhour on 7/30/15.
//  Copyright (c) 2015 Troy Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The Tweet Manager manages the list of tweets fetched from
 *  an external server. This manager is built as a singleton
 *  capable of making its own server connections to acquire
 *  the relevant data.
 */
@interface TweetManager : NSObject

/**
 *  The current set of tweets acquired an external provider
 */
@property (nonatomic,readonly) NSArray * tweets;

/**
 *  The TweetManager Singleton
 *
 *  @return The TweetManager Singleton
 */
+(TweetManager*)sharedManager;

/**
 *  This method performs a synchronous network call to retrieve
 *  the tweets. This method is primarily used for background fetches.
 */
+(void)synchronousUpdate;

/**
 *  This method performs an asynchronous network call to retrieve
 *  the tweets. This method is primarily used for foreground fetchs,
 *  which should be done asychronously.
 *
 *  @param completion A completion block
 */
+(void)asynchronousUpdateWithCompletion:(void (^)( NSError* connectionError))completion;

/**
 *  This method clears out all the tweets held by the singleton.
 */
+(void)clearTweets;

@end
