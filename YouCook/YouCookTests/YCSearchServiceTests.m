//
//  YCSearchServiceTests.m
//  YouCook
//
//  Created by Jon Woodhead on 30/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YCSearchService.h"

@interface YCSearchServiceTests : XCTestCase

@end

@implementation YCSearchServiceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProcessingSearchResults
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"exampleSearchResults" ofType:@""];
    NSData *testData = [NSData dataWithContentsOfFile:filePath];
    YCSearchService *service = [YCSearchService new];
    [service processResults:testData];
    NSArray *results = service.recipes;
    YCRecipe *recipe = results[0];
    XCTAssertTrue (([recipe.ID isEqualToString:@"1"]), @"recipe id is %@ should be 1",recipe.ID);
}
- (void)testProcessingAndSortingSearchResults
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"exampleSearchResults" ofType:@""];
    NSData *testData = [NSData dataWithContentsOfFile:filePath];
    YCSearchService *service = [YCSearchService new];
    service.searchTerms = @[@"onion"];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //normally we would send a semaphore dispatch_semaphore_signal(0) in the completion block
    //but here the completion block runs on the main thread which is blocked.
    //so instead of waiting for DISPATCH_WAIT_FOREVER we just wait "long enough"
    //and then test
    service.completionBlock = nil;
    [service processResults:testData];
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (1 * NSEC_PER_SEC)));
    NSArray *results = service.recipes;
    YCRecipe *recipe = results[0];
    XCTAssertTrue (([recipe.ID isEqualToString:@"47"]), @"recipe id is %@ should be 47",recipe.ID);
}

@end
