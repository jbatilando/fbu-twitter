//
//  TweetProfileViewController.m
//  twitter
//
//  Created by Miguel Batilando on 6/30/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetProfileViewController ()

@end

@implementation TweetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.definesPresentationContext = YES;
    
    // Set profile view with user stats
    [self.posterImageVIew setImageWithURL:[self.user getAvatarURLString]];
    self.posterImageVIew.layer.cornerRadius = 44;
    self.posterImageVIew.layer.masksToBounds = YES;
    [self.bannerImageView setImageWithURL: [self.user getBannerURLString]];
    self.nameLabel.text = self.user.name;
    self.usernameLabel.text = self.user.screenName;
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@",self.user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@",self.user.followingCount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
