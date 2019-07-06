//
//  TweetViewController.m
//  twitter
//
//  Created by addisonz on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"



@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *isRetweetIcon;
@property (weak, nonatomic) IBOutlet UILabel *isRetweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UITextView *replyText;


@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.replyText.layer.borderWidth = 1.0f;
    self.replyText.layer.borderColor = [[UIColor grayColor] CGColor];

    self.isRetweetIcon.hidden = YES;
    self.isRetweetLabel.hidden = YES;
    
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-1"] forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-1"] forState:UIControlStateNormal];
    
    if(self.tweet.isRetweet) {
        self.isRetweetLabel.text = [self.tweet.retweetedByUser.name stringByAppendingString:@" retweeted"];
        self.isRetweetIcon.hidden = NO;
        self.isRetweetLabel.hidden = NO;
    }
    
    self.nameLabel.text = self.tweet.user.name;
    self.usernameLabel.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.timeLabel.text = self.tweet.createdAtString;
    self.contentLabel.text = self.tweet.text;
    //    cell.replyCount.text = tweet.retweetCount;
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];;
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    if(self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red-1"] forState:UIControlStateNormal];
    }
    if(self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green-1"] forState:UIControlStateNormal];
    }
    NSURL *profilePicURL = [NSURL URLWithString:self.tweet.user.profilePic];
    [self.profilePic setImageWithURL:profilePicURL];
    NSLog(@"%@", self.tweet.idStr);
}

- (IBAction)didTapReply:(id)sender {
    NSString *replyText = [self.replyText text];
    [[APIManager shared] replyToPost:[[self.usernameLabel.text stringByAppendingString:@" "] stringByAppendingString:replyText] post:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"😎😎😎 Successfully replied to post");
        } else {
            NSLog(@"😫😫😫 Error replying to post: %@", error.localizedDescription);
        }
    }];
    
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    // TODO: Call method on delegate
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
