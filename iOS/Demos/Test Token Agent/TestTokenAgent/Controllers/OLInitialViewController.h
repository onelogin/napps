//
//  OLInitialViewController.h
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/16/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLInitialViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
