//
//  User.h
//  twitter
//
//  Created by Miguel Batilando on 6/9/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// MARK: Properties
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *avatarImageURLString;
@property (strong, nonatomic) NSString *bannerImageUrlString;
@property (assign, nonatomic) NSString *tweetCount;
@property (assign, nonatomic) NSString *followingCount;
@property (assign, nonatomic) NSString *followersCount;

// Instance methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSURL *) getAvatarURLString;
- (NSURL *) getBannerURLString;
@end

NS_ASSUME_NONNULL_END
