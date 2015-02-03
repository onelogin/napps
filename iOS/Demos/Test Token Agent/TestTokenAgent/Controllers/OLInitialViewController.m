//
//  OLInitialViewController.m
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/16/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "OLInitialViewController.h"

#import "OLModel.h"

@implementation OLInitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:[self tableView]];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add App" style:UIBarButtonItemStylePlain target:self action:@selector(addAppButtonPressed)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.title = @"Enabled Apps";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

#pragma mark - Methods

- (void)enabledValueChanged:(id)sender
{
    UISwitch *s = sender;
    
    OLApplication *app = [[[OLModel model] apps] objectAtIndex:s.tag];
    app.enabled = s.on;
    
    [[OLModel model] saveApp:app];
}

- (void)addAppButtonPressed
{
    [self performSegueWithIdentifier:@"AddAppSegue" sender:self];
}

- (void)settingsButtonPressed
{
    [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
}

#pragma mark - Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[OLModel model] apps].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    OLApplication *app = [[[OLModel model] apps] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.scope;
    
    UISwitch *appSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = appSwitch;
    appSwitch.tag = indexPath.row;
    [appSwitch addTarget:self action:@selector(enabledValueChanged:) forControlEvents:UIControlEventValueChanged];
    appSwitch.on = app.enabled;
    
    return cell;
}

#pragma mark - Table View Delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [[OLModel model] deleteApp:[[[OLModel model] apps] objectAtIndex:indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}


@end
