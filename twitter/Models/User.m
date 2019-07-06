//
//  User.m
//  twitter
//
//  Created by addisonz on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        // Initialize any other properties
        self.profilePic = dictionary[@"profile_image_url_https"];
        self.bannerPic = dictionary[@"profile_banner_url"];
        self.followerCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"followers_count"] intValue];
        self.tweetCount = [dictionary[@"statuses_count"] intValue];
        self.userID = dictionary[@"id_str"];
    }
    return self;
}

@end
