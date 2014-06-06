//
//  YCCommentVC.m
//  YouCook
//
//  Created by Jon Woodhead on 15/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCCommentVC.h"


@interface YCCommentVC (){
   
}

@end

@implementation YCCommentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mainView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _mainView.layer.borderWidth = 1.0;
    _mainView.layer.cornerRadius = 8;

    _commentText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _commentText.layer.borderWidth = 1.0;
    _commentText.layer.cornerRadius = 8;
   self.addCommentBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)textFieldDidEndEditing:(UITextField *)textField{
    BOOL ready = YES;
    if ([self.username.text isEqualToString:@""]) ready = NO;
     if ([self.commentText.text isEqualToString:@""]) ready = NO;
    self.addCommentBtn.enabled = ready;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.commentText becomeFirstResponder];
    return NO;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.25 delay:0.0 options:0
                     animations:^{
                         CGRect frame = _mainView.frame;
                         frame.origin.y = 0;
                         _mainView.frame = frame;
                     }
                     completion:nil];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    BOOL ready = YES;
    if ([self.username.text isEqualToString:@""]) ready = NO;
    if ([self.commentText.text isEqualToString:@""]) ready = NO;
    self.addCommentBtn.enabled = ready;
    [UIView animateWithDuration:0.25 delay:0.0 options:0
                     animations:^{
                         CGRect frame = _mainView.frame;
                         frame.origin.y = 152;
                         _mainView.frame = frame;
                     }
                     completion:nil];
}

-(IBAction)addComment:(id)sender{
    __weak YCCommentVC *weakSelf = self;
    if (!_service) _service = [YCCommentAddService new];
    YCComment *comment = [YCComment new];
    comment.user = self.username.text;
    comment.date = [NSDate date];
    comment.body = self.commentText.text;
    [_service submitComment:comment forRecipe:self.recipe completionBlock:^(BOOL success){
        if (success)
            [weakSelf cancel:nil];
        else{
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COMMENT_FAILED_TITLE", @"Comment Failed") message:NSLocalizedString(@"COMMENT_FAILED_MESSAGE", @"Comment Failed") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_delegate finishedComment:self];
}
@end
