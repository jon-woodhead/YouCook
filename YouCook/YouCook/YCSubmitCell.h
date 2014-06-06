

#import <UIKit/UIKit.h>
#import "YCRecipe.h"

#define kNewIngredient @"New Ingredient"

@class YCSubmitCell;

/**
 * @protocol
 * @author Jon Woodhead
 * @date 09/05/2014
 @discussion This protocol is designed so that the YCSubmitCell 
 can call back to tell its delegate that it is being edited.
 This was done so that we could scroll the ingredients table in YCSubmitVC
 so this cell was visible during editing
 */
@protocol YCSubmitCellDelegate <NSObject>
@required
- (void)cellStartedEditing:(YCSubmitCell*)cell atRow:(NSInteger)row;
- (void)cellEndedEditing:(YCSubmitCell*)cell atRow:(NSInteger)row;
@optional
-(void)cellShouldReturn:(YCSubmitCell*)cell atRow:(NSInteger)row;
@end


/**
 * @class YCSubmitCell
 * @author Jon Woodhead
 * @date 16/04/2014
 * @version 1.0
 *  @discussion The TableViewCell used in the editable ingredients table within YCSubmitVC
 */
@interface YCSubmitCell : UITableViewCell <UITextFieldDelegate>
//dlegate reference to pass data back to the submit view when editing starts and ends
@property (nonatomic,weak) id<YCSubmitCellDelegate> editingDelegate;
///UITextField to hold the text for this ibngredient
@property (nonatomic,strong) IBOutlet UITextField* title;
///The recipe for which we are displaying data
@property (nonatomic,weak)  YCRecipe* recipe;
///The row for which this cell is displaying data
@property   NSInteger row;
/**
 * instruction telling the cell what to display
 * @param recipe YCRecipe object
 * @param row NSInteger of the row of the table.
 */
 
-(void)displayDataForRecipe:(YCRecipe*)recipe onRow:(NSInteger)row;
@end
