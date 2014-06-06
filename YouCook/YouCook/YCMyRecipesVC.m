/**
//  YCMyRecipesVC.m
//  YouCook
//
//  Created by Jon Woodhead on 18/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//
 * shows data for saved recipes
 *note that these are not the same thing as recipes submitted by this user!
 */

#import "YCMyRecipesVC.h"
#import "YCSavedRecipesService.h"

@interface YCMyRecipesVC (){
    YCSavedRecipesService *currentSearchService;
}

@end

@implementation YCMyRecipesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"YCSearchVC" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchBar.hidden = YES;
    self.recipeTitle.text = @"Loading your recipes";
    self.outline.text = @"";
    self.recipeTable.alpha = 0;
    [self actionSearch];
}

-(void)viewDidAppear:(BOOL)animated{
    //shift the recipe table so it fits the space available
    //because the search bar is not taking up this space
    //The value of 15 is chosen so that the table seperators align with those on the ingredients table
    CGRect tableFrame = self.recipeTable.frame;
    int shift = tableFrame.origin.y- 80;
    tableFrame.origin.y -= shift;
    tableFrame.size.height +=shift;
    self.recipeTable.frame = tableFrame;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:0
                     animations:^{
                         self.recipeTable.alpha = 1;
                     }
                     completion:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSearch{
   
    currentSearchService = [YCSavedRecipesService new];
    __weak YCMyRecipesVC* weakSelf = self;
    [currentSearchService retrieveRecipesWithCompletionBlock:^(BOOL success, NSArray *results){
        if (success)
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf resultsLoaded:results];
            });
        else
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf searchFailed];
            });
    }];
}
-(void)searchFailed{
    currentSearchService = nil;
     self.alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SAVED_FAILED_TITLE", @"Saved Failed") message:NSLocalizedString(@"SAVED_FAILED_MESSAGE", @"No Connection") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [self.alert show];
    self.recipeTitle.text = @"";
}
-(void)resultsLoaded:(NSArray*)results{
    //load the results into the recipeList table
    if (results.count ==0){
        self.alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SAVED_FAILED_TITLE", @"Saved Failed") message:NSLocalizedString(@"SAVED_NO_RESULTS_MESSAGE", @"No results") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.alert show];
        self.recipeTitle.text = @"";
    }
    else{
        self.recipes = results;
        [self.recipeTable reloadData];
        [self.recipeTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionTop];
        self.currentRecipe = self.recipes[0];
        [self displaySelectedRecipe];
        currentSearchService = nil;
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alert = nil;
}


@end
