

#import <Foundation/Foundation.h>
#import "YCRecipe.h"

#import "YCAbstractNetworkService.h"

//definition of completion block
typedef void (^SearchServiceBlock)(BOOL success, NSArray *results);


/**
 * @class YCCoreRecipeListService
 * @author Jon Woodhead
 * @date 18/04/2014
 * @version 1.0
 *  @discussion The abstract data service that retrieves YCRecipe data and turns it into objects
 */
@interface YCCoreRecipeListService : YCAbstractNetworkService
///completionBlock returns with success and an array of YCRecipe objects
@property (nonatomic,copy) SearchServiceBlock completionBlock;


 
///recipes the array of rYCRecipe objects found
@property (nonatomic,strong) NSMutableArray *recipes;



@end
