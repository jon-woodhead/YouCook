/**
  YCStartVC.h
  YouCook

  Created by Jon Woodhead on 14/04/2014.
  Copyright (c) 2014 Jon Woodhead. All rights reserved.
 
 The start screen steering to add recipe, find recipe or saved recipes
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface YCStartVC : UIViewController
@property (nonatomic,weak) IBOutlet UIButton *savedBtn;
@property (nonatomic,weak) IBOutlet UIButton *submitBtn;
@property (nonatomic,weak) IBOutlet UIButton *findBtn;
/** IBAction for the find button being clicked
 * @param sender  the find button
 */
-(IBAction)findRecipes:(id)sender;

/** IBAction for the saved button being clicked
 * @param sender  the saved button
 */
-(IBAction)openSavedRecipes:(id)sender;

/** IBAction for the submit button being clicked
 * @param sender  the submit button
 */
-(IBAction)submitARecipe:(id)sender;
@end
