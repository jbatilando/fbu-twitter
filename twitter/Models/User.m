//
//  User.m
//  twitter
//
//  Created by Miguel Batilando on 6/9/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"
#import "APIManager.h"

@implementation User
// MARK: Instance methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.avatarImageURLString = dictionary[@"profile_image_url_https"];
        self.bannerImageUrlString = dictionary[@"profile_banner_url"];
        self.tweetCount = dictionary[@"statuses_count"];
        self.followingCount = dictionary[@"friends_count"];
        self.followersCount = dictionary[@"followers_count"];
        // Initialize any other properties
    }
    return self;
}

- (NSURL *) getAvatarURLString {
    NSURL *posterURL = [NSURL URLWithString:[self avatarImageURLString]];
    return posterURL;
}

- (NSURL *) getBannerURLString {
    NSURL *bannerURL = [NSURL URLWithString:[self bannerImageUrlString]];
    return bannerURL;
}

@end
