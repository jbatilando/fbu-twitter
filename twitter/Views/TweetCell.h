//
//  TweetCell.h
//  twitter
//
//  Created by Miguel Batilando on 6/9/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TTTAttributedLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell <TTTAttributedLabelDelegate>
// MARK: Properties
@property (nonatomic, strong) Tweet *tweet;

// MARK: Outlets
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;


@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

// MARK: Methods
-(void)refreshData:(Tweet *)tweet;
@end

NS_ASSUME_NONNULL_END
