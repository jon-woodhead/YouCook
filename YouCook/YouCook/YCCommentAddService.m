//
//  YCCommentAddService.m
//  YouCook
//
//  Created by Jon Woodhead on 15/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCCommentAddService.h"
@interface YCCommentAddService (){
    YCRecipe *_recipe;
     YCComment *_comment;
    
}
@end

@implementation YCCommentAddService

-(void)submitComment:(YCComment *)comment forRecipe:(YCRecipe*)recipe completionBlock:(SubmitServiceBlock)block{
    self.completionBlock = block;
    _recipe = recipe;
    _comment = comment;
    NSString *ID = recipe.ID ;
    if (! recipe.title){
        [self finish];
        return;
    }
    NSString *user = [self stringForWebService:comment.user];
    
    NSString *body = [self stringForWebService:comment.body];
    
    NSString *date = [comment getDateString];
    
    NSString *totalPath = [NSString stringWithFormat:@"%@ycAddComment.php?recipe=%@&user=%@&date=%@&body=%@",[YCAbstractNetworkService webServiceAddress],ID,user,date,body];
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
        _comment.id = [NSString stringWithString:self.currentString ];
    }
}

-(void)finish{
    if (self.isSuccess) [_recipe addComment:_comment];
    if (_completionBlock){
        _completionBlock(self.isSuccess);
    }
    _completionBlock = nil;
}



@end
