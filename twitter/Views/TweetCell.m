//
//  TweetCell.m
//  twitter
//
//  Created by addisonz on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePic addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePic setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        UIImage *unlikedImage = [UIImage imageNamed:@"favor-icon-1"];
        [self.likeButton setImage:unlikedImage forState:UIControlStateNormal];;
        
    } else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red-1"];
        [self.likeButton setImage:likedImage forState:UIControlStateNormal];
    }
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"😎😎😎 Successfully favorite/unfavorite");
        } else {
            NSLog(@"😫😫😫 Error favorite/unfavorite: %@", error.localizedDescription);
        }
    }];
    self.likeCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}

- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        UIImage *unretweetImage = [UIImage imageNamed:@"retweet-icon-1"];
        [self.retweetButton setImage:unretweetImage forState:UIControlStateNormal];
        
    } else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        UIImage *retweetImage = [UIImage imageNamed:@"retweet-icon-green-1"];
        [self.retweetButton setImage:retweetImage forState:UIControlStateNormal];
    }
    
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"😎😎😎 Successfully favorite/unfavorite");
        } else {
            NSLog(@"😫😫😫 Error favorite/unfavorite: %@", error.localizedDescription);
        }
    }];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    // TODO: Call method on delegate
    [self.delegate tweetCell:self didTap:self.tweet.user];

}


@end
