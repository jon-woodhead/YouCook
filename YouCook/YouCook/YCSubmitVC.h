 

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "YCRecipe.h"
#import "YCUserData.h"
#import "YCSubmitRecipeService.h"
#import "YCSubmitCell.h"

#define kOutlinePlaceholder @"Brief Description"
#define kInstructionsPlaceholder @"Detailed Instructions"

#define kSubmissionsSinceCopyrightWarning @"SubmissionsSince"

/**
 * @class YCSubmitVC
 * @author Jon Woodhead
 * @date 16/04/2014
 * @version 1.0
 *  @discussion The View Controller used when a user wants to enter data for submission as a new or edited recipe
 */
@interface YCSubmitVC : UIViewController <UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, YCSubmitCellDelegate>
///TextField to hold the title
@property (nonatomic,weak) IBOutlet UITextField *recipeTitle;
///TextField to hold the users name
@property (nonatomic,weak) IBOutlet UITextField *chef;
///TextView to hold the outline of the recipe
@property (nonatomic,weak) IBOutlet UITextView *outline;
///Table to hold the ingredients of the recipe
@property (nonatomic,weak) IBOutlet UITableView *ingredients;
///TextView to hold the detailed instructions of the recipe
@property (nonatomic,weak) IBOutlet UITextView *instructions;
///UIImageView to hold the photo that the user has taken of the recipe (if any)
@property (nonatomic,weak) IBOutlet UIImageView *photo;
///UIButton to start the process of taking a photo
@property (nonatomic,weak) IBOutlet UIButton *photoBtn;
///UIButton to submit the recipe to the database
@property (nonatomic,weak) IBOutlet UIButton *submitBtn;
///UIBarButtonItem to preview how the recipe will appear to a user
@property (nonatomic,strong) UIBarButtonItem *previewBtn;
///UIActivityIndicatorView visible during submission
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *ai;
///UIAlert access to this is only required during testing
@property (nonatomic,strong) UIAlertView *alert;
///YCRecipe the recipe object that will be submitted
@property (nonatomic,strong) YCRecipe *recipe;
///flag to indicate that a new photo has been taken and needs uploading
@property   BOOL newPhoto;
/// a userData object to use throughout
@property (nonatomic,strong) YCUserData *userData;
//the data service to submit a recipe
@property (nonatomic,strong) YCSubmitRecipeService *dataService;
/**
 * called when preview button pressed opens the YCRecipe view
 */
-(void)preview:(id)sender;
/**
 * called when submit button pressed . Submits the recipe to the data service
 */
-(IBAction)submit:(id)sender;
/**
 * starts the process for taking a photo
 */
-(IBAction)takePhoto:(id)sender;


//for testing only
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
//for testing only
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
//for testing only
-(void)actionSubmit;
@end
