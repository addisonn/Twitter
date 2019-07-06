//
//  User.h
//  twitter
//
//  Created by addisonz on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// TODO: Add properties
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profilePic;
@property (strong, nonatomic) NSString *bannerPic;
@property (nonatomic) int followerCount; // Update favorite count label
@property (nonatomic) int followingCount; // Update favorite count label
@property (nonatomic) int tweetCount; // Update favorite count label
@property (strong, nonatomic) NSString *userID;


// TODO: Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
