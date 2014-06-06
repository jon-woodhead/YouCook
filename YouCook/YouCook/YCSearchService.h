
#import <Foundation/Foundation.h>
#import "YCCoreRecipeListService.h"



/**
 * @class YCSearchService
 * @author Jon Woodhead
 * @date 18/04/2014
 * @version 1.0
 *  @discussion The data service that requests a back end search on keywords and converts the results to an array of YCRecipe objects
 */
@interface YCSearchService : YCCoreRecipeListService 
///searchTerms - an array of the keywords on which the search will be based
@property (nonatomic,strong) NSArray *searchTerms;



/** 
 function to start the searchProcess
 @param keywords space seperated keywords
 @param block the completion block
 */
-(void)performSearch:(NSString*)keywords completionBlock:(SearchServiceBlock)block;



@end
