//
//  YCCommentSearchService.m
//  YouCook
//
//  Created by Jon Woodhead on 14/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCCommentSearchService.h"

@implementation YCCommentSearchService

-(void)retrieveCommentsForRecipe:(NSString*)recipe completionBlock:(SearchServiceBlock)block{
    self.completionBlock = block;
    
    
    NSString *totalPath = [NSString stringWithFormat:@"%@ycComments.php?r=%@",[YCAbstractNetworkService webServiceAddress],recipe];
    
    NSURL *url = [[NSURL alloc] initWithString:totalPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:  url];
    [request setTimeoutInterval:10];
    //[self startWithRequest:request];
    [self startWithUrl:url];
}


-(void)processResults:(NSData*)data{
    _comments = [NSMutableArray new];
    [super processResults:data];
    
}

-(void)finish{
    if (self.completionBlock){
        self.completionBlock(self.isSuccess, self.comments);
    }
    self.completionBlock = nil;
}

# pragma mark XML Parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName   namespaceURI:(NSString *)namespaceURI  qualifiedName:(NSString *)qualifiedName     attributes:(NSDictionary *)attributeDict
{
    self.currentString = @"";
    if ([elementName isEqualToString:@"comment"]){
        _currentComment = [YCComment new];
        [_comments addObject:_currentComment];
    }
}



- (void)parser:(NSXMLParser *)parser  didEndElement:(NSString *)elementName   namespaceURI:(NSString *)namespaceURI  qualifiedName:(NSString *)qName
{
    
    if([elementName isEqualToString:@"OK"]) {
        self.isSuccess = [ self.currentString isEqualToString:@"YES"];
    }
    if([elementName isEqualToString:@"id"]) {
        _currentComment.id = [NSString stringWithString:self.currentString ];
    }
    if([elementName isEqualToString:@"user"]) {
        _currentComment.user = [NSString stringWithString:[self.currentString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    if([elementName isEqualToString:@"body"]) {
        _currentComment.body = [NSString stringWithString:[self.currentString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    if([elementName isEqualToString:@"date"]) {
        [_currentComment setDateFromString:self.currentString];
    }
    
    
}



//sortResults is called immediately before finish
//to allow us to do additional processing before returning the results
-(void)sortResults{
    
   
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    self.comments = [[self.comments sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}


@end
