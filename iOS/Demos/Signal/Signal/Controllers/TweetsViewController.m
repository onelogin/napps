//
//  TweetsViewController.m
//  Signal
//
//  Created by Oscar Swanros on 2/3/15.
//  Copyright (c) 2015 OneLogin. All rights reserved.
//

#import "TweetsViewController.h"
#import "AppDelegate.h"
#import "TweetTableViewCell.h"
#import "UIColor+OLUIKit.h"
#import "APIManager.h"

#import <OneLoginSDK/OneLogin.h>

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, copy) NSArray *tweets;
@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tweets = [(AppDelegate *)[UIApplication sharedApplication].delegate tweets];

    
    self.title = @"Tweets!";
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName: [UIColor ol_whiteColor]
                                     };
    [[UINavigationBar appearance] setBarTintColor:[UIColor ol_cyanColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.refreshControl];
    
    [self registerForNotifications];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetsUpdated) name:kTweetsUpdatedNotification object:nil];
}

- (void)unRegisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTweetsUpdatedNotification object:nil];
}

- (void)refreshTweets
{
    [_refreshControl beginRefreshing];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[OneLogin SDK] requestTokenByCheckingIfTokenAgentIsInstalled:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_refreshControl endRefreshing];
    });
}

- (void)tweetsUpdated
{
    [_tableView reloadData];
}

#pragma mark - Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[TweetTableViewCell class] forCellReuseIdentifier:@"TweetCell"];
    }
    
    return _tableView;
}

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] initWithFrame:_tableView.frame];
        [_refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];
    }
    
    return _refreshControl;
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    cell.tweet = _tweets[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Tweet *tweet = [(TweetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] tweet];
    
    NSURL *tweetUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@/status/%@",tweet.username, tweet._id]];
    
    [[UIApplication sharedApplication]openURL:tweetUrl];
}

@end
