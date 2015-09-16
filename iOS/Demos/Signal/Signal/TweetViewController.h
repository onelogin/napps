//
//  ViewController.h
//  Signal
//
//  Copyright (c) 2014 OneLogin, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This view controller controls the tweet table. It is primarily
 *  responsible for the refresh control which signals the NAPPS token
 *  agent. Most other table view functionality can be found in the
 *  relevant delegate and data source classes.
 */

@interface TweetViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

@end
