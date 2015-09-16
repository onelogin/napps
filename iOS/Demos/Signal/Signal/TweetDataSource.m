//
//  TweetDataSource.m
//  Signal
//
//  Copyright (c) 2015 OneLogin, Inc. All rights reserved.
//

#import "TweetDataSource.h"

#import "TweetCell.h"

#import "TweetManager.h"
#import "ImageManager.h"

@implementation TweetDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [TweetManager sharedManager].tweets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *tweetsection = [[[TweetManager sharedManager].tweets objectAtIndex:section] valueForKey:@"list"];
    
    return tweetsection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@",[[[[TweetManager sharedManager].tweets objectAtIndex:section] valueForKey:@"search_term"] uppercaseString]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *tweetsection = [[[TweetManager sharedManager].tweets objectAtIndex:indexPath.section] valueForKey:@"list"];
    
    NSDictionary *object = [tweetsection objectAtIndex:indexPath.row];
    
    if (cell == nil)
    {
        cell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.numberOfLines = 0;
    
    NSArray *datearray = [[object objectForKey:@"date"] componentsSeparatedByString:@" "];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@ %@\n%@", [datearray objectAtIndex:1],[datearray objectAtIndex:2],[datearray objectAtIndex:5],[datearray objectAtIndex:3 ],[object objectForKey:@"text"]];
    
    cell.textLabel.text = text;
    
    cell.imageView.image = [UIImage imageNamed:@"profile"];
    
    NSURL *profile_url = [[NSURL alloc] initWithString:[object objectForKey:@"picture_url"]];
    
    // download the image asynchronously
    [ImageManager downloadImageWithURL:profile_url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded)
        {
            // change the image in the cell
            cell.imageView.image = image;
            
            // cache the image for use later (when scrolling up)
            cell.imageView.image = image;
        }
    }];
    
    cell.detailTextLabel.text = [object objectForKey:@"user_name"];
    return cell;
}

@end
