//
//  TweetCell.m
//  twitter
//
//  Created by Miguel Batilando on 6/9/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// MARK: Methods
-(void)refreshData:(Tweet *)tweet{
    self.tweet = tweet;
    
    // Set properties for Tweet
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.contentLabel.delegate = self;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.tweet.text];
    self.contentLabel.attributedText = str;
    
    self.contentLabel.text = tweet.text;
    
    self.usernameLabel.text = tweet.user.name;
    self.dateLabel.text = tweet.createdAtString;
    self.screennameLabel.text = tweet.user.screenName;
    
    [self.avatarImageView setImageWithURL: [tweet.user getAvatarURLString]];
    self.avatarImageView.layer.cornerRadius = 28;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d",tweet.replyCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
    
    // Update UI based on if tweet if favorited or retweeted
    if (self.tweet.favorited) {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [self.likeButton setSelected:YES];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [self.likeButton setSelected:NO];
    }
    
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [self.retweetButton setSelected:YES];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [self.retweetButton setSelected:NO];
    }

}

/// MARK: TTTAttributedLabel
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
    NSString* textClicked = [label.text substringWithRange:result.range];
    
    //Get the URL and perform further actions
    NSURL* urlClicked = result.URL;
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:urlClicked options:@{} completionHandler:nil];
}

// MARK: IBActions
- (IBAction)didTapFavorite:(UIButton *)sender {
    if (self.tweet.favorited) {
        [sender setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        self.tweet.favoriteCount -= 1;
        self.tweet.favorited = NO;
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                [sender setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                self.tweet = tweet;
            }
        }];
    } else {
        [sender setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        self.tweet.favoriteCount += 1;
        self.tweet.favorited = YES;
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                [sender setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet = tweet;
            }
        }];
    }

}

- (IBAction)didTapRetweet:(UIButton *)sender {
    if (self.tweet.retweeted) {
        [sender setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        self.tweet.retweetCount -= 1;
        self.tweet.retweeted = NO;
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *modifiedTweet, NSError *error) {
            if(error != nil) {
                [sender setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unretweeted tweet: %@", self.tweet.text);
            }
        }];
    } else {
        [sender setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        self.tweet.retweetCount += 1;
         self.tweet.retweeted = YES;
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *modifiedTweet, NSError *error) {
            if(error != nil) {
                [sender setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else {
                 NSLog(@"Successfully unretweeted tweet: %@", self.tweet.text);
            }
        }];
    }
}



@end
