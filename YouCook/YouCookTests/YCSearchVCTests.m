//
//  YCSearchVCTests.m
//  YouCook
//
//  Created by Jon Woodhead on 15/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <XCTest/XCTest.h>
#import "YCRecipeVC.h"
#import "YCSearchVC.h"
#import "YCIngredientCell.h"
#import "YCRecipeCell.h"
#import "YCAppDelegate.h"

@interface YCSearchVCTests : XCTestCase{

}
@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong)  YCSearchVC *searchVC;
@end

@implementation YCSearchVCTests

- (void)setUp
{
    [super setUp];
   YCAppDelegate *appDel = (YCAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIWindow *window = appDel.window;
    self.navController = [UINavigationController new];
    window.rootViewController = self.navController;
    self.searchVC = [YCSearchVC new];
    [self.navController pushViewController:self.searchVC animated:NO];
    //wait a short time to allow the view to load
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
#pragma mark - Tests at initiation of a search
-(void)testActionSearchEndsExistingAndStartsNewSearchProcess{
    
}
#pragma mark - Tests that test result of a search
-(void)testSearchResultsDisplayedInTable{
    
    NSArray *recipes = @[[self recipe1],[self recipe2]];
    [_searchVC resultsLoaded:recipes];
    UITableView  *recipeTable = _searchVC.recipeTable;
    YCRecipeCell *cell = (YCRecipeCell*)[recipeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *cellTitle = cell.title.text;
    NSString *expectedTitle = [recipes[1] title];
    XCTAssertTrue (([cellTitle isEqualToString:expectedTitle]), @"cell title is %@ should be %@",cellTitle,expectedTitle);
    
}
-(void)testSearchNoResultsShowsAlert{
    NSArray *recipes = [NSArray array];
    [_searchVC resultsLoaded:recipes];
    XCTAssertNotNil (_searchVC.alert, @"alert not shown when no search results");
}
-(void)testSearchFailsShowsAlert{
   
    [_searchVC searchFailed];
    XCTAssertNotNil (_searchVC.alert, @"alert not shown when no search results");
}

#pragma mark - Tests on selection of a recipe
-(void)testSelectingRecipeInitiatesDisplay{
    //ToDo
}
-(void)testDisplayRecipeDoesDisplay{
    self.searchVC.currentRecipe = [self recipe1];
    [self.searchVC displaySelectedRecipe];
    //check the title
    NSString *expectedTitle = [[self recipe1] title];
      XCTAssertTrue (([self.searchVC.recipeTitle.text isEqualToString:expectedTitle]), @"Title is %@ should be %@",self.searchVC.recipeTitle.text,expectedTitle);
    //check the outline
    NSString *expectedOutline = [[self recipe1] outline];
    XCTAssertTrue (([self.searchVC.outline.text isEqualToString:expectedOutline]), @"Outline is %@ should be %@",self.searchVC.outline.text,expectedOutline);
    //check the outline
    NSString *expectedChef = [NSString stringWithFormat:@"Recipe by %@",[[self recipe1] chef]];
    XCTAssertTrue (([self.searchVC.chef.text isEqualToString:expectedChef]), @"chef is %@ should be %@",self.searchVC.chef.text,expectedChef);
   
}

#pragma mark - Tests onward navigation
- (void)testShowRecipeButtonPressedWithNoCurrentRecipe{
   [self.searchVC showRecipe:nil];
    XCTAssertFalse([[self.navController.viewControllers lastObject] isKindOfClass:[YCRecipeVC class]], @"Recipe VC  opened when showRecipe pressed even though no recipe selected");
}
- (void)testShowRecipeButtonPressedWithCurrentRecipe{
    self.searchVC.currentRecipe = [self recipe1];
    [self.searchVC showRecipe:nil];
    XCTAssert([[self.navController.viewControllers lastObject] isKindOfClass:[YCRecipeVC class]], @"Recipe VC not opened when showRecipe pressed");
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
