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

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set banner and avatar image view
    [self.avatarImageView setImageWithURL: [self.user getAvatarURLString]];
    [self.bannerImageView setImageWithURL: [self.user getBannerURLString]];
    self.usernameLabel.text = self.user.name;
    self.screennameLabel.text = self.user.screenName;
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@",self.user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@",self.user.followingCount];
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
