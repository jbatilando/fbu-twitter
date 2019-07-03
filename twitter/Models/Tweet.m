//
//  Tweet.m
//  twitter
//
//  Created by Miguel Batilando on 6/9/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"

@implementation Tweet
// Tweet initializer
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        // is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            // pass the user, and create a new User from this data
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        
        // Setting the properties for the Tweet object
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.replyCount = [dictionary[@"reply_count"] intValue];
        self.entities = dictionary[@"entities"];
        
        if ([NSNull null] != [dictionary objectForKey:@"in_reply_to_status_id"]) {
            self.replyIDString = dictionary[@"in_reply_to_status_id"];
        } else {
            self.replyIDString = @"0";
        }
        
        
        
        // initialize the user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        
        // Pod that creates timeAgo
        NSString *ago = [date timeAgoSinceNow];
        NSLog(@"%@", ago);
        
        // Convert Date to String
        self.createdAtString = ago;
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
