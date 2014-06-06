//
//  YCRecipeCell.h
//  YouCook
//
//  Created by Jon Woodhead on 15/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCRecipe.h"
/**
 * @class YCRecipeCell
 * @author Jon Woodhead
 * @date 06/05/2014
 * @version 1.0
 *  @discussion The TableViewCell used in the recipe table in YCSearchVC
 */
@interface YCRecipeCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel* title;
/**
  configure the cell to display according to this recipe
 @param recipe a YCRecipe Object
 */
-(void)displayDataForRecipe:(YCRecipe*)recipe;
@end
