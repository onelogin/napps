//
//  ViewController.m
//  Signal
//
//  Copyright (c) 2014 OneLogin, Inc. All rights reserved.
//

#import "TweetViewController.h"

#import "TweetCell.h"

#import "TweetManager.h"
#import "TokenManager.h"

#import "TweetDataSource.h"
#import "TweetDelegate.h"

#import <OneLoginSDK/OneLogin.h>

static NSString *const URLScheme = @"SIGNAL"; // This app URL Scheme

@interface TweetViewController ()<NSURLConnectionDelegate>

@property (nonatomic,strong) NSMutableData * responseData;

@property (nonatomic,strong) TweetDataSource * dataSource;
@property (nonatomic,strong) TweetDelegate * delegate;


@end

@implementation TweetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[TweetDataSource alloc] init];
    self.delegate = [[TweetDelegate alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kServiceConfigDidChangeNotification object:nil];

    UIImageView *logoImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"newlogo"]];
    
    self.navigationItem.titleView = logoImage;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [TokenManager requestToken];
}

-(void)setDataSource:(TweetDataSource *)dataSource {
    [self willChangeValueForKey:@"dataSource"];
    
    self.tableView.dataSource = dataSource;
    _dataSource = dataSource;
    [self.tableView reloadData];
    
    [self didChangeValueForKey:@"dataSource"];
}

-(void)setDelegate:(TweetDelegate *)delegate {
    [self willChangeValueForKey:@"delegate"];
    
    self.tableView.delegate = delegate;
    _delegate = delegate;
    [self.tableView reloadData];
    
    [self didChangeValueForKey:@"delegate"];
}

-(void) refreshData:(NSNotification *)note
{
    if ([TokenManager sharedManager].token == nil)
    {
        [self showRequestTokenAlert];
    } else {
        [TweetManager asynchronousUpdateWithCompletion:^(NSError* error) {
            if(error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't connect to server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)dropViewDidBeginRefreshing:(UIRefreshControl *)refreshControl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [TokenManager requestToken];
        
        if (refreshControl!=nil) {
            [refreshControl endRefreshing];
        }
    });
}


-(void)showRequestTokenAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Token Agent" message:@"Retrieve an access token?" delegate:self cancelButtonTitle:@"NO " otherButtonTitles:@"YES",nil];
    [alert show];
    
    [TweetManager clearTweets];
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [TokenManager requestToken];
    }
}

@end
