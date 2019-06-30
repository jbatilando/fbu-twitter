//
//  ComposeViewController.m
//  twitter
//
//  Created by Miguel Batilando on 6/9/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *tweetCharacterCountLeft;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweetTextView.delegate = self;
    [self.tweetCharacterCountLeft setText:[NSString stringWithFormat:@"%d", 280]];
}

// MARK: Methods
// Keep track of the number of characters the user has left
- (void)textViewDidChange:(UITextView *)textView {
    // Length of tweet can't exceed 280 characters
    NSInteger restrictedLength = 280;
    NSString *tweetText = self.tweetTextView.text;
    NSInteger lengthLeft = 280 - [[self.tweetTextView text] length];
    [self.tweetCharacterCountLeft setText:[NSString stringWithFormat:@"%ld", (long)lengthLeft]];
    
    if([[self.tweetTextView text] length] > restrictedLength){
        self.tweetTextView.text = [tweetText substringToIndex:[tweetText length] - 1];
    }
}

// MARK: IBActions
- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetButton:(id)sender {
    NSString *str = [self.tweetTextView text];
    
    [[APIManager shared]postStatusWithText:str completion:^(Tweet *tweet, NSError *error) {
        if(error) {
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        } else {
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated: YES completion:nil];
            NSLog(@"Compose Tweet Success!");
        }
        
    }];
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
