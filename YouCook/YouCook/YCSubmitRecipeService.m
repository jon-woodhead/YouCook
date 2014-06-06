//
//  YCSubmitRecipeService.m
//  YouCook
//
//  Created by Jon Woodhead on 22/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCSubmitRecipeService.h"
#import "YCUserData.h"
@interface YCSubmitRecipeService (){
    YCRecipe *_recipe;
    
}
@end


@implementation YCSubmitRecipeService


-(void)submitRecipe:(YCRecipe*)recipe completionBlock:(SubmitServiceBlock)block{
        self.completionBlock = block;
    _recipe = recipe;
    NSString *ID = recipe.ID ;
    if (! recipe.title){
       [self finish];
        return;
    }
    NSString *title = [self stringForWebService:recipe.title];
    NSString *outline;
    if (recipe.outline) outline = [self stringForWebService:recipe.outline];
    else outline = [@" " stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *instructions;
    if (recipe.instructions) instructions = [self stringForWebService:recipe.instructions];    else instructions = [@" " stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *photoURL;
    if (recipe.photoURL) photoURL = recipe.photoURL;
    else photoURL = @"-1";
    
    NSString *chef;
    if (recipe.chef) chef = [self stringForWebService:recipe.chef];
    else chef = [@" " stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *chefCode;
    if (recipe.chefCode) chefCode = recipe.chefCode;
    else {
        YCUserData *userData = [YCUserData new];
        chefCode = [userData getUUID];
        recipe.chefCode = chefCode;
    }

    
    NSString *ingredients;
    if (recipe.ingredients){
       ingredients =  [recipe.ingredients componentsJoinedByString:@"^"];
        ingredients = [self stringForWebService:ingredients];
    }
    else ingredients = @"";

    
    NSString *service;
    if (ID){
        service = @"ycEditRecipe";
        ID = recipe.ID;
    }
    else{
        service = @"ycAddRecipe";
        ID = @"-1";
        
    }
    
     NSString *totalPath = [NSString stringWithFormat:@"%@%@.php?ID=%@&title=%@&outline=%@&instructions=%@&chef=%@&chefCode=%@&ingredients=%@&photoURL=%@",[YCAbstractNetworkService webServiceAddress],service,ID,title,outline,instructions,chef,chefCode,ingredients,photoURL];
        NSURL *url = [[NSURL alloc] initWithString:totalPath];
        [self startWithUrl:url];
    
}

-(void)cancel{
    [super cancel];
    self.completionBlock = nil;
}

- (void)parser:(NSXMLParser *)parser  didEndElement:(NSString *)elementName   namespaceURI:(NSString *)namespaceURI  qualifiedName:(NSString *)qName
{
    
    if([elementName isEqualToString:@"OK"]) {
        self.isSuccess = [ self.currentString isEqualToString:@"YES"];
    }
    if([elementName isEqualToString:@"id"]) {
        _recipe.ID = [NSString stringWithString:self.currentString ];
    }
}

-(void)finish{
    if (_completionBlock){
        _completionBlock(self.isSuccess);
    }
    _completionBlock = nil;
}





@end
