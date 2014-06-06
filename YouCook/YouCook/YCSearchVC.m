//
//  YCSearchVC.m
//  YouCook
//
//  Created by Jon Woodhead on 14/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCSearchVC.h"
#import "YCSearchService.h"
#import "YCRecipeCell.h"
#import "YCIngredientCell.h"
#import "YCRecipeVC.h"

@interface YCSearchVC (){
    YCSearchService *currentSearchService;
    ADBannerView *bannerView;
}

@end

@implementation YCSearchVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _ingredientTable.allowsSelection = NO;
    
    _showButton = [[UIBarButtonItem alloc] initWithTitle:@"Show Recipe" style:UIBarButtonItemStylePlain target:self action:@selector(showRecipe:)];
    _showButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = _showButton;
    self.activationIndicator.hidden = YES;
    
    //round the corners of the photo
    CALayer * l = [_photo layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:(BOOL)animated];
    [self makeAdvert];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:(BOOL)animated];
    [self killAdvert];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - search
//called when the search bar needs to start a seacrh
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
    [self actionSearch];
    
}
//called when the searchbar abandons a search
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
   
}
-(void)actionSearch{
    if(currentSearchService) [currentSearchService cancel];
    [self.searchBar resignFirstResponder];
    //Prevent another search Being kicked off till this is done
    [self.searchBar setUserInteractionEnabled:NO];
    self.searchBar.alpha = 0.75;
    self.activationIndicator.hidden = NO;
    [self.activationIndicator startAnimating];
    currentSearchService = [YCSearchService new];
    __weak YCSearchVC* weakSelf = self;
    [currentSearchService performSearch:_searchBar.text completionBlock:^(BOOL success, NSArray *results){
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
-(void)reEnableSearchBar{
    [self.searchBar setUserInteractionEnabled:YES];
    self.searchBar.alpha = 1.0;
    [self.activationIndicator stopAnimating];
    self.activationIndicator.hidden = YES;
    
}
-(void)searchFailed{
    currentSearchService = nil;
    [self reEnableSearchBar];
    currentSearchService = nil;
     _alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SEARCH_FAILED_TITLE", @"Search Failed") message:NSLocalizedString(@"SEARCH_FAILED_MESSAGE", @"No Connection") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [_alert show];
}
-(void)resultsLoaded:(NSArray*)results{
    [self killAdvert];
    currentSearchService = nil;
     [self reEnableSearchBar];
    //load the results into the recipeList table
    if (results.count ==0){
         _alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SEARCH_FAILED_TITLE", @"Seach Failed") message:NSLocalizedString(@"SEARCH_NO_RESULTS_MESSAGE", @"No Results") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [_alert show];
    }
    else{
        self.recipes = results;
        [self.recipeTable reloadData];
        [self.recipeTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                      animated:NO
                                scrollPosition:UITableViewScrollPositionTop];
        _currentRecipe = _recipes[0];
        [self displaySelectedRecipe];
        currentSearchService = nil;
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alert = nil;
}
#pragma mark - table delegate calls
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _recipeTable)
        return [self recipeCellForRowAtIndexPath:(NSIndexPath *)indexPath];
    else
        return [self ingredientCellForRowAtIndexPath:(NSIndexPath *)indexPath];
}
        
        
- (UITableViewCell *)  recipeCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RecipeCell";
   static NSString * CellNib = @"YCRecipeCell";
     YCRecipeCell *cell = (YCRecipeCell *)[_recipeTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (YCRecipeCell *)[nib objectAtIndex:0];
       
    }
    NSUInteger row =[indexPath row];
    YCRecipe *rec = _recipes[row];
    [cell displayDataForRecipe:rec];
    
    return cell;
}
- (UITableViewCell *)  ingredientCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"IngredientCell";
    static NSString * CellNib = @"YCIngredientCell";
    YCIngredientCell *cell = (YCIngredientCell *)[_ingredientTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (YCIngredientCell *)[nib objectAtIndex:0];
       
        
    }
    NSUInteger row =[indexPath row];
    NSString *ing = _currentRecipe.ingredients[row];
    [cell displayDataForIngredient:ing];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    _currentRecipe = _recipes[row];
    [self displaySelectedRecipe];
    //the advert may still be in place if we came back to this from the RecipeVC
    //this is a way of getting rid of the advert.
    [self killAdvert];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      if (tableView == _recipeTable)
    return
          _recipes.count;
    else
        return _currentRecipe.ingredients.count;
    
}

#pragma mark - displaySelectedRecipe
-(void)displaySelectedRecipe{
    _showButton.enabled = YES;
    [_ingredientTable reloadData];
    _recipeTitle.text = _currentRecipe.title;
    _outline.text = _currentRecipe.outline;
    _chef.text = [NSString stringWithFormat:@"Recipe by %@",_currentRecipe.chef];
    _photo.image = _currentRecipe.photo;
    }

#pragma mark - navigate on
-(IBAction) showRecipe:(id)sender{
    if (! _currentRecipe) return;
    YCRecipeVC *recipeVC = [YCRecipeVC new];
    [self.navigationController pushViewController:recipeVC animated:YES];
    recipeVC.recipe=_currentRecipe;
}

#pragma mark - adverts
-(void)makeAdvert{
    bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    //bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    bannerView.frame = CGRectMake(0,self.view.bounds.size.height,self.view.bounds.size.width,66);
}
-(void)killAdvert{
    if (bannerView){
        bannerView.delegate = nil;
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect adFrame = bannerView.frame;
                             adFrame.origin.y = self.view.bounds.size.height;
                             bannerView.frame = adFrame;
                         }
                         completion:^(BOOL finished){
                             [bannerView removeFromSuperview];
                             bannerView = nil;
                         }];
    }

}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect adFrame = bannerView.frame;
                         adFrame.origin.y = self.view.bounds.size.height - bannerView.bounds.size.height;
                         bannerView.frame = adFrame;
                     }
                     completion:nil];
    
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
    [bannerView removeFromSuperview];
    bannerView = nil;
}

@end
