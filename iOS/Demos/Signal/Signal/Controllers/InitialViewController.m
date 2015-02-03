//
//  InitialViewController.m
//  Signal
//
//  Created by Oscar Swanros on 2/3/15.
//  Copyright (c) 2015 OneLogin. All rights reserved.
//

#import "InitialViewController.h"

#import "AppDelegate.h"
#import "TweetsViewController.h"
#import <OneLoginSDK/OneLogin.h>

typedef NS_ENUM(NSUInteger, SignalState) {
    SignalStateTokenAgentNotFound = 0,
    SignalStateTokenAgentFound
};

@interface InitialViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *successImageView;

@property (nonatomic) SignalState state;
@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)tweetsUpdated
{
    TweetsViewController *tv = [self.storyboard instantiateViewControllerWithIdentifier:@"TweetsViewcontroller"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tv];
    [self presentViewController:navController animated:YES completion:^{
        [self unRegisterForNotifications];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refreshState];
}

- (void)refreshState
{
    [[OneLogin SDK] verifyTokenAgentIsInstalledWithBlock:^(BOOL isInstalled) {
        if (isInstalled) {
            self.state = SignalStateTokenAgentFound;
        }else{
            self.state = SignalStateTokenAgentNotFound;
        }
    }];
}


#pragma mark - Actions

- (IBAction)downloadButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/mx/app/onelogin-mobile/id533508017?mt=8"]];
}


- (IBAction)actionButtonPressed:(id)sender {
    if (_state == SignalStateTokenAgentNotFound) {
        [self refreshState];
    }else{
        [[OneLogin SDK] requestTokenByCheckingIfTokenAgentIsInstalled:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    }
}



#pragma mark - Setters

- (void)setState:(SignalState)state
{
    _state = state;
    
    switch (state) {
        case SignalStateTokenAgentNotFound:
        {
            _downloadButton.alpha = 1;
            _successImageView.alpha = 0;
            [_statusLabel setText:@"Token Agent not found"];
            [_actionButton setTitle:@"Refresh" forState:UIControlStateNormal];
        }
            break;
            
        case SignalStateTokenAgentFound:
        {
            _successImageView.alpha = 1;
            _downloadButton.alpha = 0;
            [_statusLabel setText:@"Token Agent found!"];
            [_actionButton setTitle:@"Continue" forState:UIControlStateNormal];
        }
            break;
    }
}

@end
