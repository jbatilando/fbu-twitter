//
//  DetailsViewController.m
//  twitter
//
//  Created by Miguel Batilando on 6/10/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ComposeViewController.h"

@interface DetailsViewController ()
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.avatarImageView setImageWithURL: [self.tweet.user getAvatarURLString]];
    self.avatarImageView.layer.cornerRadius = 28;
    self.avatarImageView.layer.masksToBounds = YES;
    self.usernameLabel.text = self.tweet.user.name;
    self.screennameLabel.text = self.tweet.user.screenName;
    self.tweetLabel.text = self.tweet.text;
}

// MARK: IBActions
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted) {
        [sender setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
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

- (IBAction)didTapLike:(id)sender {
    if (self.tweet.favorited) {
        [sender setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"replyTweet"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        // composeController.delegate = self;
        composeController.replyToTweet = self.tweet;
    }
}


@end
