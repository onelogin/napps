//
//  NAPPSVerifyViewController.m
//  Signal
//
//  Copyright (c) 2014 OneLogin, Inc. All rights reserved.
//

#import "NAPPSVerifyViewController.h"

#import <OneLoginSDK/OneLogin.h>

@interface NAPPSVerifyViewController ()

@property (nonatomic,weak) IBOutlet UIImageView *agentVerifiedImageView;
@property (nonatomic,weak) IBOutlet UIButton *button;
@property (nonatomic,weak) IBOutlet UIButton *applebutton;
@property (nonatomic,weak) IBOutlet UIButton *refreshbutton;

@property (nonatomic,weak) IBOutlet UILabel *question;

@end

@implementation NAPPSVerifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.applebutton.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkForAgent];
}

-(void)updateForTAAvailability:(BOOL)isTaAvailable {
    self.agentVerifiedImageView.hidden = !isTaAvailable;
    self.button.hidden = !isTaAvailable;
    self.refreshbutton.hidden = isTaAvailable;
    self.applebutton.hidden = isTaAvailable;
    self.question.text = isTaAvailable?@"AGENT FOUND":@"AGENT NOT FOUND";
}

-(void) checkForAgent
{
    /* NAPPS Tutorial:
     * This call verifies that the token agent is installed. Depending on
     * whether NAPPS is in test mode or not, the token agent will either be
     * the OneLogin Mobile Application or the mock token agent (which is used for development and
     * debugging purposes)
     * It is recommended you  disable use of the mock token agent when you are
     * ready to ship your code.
     */
    __weak typeof(self) weakSelf = self;
    [[OneLogin SDK] verifyTokenAgentIsInstalledWithBlock:^(BOOL isInstalled)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             __strong typeof(weakSelf) strongSelf = weakSelf;
             [strongSelf updateForTAAvailability:isInstalled];
         });
     }];
}

-(IBAction)refreshButton:(id)sender
{
    self.question.text = @"";
    
     [self checkForAgent];
}

-(IBAction)continueToNext:(id)sender
{
    UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"mainview"];
    [[UIApplication sharedApplication] keyWindow].rootViewController = v;
}

@end
