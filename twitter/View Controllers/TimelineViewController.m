//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "User.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
// MARK: Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// MARK: Properties
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) User *user;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get user
    [[APIManager shared] getUser:^(User *user, NSError *error) {
        if (user) {
            self.user = (User *)user;
        } else {
            NSLog(@"error getting user: %@", error.localizedDescription);
        }
    }];
    
    // UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    // Get timeline
    [self getTimeline];
    
}

-(void) viewWillAppear {
    // Get user
    [[APIManager shared] getUser:^(User *user, NSError *error) {
        if (user) {
            self.user = (User *)user;
            NSLog(@"Logged in as: %@", self.user.screenName);
            NSLog(@"Hello: %@!", self.user.name);
        } else {
            NSLog(@"error getting user: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    
    // Call method for setting Tweet
    [cell refreshData:tweet];
    
    cell.contentLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    cell.usernameLabel.text = tweet.user.name;
    cell.screennameLabel.text = tweet.user.screenName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getTimeline];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

// MARK: IBActions
- (IBAction)didTapProfileButton:(id)sender {
    [self performSegueWithIdentifier:@"profileSegue" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"composeTweet"]) {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
        DetailsViewController *detailsPostViewController = [segue destinationViewController];
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        detailsPostViewController.tweet = tweet;
    }
    else if ([[segue identifier] isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = self.user;
        profileViewController.tweets = self.tweets;
    }
}



@end
