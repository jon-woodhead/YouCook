

#import <Foundation/Foundation.h>
#import "YCComment.h"




/**
 * @class YCRecipe
 * @author Jon Woodhead
 * @date 15/04/2014
 * @version 1.0
 *  @discussion The data object that holds all relevant data for a recipe
 */

@interface YCRecipe : NSObject
///ID a parameter from the database the unique identifier of the recipe
@property (nonatomic,strong) NSString *ID;
///title The name of the recipe
@property (nonatomic,strong) NSString *title;
///outline - a brief description of the recipe
@property (nonatomic,strong) NSString *outline;
///ingredients an NSArray of NSStrings listing the ingredients
@property (nonatomic,strong) NSMutableArray *ingredients;
///instructions - detailed information about how to cook the recipe
@property (nonatomic,strong) NSString *instructions;
///photoURL the url where the photo for this recipe is stored
@property (nonatomic,strong) NSString *photoURL;
///photo will store the image downloaded from photoURL
@property (nonatomic,strong) UIImage *photo;
///chef is a name for the person who originally submitted the recipe.
@property (nonatomic,strong) NSString *chef;
///chefCode is an encoded reference to the device from which the recipe wwas originally submitted
//it will be used to determine whether the user can edit a recipe, comment on one or share it.
@property (nonatomic,strong) NSString *chefCode;
//a list of comments about this recipe.
@property (nonatomic,strong) NSArray *comments;
///This property is used during the search operation to determine howrelevant a result is to the search terms. It is used for sorting.
//relevance used during Search to determine the relevance to the keywords
@property NSUInteger relevance;

/**
 * create a random value for the photoURL
 */
-(void)makeURL;

/**
 *add a comment to the comment list
 @param comment
 */
-(void)addComment:(YCComment*)comment;
@end
