//
//  ComposeViewController.m
//  twitter
//
//  Created by addisonz on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeText;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.composeText.layer.borderWidth = 1.0f;
    self.composeText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.composeText.delegate = self;
}

- (IBAction)postTweet:(id)sender {
    NSString *composeText = [self.composeText text];
    NSLog(@"%@", composeText);
    [[APIManager shared] postStatusWithText:composeText completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.delegate didTweet:tweet];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)cancelTweet:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composeText.text stringByReplacingCharactersInRange:range withString:text];

    // The new text should be allowed? True/False
    return newText.length < characterLimit;
};

- (void)textViewDidChange:(UITextView *)textView {
    NSUInteger textlength = 140 - [self.composeText text].length;
    self.characterCount.text = [NSString stringWithFormat:@"%lu", textlength];
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
