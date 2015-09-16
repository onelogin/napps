//
//  TweetCell.m
//  Signal
//
//  Copyright (c) 2014 OneLogin, Inc. All rights reserved.
//

#import "TweetCell.h"

@interface TweetCell()

@property (weak,nonatomic) IBOutlet UILabel *date;

@end

@implementation TweetCell

-(void)awakeFromNib {
    self.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
}

@end
