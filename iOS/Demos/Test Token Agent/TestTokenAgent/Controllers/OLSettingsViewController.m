//
//  OLSettingsViewController.m
//  TestTokenAgent
//
//  Created by Oscar Swanros on 5/28/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "OLSettingsViewController.h"

#import "OLModel.h"

@interface OLSettingsViewController (){
    NSMutableArray *cellsArray;
}

@end

@implementation OLSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:[self tableView]];
    cellsArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

#pragma mark - Getters

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];

    switch (indexPath.row) {
        case 0:
        {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey] == 1000)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"Network not available";
            cell.detailTextLabel.text = @"1000";
        }
            break;
            
        case 1:
        {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey] == 1100)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"IDP did not respond";
            cell.detailTextLabel.text = @"1100";
        }
            break;
            
        case 2:
        {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey] == 1202)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"Failed Sec. Token request";
            cell.detailTextLabel.text = @"1202";
        }
            break;
            
        case 3:
        {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey] == 1203)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"App Info List refresh failed";
            cell.detailTextLabel.text = @"1203";
        }
            break;
            
        case 4:
        {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey] == 1500)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"No (user) session active";
            cell.detailTextLabel.text = @"1500";
        }
            break;
            
        case 5:
        {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey] == 1600)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = @"Device could not be enrolled";
            cell.detailTextLabel.text = @"1600";
        }
            break;
            
            
        default:
            break;
    }
    
    [cellsArray addObject:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.textColor = [UIColor colorWithWhite:0.688 alpha:1.000];
    
    contentLabel.text = @"Select the Token Agent conditions you want to simulate.";
    
    return contentLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kErrorKey];
    }else{
        [[NSUserDefaults standardUserDefaults] setInteger:[selectedCell.detailTextLabel.text integerValue] forKey:kErrorKey];
        
        for (UITableViewCell *cell in cellsArray) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    NSLog(@"%tu", [[NSUserDefaults standardUserDefaults] integerForKey:kErrorKey]);
}

@end
