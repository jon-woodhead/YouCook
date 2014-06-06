

#import <Foundation/Foundation.h>
#import "YCAbstractNetworkService.h"
#import "YCRecipe.h"

typedef void (^SubmitServiceBlock)(BOOL success);
/**
 * @class YCSubmitRecipeService
 * @author Jon Woodhead
 * @date 18/04/2014
 * @version 1.0
 *  @discussion WebService to submit New or edited Recipes to the Central Database
 */
@interface YCSubmitRecipeService : YCAbstractNetworkService <NSXMLParserDelegate>

@property (nonatomic,copy) SubmitServiceBlock completionBlock;


/** 
 submit a new or edited recipe to the web service
 @param recipe
 @param block block to run on completion
 */
-(void)submitRecipe:(YCRecipe*)recipe completionBlock:(SubmitServiceBlock)block;


@end
