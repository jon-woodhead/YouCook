//
//  YCAbstractNetworkService.m
//  YouCook
//
//  Created by Jon Woodhead on 02/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCAbstractNetworkService.h"

@implementation YCAbstractNetworkService

+(NSString*)webServiceAddress{
    return @"http://www.tourbeagle.com/YC/";
}

-(void)startWithUrl:(NSURL*)url{
   
    NSURLSession *session = [NSURLSession sharedSession];
    self.task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {
                                        [self processResults:data];
                                    }];
    [self.task resume];
    
}
-(void)cancel{
    [self.task cancel];
}
-(void)processResults:(NSData*)data{
    //You may find this string useful during debugging
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.isSuccess = NO;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    
    [parser setDelegate:self];
    [parser parse];
    
    //sortResults here is a dummy function in case we want to carry out additional processing of the results before finishing
    //we carry it out on a the background thread in case it is cpu intensive
    
    
    [self sortResults];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finish];
    });
    

}

#pragma mark - parser functions

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName   namespaceURI:(NSString *)namespaceURI  qualifiedName:(NSString *)qualifiedName     attributes:(NSDictionary *)attributeDict
{
    self.currentString = @"";
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.currentString = [self.currentString stringByAppendingString:string];
    
}

- (void)parser:(NSXMLParser *)parser  didEndElement:(NSString *)elementName   namespaceURI:(NSString *)namespaceURI  qualifiedName:(NSString *)qName
{
    
    if([elementName isEqualToString:@"OK"]) {
        self.isSuccess = [ _currentString isEqualToString:@"YES"];
    }
    
    
}

-(NSString*)stringForWebService:(NSString*)inputString{
       NSString * escapedQuery = [inputString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return escapedQuery;
}

-(void)sortResults{}
-(void)finish{}
@end
