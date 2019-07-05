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
#import "TweetProfileViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
// MARK: Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// MARK: Properties
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) User *user;
@property (nonatomic) BOOL isMoreDataLoading; // Configure retweet button
@property (nonatomic) NSInteger index; // Configure retweet button
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
        } else {
            NSLog(@"error getting user: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = YES;
            // Need to load more
            [self getTimeline];
        }
    }
}

// MARK: Table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    
    // Tap on image
    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCellImage:)];
    [cell.avatarImageView setUserInteractionEnabled:YES];
    [cell.avatarImageView addGestureRecognizer:newTap];
    
    // Set tweet
    [cell refreshData:tweet];
    
    if (cell.tweet.favorited) {
        [cell.likeButton setSelected:YES];
    } else {
        [cell.likeButton setSelected:NO];
    }
    
    if (cell.tweet.retweeted) {
        [cell.retweetButton setSelected:YES];
    } else {
        [cell.retweetButton setSelected:NO];
    }
    
    [cell.avatarImageView setUserInteractionEnabled:YES];

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
            
            for (Tweet *tweet in self.tweets) {
                NSLog(@"%@", tweet.entities);
            }
            
            self.isMoreDataLoading = NO;
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

- (void)didTapCellImage:(id)sender{
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    self.index = indexPath.row;
    [self performSegueWithIdentifier:@"tweetProfileSegue" sender:nil];
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
    else if ([[segue identifier] isEqualToString:@"tweetProfileSegue"]) {
        TweetProfileViewController *profileViewController = [segue destinationViewController];
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[self.index];
        profileViewController.user = tweet.user;
    }
}


@end
