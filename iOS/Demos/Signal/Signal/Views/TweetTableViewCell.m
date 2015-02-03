//
//  TweetTableViewCell.m
//  Signal
//
//  Created by Oscar Swanros on 2/3/15.
//  Copyright (c) 2015 OneLogin. All rights reserved.
//

#import "TweetTableViewCell.h"

#import "OLFoundation.h"

@implementation TweetTableViewCell

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    
    self.textLabel.numberOfLines = 0;
    [OLNetworkImageLoader loadImageAtURL:tweet.pictureUrl toImageView:self.imageView withPlaceHolderImage:nil];
    self.textLabel.text = tweet.text;
}

@end
