//
//  YCRecipeVCTests.m
//  YouCook
//
//  Created by Jon Woodhead on 18/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YCRecipeVC.h"
#import "YCSubmitVC.h"
#import "YCAppDelegate.h"

@interface YCRecipeVCTests : XCTestCase
@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong)  YCRecipeVC *recipeVC;

@end

@implementation YCRecipeVCTests

- (void)setUp
{
    [super setUp];
    YCAppDelegate *appDel = (YCAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIWindow *window = appDel.window;
    self.navController = [UINavigationController new];
    window.rootViewController = self.navController;
    self.recipeVC = [YCRecipeVC new];
    [self.navController pushViewController:self.recipeVC animated:NO];
    //wait a short time to allow the view to load
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
- (void)testSettingRecipeCausesRecipeToShow
{
    YCRecipe *recipe = [self recipe1];
    self.recipeVC.recipe = recipe;
    XCTAssertTrue([self.recipeVC.title isEqualToString:recipe.title] , @"title is %@ should be %@",self.recipeVC.title,recipe.title);
    XCTAssertTrue([self.recipeVC.outline.text isEqualToString:recipe.outline] , @"outline is %@ should be %@",self.recipeVC.outline.text,recipe.outline);
}
- (void)testSavingRecipeSavesRecipe
{
    YCUserData *user = [YCUserData new];
    YCRecipe *recipe = [self recipe1];
    //to ensure its not already saved
    [user unsaveRecipe:recipe];
    XCTAssertFalse([user isItASavedRecipe:recipe],@"User Failed To UnsaveRecipe");
    self.recipeVC.recipe = recipe;
    [self.recipeVC saveUnsaveRecipe:self.recipeVC.saveBtn];
    //user should have been called and the recipe saved
    XCTAssertTrue([user isItASavedRecipe:recipe],@"User Failed To SaveRecipe");
}
- (void)testUnSavingRecipeUnsavesRecipe
{
    YCUserData *user = [YCUserData new];
    YCRecipe *recipe = [self recipe1];
    //to ensure its not already saved
    [user saveRecipe:recipe];
    XCTAssertTrue([user isItASavedRecipe:recipe],@"User Failed To saveRecipe");
    self.recipeVC.recipe = recipe;
    [self.recipeVC saveUnsaveRecipe:self.recipeVC.saveBtn];
    //user should have been called and the recipe unsaved
    XCTAssertFalse([user isItASavedRecipe:recipe],@"User Failed To UnsaveRecipe");
}
- (void)testSaveUnsaveEffectsButtonState
{
    YCUserData *user = [YCUserData new];
    YCRecipe *recipe = [self recipe1];
    //to ensure its not already saved
    [user saveRecipe:recipe];
    self.recipeVC.recipe = recipe;
    XCTAssertTrue([self.recipeVC savedButtonSelected],@"Save button should be selected");
    [user unsaveRecipe:recipe];
    self.recipeVC.recipe = recipe;
    XCTAssertFalse([self.recipeVC savedButtonSelected],@"Save button not should be selected");
}
- (void)testEditButtonPressed
{
    [self.recipeVC editRecipe:nil];
    XCTAssert([[self.navController.viewControllers lastObject] isKindOfClass:[YCSubmitVC class]], @"Submit VC not opened when edit pressed");

   
}
//ToDo These 2 tests will have to wait a while until I've finished UserData hacking
- (void)testEditButtonHidden
{
    YCUserData *user = [YCUserData new];
    YCRecipe *recipe = [self recipe1];
    recipe.chefCode = [user getUUID];
    self.recipeVC.recipe = recipe;
    NSArray *navButtons =self.recipeVC.navigationItem.rightBarButtonItems;
    XCTAssertTrue([navButtons containsObject:self.recipeVC.editBtn],@"The edit button is not visible even though its my recipe");
    recipe.chefCode = @"-1";
    self.recipeVC.recipe = recipe;
    navButtons =self.recipeVC.navigationItem.rightBarButtonItems;

    XCTAssertFalse([navButtons containsObject:self.recipeVC.editBtn],@"The edit button is visible even though its not my recipe");
}
- (void)testSaveButtonSelected
{
    YCUserData *user = [YCUserData new];
    YCRecipe *recipe = [self recipe1];
    [user saveRecipeID:recipe.ID];
    self.recipeVC.recipe = recipe;
     XCTAssertTrue([self.recipeVC savedButtonSelected],@"The save button is not selected even though this recipe is saved");
     [user unsaveRecipeID:recipe.ID];
    self.recipeVC.recipe = recipe;
    XCTAssertFalse([self.recipeVC savedButtonSelected],@"The save button is selected even though the recipe is not saved");

}
#pragma mark - commenting
-(void)testCommentButtonVisibleIfNotMyRecipe{
      YCRecipe *recipe = [self recipe1];
    recipe.chefCode = @"-1";
    self.recipeVC.recipe = recipe;
    NSArray *navButtons =self.recipeVC.navigationItem.rightBarButtonItems;
    XCTAssertTrue([navButtons containsObject:self.recipeVC.commentBtn],@"The comment button is not visible even though its not my recipe");
   }
-(void)testCommentButtonNotVisibleIfMyRecipe{
    YCUserData *user = [YCUserData new];
    YCRecipe *recipe = [self recipe1];
    recipe.chefCode = [user getUUID];
    self.recipeVC.recipe = recipe;
    NSArray *navButtons =self.recipeVC.navigationItem.rightBarButtonItems;
    XCTAssertFalse([navButtons containsObject:self.recipeVC.commentBtn],@"The comment button is visible even though its my recipe");
    

}
-(void)testPressingCommentButtonOPresentsCommentVC{
    [self.recipeVC comment:nil];
    XCTAssertTrue([self.recipeVC.presentedViewController isKindOfClass:[YCCommentVC class]],@"Pressing the comment button is did not present the commentVC"  );
}

#pragma mark - Helper functions
-(YCRecipe*)recipe1{
    YCRecipe *recipe = [YCRecipe new];
    recipe.ID = @"1";
    recipe.title = @"Test Recipe 1";
    recipe.outline = @"The outline of recipe 1";
    recipe.ingredients = [@[@"ingredient 1",@"ingredient 2"] mutableCopy];
    recipe.instructions = @"These are the instructions for recipe 1.\n I hope they are OK";
    recipe.chef = @"cheffy";
    return recipe;
}
-(YCRecipe*)recipe2{
    YCRecipe *recipe = [YCRecipe new];
    recipe.ID = @"2";
    recipe.title = @"Test Recipe 2";
    recipe.outline = @"The outline of recipe 2";
    recipe.ingredients = [@[@"ingredient 1b",@"ingredient 2b"] mutableCopy];
    recipe.instructions = @"These are the instructions for recipe 2.\n I hope they are OK";
    recipe.chef = @"Petra";
    return recipe;
    
}

@end
