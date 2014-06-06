//
//  YCCommentSearchService.h
//  YouCook
//
//  Created by Jon Woodhead on 14/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCCoreRecipeListService.h"
#import "YCComment.h"

@interface YCCommentSearchService : YCCoreRecipeListService
@property(nonatomic,strong)NSMutableArray *comments;
@property(nonatomic,strong)YCComment *currentComment;
/**
 function to start the data retrieval
 @param block the completion block
 */
-(void)retrieveCommentsForRecipe:(NSString*)recipe completionBlock:(SearchServiceBlock)block;
@end
