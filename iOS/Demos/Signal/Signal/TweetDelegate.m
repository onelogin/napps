//
//  TweetDelegate.m
//  Signal
//
//  Created by Joshua Ridenhour on 7/31/15.
//  Copyright (c) 2015 Troy Simon. All rights reserved.
//

#import "TweetDelegate.h"
#import "TweetManager.h"

@implementation TweetDelegate

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    NSArray *tweetsection = [[[TweetManager sharedManager].tweets objectAtIndex:indexPath.section] valueForKey:@"list"];
    
    NSDictionary *object = [tweetsection objectAtIndex:indexPath.row];
    
    NSString *text = [NSString stringWithFormat:@"%@ \n%@", [object objectForKey:@"date"],[object objectForKey:@"text"]];
    
    CGFloat maxWidth = [UIScreen mainScreen].applicationFrame.size.width * 0.70f;
    
    NSAttributedString *attributedText =[[NSAttributedString alloc]
                                         initWithString:text
                                         attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Arial" size:15]}];
    
    CGRect paragraphRect =
    [attributedText boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 context:nil];
    
    return paragraphRect.size.height + 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *tweetsection = [[[TweetManager sharedManager].tweets objectAtIndex:indexPath.section] valueForKey:@"list"];
    
    NSDictionary *object = [tweetsection objectAtIndex:indexPath.row];
    
    NSURL *url;
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://status?id=%@",[object objectForKey:@"tweet_id"]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/AdvOpps/status/%@",[object objectForKey:@"tweet_id"]]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

@end
