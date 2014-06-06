//
//  YCCommentAddService.h
//  YouCook
//
//  Created by Jon Woodhead on 15/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCAbstractNetworkService.h"
#import "YCComment.h"
#import "YCRecipe.h"

typedef void (^SubmitServiceBlock)(BOOL success);

@interface YCCommentAddService :  YCAbstractNetworkService <NSXMLParserDelegate>

@property (nonatomic,copy) SubmitServiceBlock completionBlock;


/**
 submit a new comment to the web service
 @param comment
 @param block block to run on completion
 */
-(void)submitComment:(YCComment*)comment forRecipe:(YCRecipe*)recipe completionBlock:(SubmitServiceBlock)block;



@end
