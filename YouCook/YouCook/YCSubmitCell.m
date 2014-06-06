//
//  YCSubmitCell.m
//  YouCook
//
//  Created by Jon Woodhead on 18/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCSubmitCell.h"

@implementation YCSubmitCell

- (void)awakeFromNib
{
    // Initialization code
    _title.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)displayDataForRecipe:(YCRecipe*)recipe onRow:(NSInteger)row{
    _recipe = recipe;
    _row = row;
    NSString *ingredient = recipe.ingredients[row];
    _title.text = ingredient;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.editingDelegate)[self.editingDelegate cellStartedEditing:self atRow:self.row];
    if ([_title.text isEqualToString:kNewIngredient])
        _title.text = @"";

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _recipe.ingredients[_row] = _title.text;
    if (self.editingDelegate)[self.editingDelegate cellEndedEditing:self atRow:self.row];
    if ([_title.text isEqualToString:@""])
        _title.text = kNewIngredient;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
     if (self.editingDelegate)[self.editingDelegate cellShouldReturn:self atRow:self.row];
   
    return NO;
}

@end
