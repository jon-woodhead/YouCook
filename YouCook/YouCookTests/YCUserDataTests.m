//
//  YCUserDataTests.m
//  YouCook
//
//  Created by Jon Woodhead on 18/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YCUserData.h"

@interface YCUserDataTests : XCTestCase
@property (nonatomic,strong) YCUserData *userData;
@end

@implementation YCUserDataTests

- (void)setUp
{
    [super setUp];
    _userData = [YCUserData new];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
     [self.userData clearAllSavedRecipes];
}

- (void)testSaveUnsave
{
    [self.userData clearAllSavedRecipes];
    XCTAssertTrue ((self.userData.savedRecipeIDs.count == 0), @"clearAllSavedRecipes failed to empty saved recipe array");
    [self.userData saveRecipeID:@"1"];
    XCTAssertTrue ((self.userData.savedRecipeIDs.count == 1), @"saving a recipeID to an array failed");
    XCTAssertTrue ([self.userData isItASavedRecipeID:@"1"], @"saving a recipeID 1 did not save that ID");
    [self.userData unsaveRecipeID:@"1"];
     XCTAssertFalse ([self.userData isItASavedRecipeID:@"1"], @"unsaving a recipeID 1 did not remove that ID");

}

@end
