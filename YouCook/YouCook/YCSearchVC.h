

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "YCRecipe.h"
/**
 * @class YCSubmitCell
 * @author Jon Woodhead
 * @date 14/04/2014
 * @version 1.0
 *  @discussion The first screen in the find path where the user enters search terms and sees a
 list of suitable recipes.

 */
@interface YCSearchVC : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ADBannerViewDelegate>
@property (nonatomic,strong) UIBarButtonItem *showButton;
@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activationIndicator;
@property (nonatomic,weak) IBOutlet UITableView *recipeTable;
@property (nonatomic,weak) IBOutlet UITableView *ingredientTable;
@property (nonatomic,weak) IBOutlet UIImageView *photo;
@property (nonatomic,weak) IBOutlet UILabel *recipeTitle;
@property (nonatomic,weak) IBOutlet UILabel *chef;
@property (nonatomic,weak) IBOutlet UITextView *outline;
//alert for when the search fails. This external reference is supplied for testing
@property (nonatomic,strong) UIAlertView *alert;
//When the user selects a recipe from the table it is stored here. The external reference is only for testing
@property (nonatomic,strong) YCRecipe *currentRecipe;
//A list of all the recipes found by the search. This reference is so that tests can set the value
@property (nonatomic,strong) NSArray *recipes;

/** IBAction for the show recipe button
 * @param id the showRecipe button
 */
-(IBAction) showRecipe:(id)sender;
/** to be called when a search failed
 */
-(void)searchFailed;
/** to be called when results are avialable from a search 
 @param results an array of YCRecipe objects
 */
-(void)resultsLoaded:(NSArray*)results;
/*called when a recipe has been selected for display
    expected to be used when a cell is selected in the recipeTable
 */
-(void)displaySelectedRecipe;
@end
