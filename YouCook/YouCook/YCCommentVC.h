//
//  YCCommentVC.h
//  YouCook
//
//  Created by Jon Woodhead on 15/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCRecipe.h"
#import "YCCommentAddService.h"

@class YCCommentVC;

@protocol YCCommentDelegate <NSObject>
@required
- (void)finishedComment:(YCCommentVC*)comment;
@end

@interface YCCommentVC : UIViewController <UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,weak) id<YCCommentDelegate> delegate;
@property (nonatomic,assign) YCRecipe *recipe;
@property (nonatomic,weak) IBOutlet UIView *mainView;
@property (nonatomic,weak) IBOutlet UITextField *username;
@property (nonatomic,weak) IBOutlet UITextView *commentText;
@property (nonatomic,weak) IBOutlet UIButton *addCommentBtn;
//reveal the service here only for testing purposes
@property (nonatomic,strong) YCCommentAddService *service;
-(IBAction)addComment:(id)sender;
-(IBAction)cancel:(id)sender;
@end
