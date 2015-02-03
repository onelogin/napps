//
//  OLSettingsViewController.h
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/28/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
