//
//  OLAddAppViewController.m
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/19/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "OLAddAppViewController.h"

#import "OLModel.h"

@interface OLAddAppViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *appScopeTextField;
@property (nonatomic, strong) UITextField *appNameTextField;
@end

@implementation OLAddAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[self tableView]];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveApp)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma Methods

- (void)saveApp
{
    if ([_appNameTextField.text length] > 0 && [_appScopeTextField.text length] > 0) {
        OLApplication *newApp = [[OLApplication alloc] init];
        newApp.scope = _appScopeTextField.text;
        newApp.name = _appNameTextField.text;
        newApp.enabled = NO;
        
        [[OLModel model] addApp:newApp withBlock:^(BOOL success) {
            if (success) [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An App must have a Name and a URI defined" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark -
#pragma Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    
    return _tableView;
}

- (UITextField *)appURITextField
{
    if (!_appScopeTextField) {
        _appScopeTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 225, 44)];
        _appScopeTextField.placeholder = @"URL Scheme";
        _appScopeTextField.textAlignment = NSTextAlignmentRight;
        _appScopeTextField.delegate = self;
        _appNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    return _appScopeTextField;
}

- (UITextField *)appNameTextField
{
    if (!_appNameTextField) {
        _appNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 225, 44)];
        _appNameTextField.placeholder = @"App Name";
        _appNameTextField.textAlignment = NSTextAlignmentRight;
        _appNameTextField.delegate = self;
        _appScopeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    return _appNameTextField;
}

#pragma mark -
#pragma Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"App Name:";
            [cell.contentView addSubview:[self appNameTextField]];
        }
            break;
            
        case 1:
        {
            cell.textLabel.text = @"App Scope (Bundle ID):";
            [cell.contentView addSubview:[self appURITextField]];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark -
#pragma Table View Delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - 
#pragma Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}



@end
