//
//  YCSearchService.m
//  YouCook
//
//  Created by Jon Woodhead on 15/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCSearchService.h"

@interface YCSearchService(){
   
}
@end

@implementation YCSearchService

-(void)performSearch:(NSString*)keywords completionBlock:(SearchServiceBlock)block{
     self.completionBlock = block;
    
    NSString *commaKeywords = [keywords stringByReplacingOccurrencesOfString:@" " withString:@","];
    NSString *singleCommaKeywords = [commaKeywords stringByReplacingOccurrencesOfString:@",," withString:@","];
    self.searchTerms = [singleCommaKeywords componentsSeparatedByString:@","];
    
    NSString *totalPath = [NSString stringWithFormat:@"%@ycRecipeByKeyword.php?keyword=%@",[YCAbstractNetworkService webServiceAddress],[self stringForWebService:singleCommaKeywords]];
     
    NSURL *url = [[NSURL alloc] initWithString:totalPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:  url];
    [request setTimeoutInterval:10];
    //[self startWithRequest:request];
    [self startWithUrl:url];
}

//sortResults is called immediately before finish
//to allow us to do additional processing before returning the results
-(void)sortResults{
    //sort the recipes by their relevance to the searchTerms
    //so count the number of times each search term appears in the title or the ingredients
    //the property relevance was included in YCRecipe for this purpose.
    
    for (YCRecipe *recipe in self.recipes){
        recipe.relevance = 0;
        for (NSString *searchTerm in self.searchTerms){
            NSString *lSearchTerm = [searchTerm lowercaseString];
            if ([[recipe.title lowercaseString] rangeOfString:lSearchTerm].location != NSNotFound)
                recipe.relevance++;
            
            for (NSString *ingredient in recipe.ingredients){
                if ([[ingredient lowercaseString] rangeOfString:lSearchTerm].location != NSNotFound)
                    recipe.relevance++;
                
            }
        }
    }
    
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"relevance" ascending:NO]];
    self.recipes = [[self.recipes sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

@end
