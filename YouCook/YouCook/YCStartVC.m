//
//  YCStartVC.m
//  YouCook
//
//  Created by Jon Woodhead on 14/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCStartVC.h"
#import "YCSearchVC.h"
#import "YCMyRecipesVC.h"
#import "YCSubmitVC.h"
#import "YCUserData.h"


@interface YCStartVC ()

@end

@implementation YCStartVC

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
    UIColor *buttonBG = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    float cornerRadius = 10.0;
    _findBtn.backgroundColor = buttonBG;
     _savedBtn.backgroundColor = buttonBG;
     _submitBtn.backgroundColor = buttonBG;
     [_findBtn.layer setCornerRadius:cornerRadius];
    [_savedBtn.layer setCornerRadius:cornerRadius];
    [_submitBtn.layer setCornerRadius:cornerRadius];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
     [[UINavigationBar appearance] setTintColor: [UIColor colorWithRed:85/255.0 green:129/255.0 blue:85/255.0 alpha:1.0]];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor colorWithRed:85/255.0 green:129/255.0 blue:85/255.0 alpha:1],NSForegroundColorAttributeName,
                                    [UIColor darkGrayColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
   
}
-(void)viewWillAppear:(BOOL)animated{
    YCUserData *userData = [YCUserData new];
    _savedBtn.enabled = [userData areThereSavedRecipes];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)findRecipes:(id)sender{
    YCSearchVC *searchVC = [YCSearchVC new];
   [self.navigationController pushViewController:searchVC animated:YES];
    
}
-(IBAction)openSavedRecipes:(id)sender{
    YCMyRecipesVC *myVC = [YCMyRecipesVC new];
    [self.navigationController pushViewController:myVC animated:YES];
    
}
-(IBAction)submitARecipe:(id)sender{
    YCSubmitVC *submitVC = [YCSubmitVC new];
    [self.navigationController pushViewController:submitVC animated:YES];
    
}
@end
