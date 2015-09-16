//
//  TweetDataSource.h
//  Signal
//
//  Copyright (c) 2015 OneLogin, Incs. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This class is the data source for our twitter data feed.
 *  The data source does not itself contain the tweets, but 
 *  instead using the TweetManager singleton as a data provider.
 */

@interface TweetDataSource : NSObject <UITableViewDataSource>

@end
