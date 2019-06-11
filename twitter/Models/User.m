//
//  User.m
//  twitter
//
//  Created by Miguel Batilando on 6/9/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.avatarImageURLString = dictionary[@"profile_image_url_https"];
        // Initialize any other properties
    }
    return self;
}

- (NSURL *) getAvatarURLString {
    NSURL *posterURL = [NSURL URLWithString:[self avatarImageURLString]];
    return posterURL;
}

@end
