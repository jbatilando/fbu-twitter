//
//  ProfileViewController.m
//  twitter
//
//  Created by Miguel Batilando on 6/19/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TWeetCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
// MARK: Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get user
    [[APIManager shared] getUser:^(User *user, NSError *error) {
        if (user) {
            self.user = (User *)user;
            NSLog(@"%@", self.user.name);
            // Set profile view with user stats
            [self.avatarImageView setImageWithURL: [self.user getAvatarURLString]];
            self.avatarImageView.layer.cornerRadius = 44;
            self.avatarImageView.layer.masksToBounds = YES;
            [self.bannerImageView setImageWithURL: [self.user getBannerURLString]];
            self.usernameLabel.text = self.user.name;
            self.screennameLabel.text = self.user.screenName;
            self.followersCountLabel.text = [NSString stringWithFormat:@"%@",self.user.followersCount];
            self.followingCountLabel.text = [NSString stringWithFormat:@"%@",self.user.followingCount];
            [self getTimeline];
        } else {
            NSLog(@"error getting user: %@", error.localizedDescription);
        }
    }];
    
    // UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
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

// MARK: Methods
- (void)getTimeline {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweets = (NSMutableArray *)tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getTimeline];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

// MARK: IBActions
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
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
