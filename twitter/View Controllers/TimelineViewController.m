//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetViewController.h"
#import "InfiniteScrollActivityView.h"
#import "ProfileViewController.h"


@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TweetCellDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIButton *composeButton;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property InfiniteScrollActivityView* loadingMoreView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // datasource & delegate setup
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isMoreDataLoading = NO;
    
    // styling stuff redundant
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //    self.tableView.estimatedRowHeight = 180;
    
    // API request
    [self fetchTimeline];
    
    // refresh controls
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
}

- (void)fetchTimeline {
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            //            for (Tweet *dictionary in tweets) {
            //                NSString *text = dictionary.text;
            //                NSLog(@"%@", text);
            //            }
            
            // viewcontroller storing data & reload
            self.tweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// set up cell & # of cells

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    
    // set delegate for image
    cell.delegate = self;

    
    // resetting
    cell.isRetweetIcon.hidden = YES;
    cell.retweetLabel.hidden = YES;
    
    [cell.retweetLabel removeConstraints:[cell.retweetLabel constraints]];
    [cell.isRetweetIcon removeConstraints:[cell.retweetLabel constraints]];
    [cell.likeButton setImage:[UIImage imageNamed:@"favor-icon-1"] forState:UIControlStateNormal];
    [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-1"] forState:UIControlStateNormal];

    
    if(tweet.isRetweet) {
        cell.retweetLabel.text = [tweet.retweetedByUser.name stringByAppendingString:@" retweeted"];
        cell.isRetweetIcon.hidden = NO;
        cell.retweetLabel.hidden = NO;
        [cell.retweetLabel addConstraints:[cell.retweetLabel constraints]];
        [cell.isRetweetIcon addConstraints:[cell.retweetLabel constraints]];
    }
    
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = [@"@" stringByAppendingString: tweet.user.screenName];
    cell.timeLabel.text = tweet.timeTillNow;
    cell.contentLabel.text = tweet.text;
//    cell.replyCount.text = tweet.retweetCount;
    cell.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.likeCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    cell.replyCount.text = [NSString stringWithFormat:@"%d", tweet.repliedCount];
    if(tweet.favorited) {
        [cell.likeButton setImage:[UIImage imageNamed:@"favor-icon-red-1"] forState:UIControlStateNormal];
    }
    if(tweet.retweeted) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green-1"] forState:UIControlStateNormal];
    }
    NSURL *profilePicURL = [NSURL URLWithString:tweet.user.profilePic];
    [cell.profilePic setImageWithURL:profilePicURL];
    
    return cell;
    
}

- (IBAction)userLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
    
}

// more complicated dynamic rowheight
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
//    return 140.0 + cell.textLabel.bounds.size.height;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            // ... Code to load more results ...
            Tweet *mostrecent = [self.tweets lastObject];
            [[APIManager shared] moreTimeline:mostrecent.idStr completion:^(NSArray *tweets, NSError *error) {
                if (tweets) {
                    NSLog(@"😎😎😎 Successfully more from home timeline");
                    self.isMoreDataLoading = false;
                    // viewcontroller storing data & reload
                    [self.tweets addObjectsFromArray:[NSMutableArray arrayWithArray:tweets]];
                    [self.loadingMoreView stopAnimating];
                    [self.tableView reloadData];
                    
                } else {
                    NSLog(@"😫😫😫 Error more from homeline: %@", error.localizedDescription);
                }
            }];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"newTweet"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"tweetDeets"]) {
            UITableViewCell *tappedCell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
            Tweet *tappedTweet = self.tweets[indexPath.row];

            TweetViewController *tweetViewController = [segue destinationViewController];
            tweetViewController.tweet = tappedTweet;
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    } else if ([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.tappedUser = sender;
        
    }
}

// delegate for profile pic
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // TODO: Perform segue to profile view controller
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}


// delegate function for compose a tweet
- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}


@end
