//
//  YCCommentTests.m
//  YouCook
//
//  Created by Jon Woodhead on 15/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "YCAppDelegate.h"
#import "YCCommentVC.h"
#import "YCRecipe.h"
#import "YCCommentAddService.h"

@interface YCCommentTests : XCTestCase{
    UIViewController *_rootController;
    YCCommentVC *_commentVC;
}

@end

@implementation YCCommentTests

- (void)setUp
{
    [super setUp];
    YCAppDelegate *appDel = (YCAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIWindow *window = appDel.window;
    _rootController = [UIViewController new];
    window.rootViewController = _rootController;
    _commentVC = [YCCommentVC new];
    [_rootController presentViewController:_commentVC animated:NO completion:nil];
    //wait a short time to allow the view to load
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}
-(void)testCancelClosesVC{
      XCTAssertTrue([_rootController.presentedViewController isKindOfClass:[YCCommentVC class]],@"Test setup did not present the commentVC"  );
    [_commentVC cancel:nil];
    //allow animation to complete
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    XCTAssertNil(_rootController.presentedViewController,@"Cancel did not de-present commentVC");
}
-(void)testAddCommentCallsService{
    id mock = (id)[OCMockObject mockForClass:[YCCommentAddService class]];
    _commentVC.service = mock;
    YCRecipe *recipe = [YCRecipe new];
    _commentVC.recipe = recipe;
    [[mock expect] submitComment:OCMOCK_ANY forRecipe:recipe completionBlock:OCMOCK_ANY];
    [_commentVC addComment:nil];
    [mock verify];
}
@end
