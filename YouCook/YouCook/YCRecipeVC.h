

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "YCRecipe.h"
#import "YCUserData.h"
#import "YCCommentSearchService.h"
#import "YCCommentVC.h"

/**
 * @class YCRecipeVC
 * @author Jon Woodhead
 * @date 15/04/2014
 * @version 1.0
 *  @discussion The view controller that displays full recipe details
 */
@interface YCRecipeVC : UIViewController <UIActionSheetDelegate, YCCommentDelegate>

@property (nonatomic,strong) YCRecipe *recipe;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;


@property (nonatomic,weak) IBOutlet UILabel *recipeChef;

@property (nonatomic,weak) IBOutlet UITextView *outline;

@property (nonatomic,weak) IBOutlet UITableView *ingredientTable;

@property (nonatomic,weak) IBOutlet UIView *column0;

@property (nonatomic,strong)  UIBarButtonItem *saveBtn;

@property (nonatomic,strong)  UIBarButtonItem *editBtn;

@property (nonatomic,strong)  UIBarButtonItem *shareBtn;

@property (nonatomic,strong)  UIBarButtonItem *commentBtn;

@property (nonatomic,weak) IBOutlet UIImageView *photo;

@property (nonatomic,weak) IBOutlet UIImageView *moreArrow;

/**
 a function normally called internally to configure the view once a recipe has been defined and the view is loaded.
 Made available externally only for testing
 */
-(void)configureWithRecipe;

//Mthods called by the bar buttons  access provided for testing purposes
-(void)saveUnsaveRecipe:(id)sender;

-(void)editRecipe:(id)sender;

-(void)share:(id)sender;

-(void)comment:(id)sender;
/**
 * determine whether the save button is selected
 */
-(BOOL)savedButtonSelected;
@end
