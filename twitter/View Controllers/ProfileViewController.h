//
//  ProfileViewController.h
//  twitter
//
//  Created by addisonz on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *tappedUser;

@end

NS_ASSUME_NONNULL_END