//
//  ViewController.m
//  JSNAPPS
//
//  Created by Troy Simon on 6/23/14.
//  Copyright (c) 2014 Troy Simon. All rights reserved.
//

#import "ViewController.h"
#import <OneLoginSDK/OneLogin.h>

static NSString *const URLScheme = @"JSDEMO"; // This app URL Scheme


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setupWebView];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"sayHello()"];
}

- (void) setupWebView
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"otp_new" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.webView.scrollView.scrollEnabled = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (request.URL.isFileURL)
    {
        return YES;
    }
    else
    {
        if ([request.URL.host isEqualToString:@"send_code"])
        {
            NSLog(@"send_code");
            
            [[OneLogin SDK] requestTokenByCheckingIfTokenAgentIsInstalled:^(NSError *error) {
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error code %tu", error.code] message:[NSString stringWithFormat:@"%@\n%@", error.localizedDescription, error.localizedRecoverySuggestion] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                }
            }];
        }
    }
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
