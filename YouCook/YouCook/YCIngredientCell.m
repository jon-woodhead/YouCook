//
//  YCIngredientCell.m
//  YouCook
//
//  Created by Jon Woodhead on 15/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCIngredientCell.h"

@implementation YCIngredientCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

   
}
-(void)displayDataForIngredient:(NSString*)ingredient{
    _title.text = ingredient;
   
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}
@end
