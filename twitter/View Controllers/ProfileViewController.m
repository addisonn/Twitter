//
//  ProfileViewController.m
//  twitter
//
//  Created by addisonz on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bannerPic;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.nameLabel.text = self.tappedUser.name;
    self.usernameLabel.text = [@"@" stringByAppendingString: self.tappedUser.screenName];
    NSURL *profilePicURL = [NSURL URLWithString:self.tappedUser.profilePic];
    [self.profilePic setImageWithURL:profilePicURL];
    NSURL *bannerURL = [NSURL URLWithString:self.tappedUser.bannerPic];
    [self.bannerPic setImageWithURL:bannerURL];
    self.followerLabel.text = [NSString stringWithFormat:@"%d", self.tappedUser.followerCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%d", self.tappedUser.followingCount];
    self.tweetLabel.text = [NSString stringWithFormat:@"%d", self.tappedUser.tweetCount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end
