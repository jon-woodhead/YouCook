//
//  YCSubmitVCTests.m
//  YouCook
//
//  Created by Jon Woodhead on 22/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "YCRecipe.h"
#import "YCSubmitVC.h"
#import "YCRecipeVC.h"
#import "YCIngredientCell.h"
#import "YCAppDelegate.h"

@interface YCSubmitVCTests : XCTestCase@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong)  YCSubmitVC *submitVC;
@end


@implementation YCSubmitVCTests

- (void)setUp
{
    [super setUp];
    YCAppDelegate *appDel = (YCAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIWindow *window = appDel.window;
    self.navController = [UINavigationController new];
    window.rootViewController = self.navController;
    self.submitVC = [YCSubmitVC new];
    [self.navController pushViewController:self.submitVC animated:NO];
    //wait a short time to allow the view to load
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSettingRecipe
{
    YCRecipe *recipe = [self recipe1];
    [self.submitVC setRecipe:recipe];
     XCTAssertTrue (([self.submitVC.chef.text isEqualToString:recipe.chef]), @"chef is %@ should be %@",self.submitVC.chef.text,recipe.chef);
    XCTAssertTrue (([self.submitVC.recipeTitle.text isEqualToString:recipe.title]), @"title is %@ should be %@",self.submitVC.recipeTitle.text,recipe.title);
    XCTAssertTrue (([self.submitVC.outline.text isEqualToString:recipe.outline]), @"outline is %@ should be %@",self.submitVC.outline.text,recipe.outline);
    
    UITableView  *ingredientTable = _submitVC.ingredients;
    YCIngredientCell *cell = (YCIngredientCell*)[ingredientTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *cellTitle = cell.title.text;
    NSString *expectedTitle = recipe.ingredients[1];
    XCTAssertTrue (([cellTitle isEqualToString:expectedTitle]), @"cell title is %@ should be %@",cellTitle,expectedTitle);


}




-(void)testCanAddIngredient{
    YCRecipe *recipe = [self recipe1];
    [self.submitVC setRecipe:recipe];
    NSUInteger beforeIngredientCount = self.submitVC.recipe.ingredients.count;
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:beforeIngredientCount-1 inSection:0];
    [self.submitVC tableView:self.submitVC.ingredients commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:lastRow];
    NSUInteger afterIngredientCount = self.submitVC.recipe.ingredients.count;
    XCTAssert(afterIngredientCount = beforeIngredientCount + 1, @"Adding an ingredient does not increase the number of ingredients.");
}
-(void)testCanRemoveIngredient{
    YCRecipe *recipe = [self recipe1];
    [self.submitVC setRecipe:recipe];
    NSUInteger beforeIngredientCount = self.submitVC.recipe.ingredients.count;
    NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.submitVC tableView:self.submitVC.ingredients commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:firstRow];
    NSUInteger afterIngredientCount = self.submitVC.recipe.ingredients.count;
    XCTAssert(afterIngredientCount = beforeIngredientCount - 1, @"Deleting the first ingredient does not decrease the number of ingredients.");
}
-(void)testCallingSubmitUpdatesPropertiesOfRecipe{
    //ToDo consider how to prevent this submitting  OC Mock the submit service?
    YCRecipe *recipe = [self recipe1];
    NSString *testString = @"Test Recipe Delete";
    [self.submitVC setRecipe:recipe];
    self.submitVC.recipeTitle.text = testString;
    [self.submitVC submit:nil];
     XCTAssertTrue (([recipe.title isEqualToString:testString]), @"recipe title is %@ after submission. It should have updated to %@",recipe.title,testString);
}
- (void)testPreview{
    [self.submitVC preview:nil];
    XCTAssert([[self.navController.viewControllers lastObject] isKindOfClass:[YCRecipeVC class]], @"Recipe VC not opened when preview pressed");
}
-(void)testSubmitTriggersAlerts{
    YCRecipe *recipe = [self emptyRecipe];
    self.submitVC.recipe = recipe;
     [self.submitVC submit:nil];
    XCTAssertNotNil (_submitVC.alert, @"alert not shown when recipe title is not set");
    
}
-(void)testSubmitAlertOKFiresSubmitAction{
    id mock = [OCMockObject partialMockForObject:self.submitVC];
    [[mock expect] actionSubmit];
    [self.submitVC alertView:nil didDismissWithButtonIndex:1];
    [mock verify];
}

-(void)testSubmitActionCallsService{
    id mock = (id)[OCMockObject mockForClass:[YCSubmitRecipeService class]];
    self.submitVC.dataService = mock;
    YCRecipe *recipe = [self recipe1];
    self.submitVC.recipe = recipe;
    [[mock expect] submitRecipe:recipe completionBlock:OCMOCK_ANY];
    [self.submitVC actionSubmit];
    [mock verify];

}
-(YCRecipe*)recipe1{
    YCRecipe *recipe = [YCRecipe new];
    recipe.ID = @"1";
    recipe.title = @"Test Recipe 1";
    recipe.outline = @"The outline of recipe 1";
    recipe.ingredients = [@[@"ingredient 1",@"ingredient 2",@"ingredient 3",@"ingredient 4",@"ingredient 5"] mutableCopy];
    recipe.instructions = @"These are the instructions for recipe 1.\n I hope they are OK";
    recipe.chef = @"cheffy";
    return recipe;
}
-(YCRecipe*)emptyRecipe{
    YCRecipe *recipe = [YCRecipe new];
    recipe.ID = @"1";
    recipe.title = @"";
    recipe.outline = @"The outline of recipe 1";
    recipe.ingredients = [@[@"ingredient 1",@"ingredient 2",@"ingredient 3",@"ingredient 4",@"ingredient 5"] mutableCopy];
    recipe.instructions = @"These are the instructions for recipe 1.\n I hope they are OK";
    recipe.chef = @"cheffy";
    return recipe;
}

@end
