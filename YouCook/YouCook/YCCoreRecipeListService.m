//
//  YCCoreRecipeListService.m
//  YouCook
//
//  Created by Jon Woodhead on 18/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCCoreRecipeListService.h"

@interface YCCoreRecipeListService (){
    YCRecipe *_currentRecipe;
   
   
}
@end


@implementation YCCoreRecipeListService




-(void)cancel{
    [super cancel];
    self.completionBlock = nil;
}

-(void)processResults:(NSData*)data{
          _recipes = [NSMutableArray new];
    [super processResults:data];
   
}

-(void)finish{
    if (_completionBlock){
        _completionBlock(self.isSuccess, self.recipes);
    }
    _completionBlock = nil;
}

# pragma mark XML Parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName   namespaceURI:(NSString *)namespaceURI  qualifiedName:(NSString *)qualifiedName     attributes:(NSDictionary *)attributeDict
{
    self.currentString = @"";
    if ([elementName isEqualToString:@"recipe"]){
        _currentRecipe = [YCRecipe new];
        [_recipes addObject:_currentRecipe];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.currentString = [self.currentString stringByAppendingString:string];
    
}

- (void)parser:(NSXMLParser *)parser  didEndElement:(NSString *)elementName   namespaceURI:(NSString *)namespaceURI  qualifiedName:(NSString *)qName
{
    
    if([elementName isEqualToString:@"OK"]) {
        self.isSuccess = [ self.currentString isEqualToString:@"YES"];
    }
    if([elementName isEqualToString:@"id"]) {
        _currentRecipe.ID = [NSString stringWithString:self.currentString ];
    }
    if([elementName isEqualToString:@"title"]) {
        _currentRecipe.title = [NSString stringWithString:[self.currentString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    if([elementName isEqualToString:@"outline"]) {
        _currentRecipe.outline = [NSString stringWithString:[self.currentString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    if([elementName isEqualToString:@"photo"]) {
        _currentRecipe.photoURL = [NSString stringWithString:self.currentString ];
    }
    if([elementName isEqualToString:@"ingredient"]) {
        [_currentRecipe.ingredients addObject: [NSString stringWithString:[self.currentString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    }
    if([elementName isEqualToString:@"instructions"]) {
        _currentRecipe.instructions = [NSString stringWithString:[self.currentString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    if([elementName isEqualToString:@"chef"]) {
        _currentRecipe.chef = [NSString stringWithString:[self.currentString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    if([elementName isEqualToString:@"chefCode"]) {
        _currentRecipe.chefCode = [NSString stringWithString:self.currentString ];
    }
    
}

@end
