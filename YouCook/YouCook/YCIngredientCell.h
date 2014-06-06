//
//  YCIngredientCell.h
//  YouCook
//
//  Created by Jon Woodhead on 15/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * @class YCIngredientCell
 * @author Jon Woodhead
 * @date 01/05/2014
 * @version 1.0
 *  @discussion The TableViewCell used in the ingredients table evrywhere where it isn't editable
 */

@interface YCIngredientCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel* title;
-(void)displayDataForIngredient:(NSString*)ingredient;
@end
