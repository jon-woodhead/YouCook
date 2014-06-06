//
//  YCStartVCTests.m
//  YouCook
//
//  Created by Jon Woodhead on 14/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YCStartVC.h"
#import "YCSearchVC.h"
#import "YCMyRecipesVC.h"
#import "YCSubmitVC.h"

@interface YCStartVCTests : XCTestCase
@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong)  YCStartVC *startVC;
@end

@implementation YCStartVCTests

- (void)setUp
{
    [super setUp];
    self.navController = [UINavigationController new];
   self.startVC = [YCStartVC new];
    [self.navController pushViewController:self.startVC animated:NO];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


//pressing the find button should open the Search Screen
- (void)testFindButtonPressed{
    [self.startVC findRecipes:nil];
    XCTAssert([[self.navController.viewControllers lastObject] isKindOfClass:[YCSearchVC class]], @"Search VC not opened when findRecipes pressedclass was %@  expected %@",NSStringFromClass([[self.navController.viewControllers lastObject] class]), NSStringFromClass([YCSearchVC class]));
}
//pressing the saved button should open the myRecipes Screen
- (void)testSavedButtonPressed{
    [self.startVC openSavedRecipes:nil];
    //Note that here it was necessary to compare the class names rather than the classes else this test fails for reasone that escape me
        XCTAssert([NSStringFromClass([[self.navController.viewControllers lastObject] class]) isEqualToString:NSStringFromClass([YCMyRecipesVC class])], @"My Recipes VC not opened when findRecipes pressed class was %@  expected %@",NSStringFromClass([[self.navController.viewControllers lastObject] class]), NSStringFromClass([YCMyRecipesVC class]));
}
//pressing the submit button should open the Submit Screen
- (void)testSubmitButtonPressed{
    [self.startVC submitARecipe:nil];
    XCTAssert([[self.navController.viewControllers lastObject] isKindOfClass:[YCSubmitVC class]], @"Submit VC not opened when findRecipes pressedclass was %@  expected %@",NSStringFromClass([[self.navController.viewControllers lastObject] class]), NSStringFromClass([YCSubmitVC class]));

}

@end
