//
//  YCRecipeCell.m
//  YouCook
//
//  Created by Jon Woodhead on 15/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCRecipeCell.h"

@implementation YCRecipeCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)displayDataForRecipe:(YCRecipe*)recipe{
    _title.text = recipe.title;
}
@end
