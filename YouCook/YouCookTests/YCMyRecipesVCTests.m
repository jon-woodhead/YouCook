//
//  YCMyRecipesVCTests.m
//  YouCook
//
//  Created by Jon Woodhead on 09/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YCAppDelegate.h"
#import "YCMyRecipesVC.h"

@interface YCMyRecipesVCTests : XCTestCase
@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong)  YCMyRecipesVC *savedVC;
@end

@implementation YCMyRecipesVCTests

- (void)setUp
{
    [super setUp];
    YCAppDelegate *appDel = (YCAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIWindow *window = appDel.window;
    self.navController = [UINavigationController new];
    window.rootViewController = self.navController;
    self.savedVC = [YCMyRecipesVC new];
    [self.navController pushViewController:self.savedVC animated:NO];
    //wait a short time to allow the view to load
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
