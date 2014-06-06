
#import <Foundation/Foundation.h>
#import "YCCoreRecipeListService.h"
/**
 * @class YCSavedRecipesService
 * @author Jon Woodhead
 * @date 18/04/2014
 * @version 1.0
 *  @discussion The data service that requests a back end search for recipes based on the ids stored in the user preferences ids and converts the results to an array of YCRecipe objects
 */
@interface YCSavedRecipesService : YCCoreRecipeListService

/**
 function to start the data retrieval
 @param block the completion block
 */
-(void)retrieveRecipesWithCompletionBlock:(SearchServiceBlock)block;
@end
