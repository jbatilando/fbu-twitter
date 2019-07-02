//
//  ComposeViewController.h
//  twitter
//
//  Created by Miguel Batilando on 6/9/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: Protocol
@protocol ComposeViewControllerDelegate
// MARK: Methods
- (void)didTweet:(Tweet *)tweet;

@end

// MARK: Interface
@interface ComposeViewController : UIViewController
// MARK: Properties
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *replyToTweet;
@end

NS_ASSUME_NONNULL_END
