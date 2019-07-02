//
//  TweetProfileViewController.m
//  twitter
//
//  Created by Miguel Batilando on 6/30/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TWeetCell.h"

@interface TweetProfileViewController ()
// MARK: Outlet
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    [self getTimeline];
}

// MARK: Methods
- (void)getTimeline {
    [[APIManager shared] getOtherHomeTimelineWithCompletion:^(User *user, NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweets = (NSMutableArray *)tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

// MARK: Table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    [cell refreshData:tweet];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
