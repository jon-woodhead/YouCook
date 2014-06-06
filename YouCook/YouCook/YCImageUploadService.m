//
//  YCImageUploadService.m
//  YouCook
//
//  Created by Jon Woodhead on 05/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCImageUploadService.h"
@interface YCImageUploadService(){
   
}
@end
@implementation YCImageUploadService

+(NSString*)baseUploadURL{
    return  [YCAbstractNetworkService webServiceAddress];
}

-(void)uploadImage:(NSData*)data forRecipe:(YCRecipe*)recipe withCompletionBlock:(void(^)(void))block{
    self.completionBlock = block;
       NSString *urlPath =  [NSString stringWithFormat:@"%@ipageupload.php",[YCImageUploadService baseUploadURL]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlPath]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"_187934598797439873422234";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"Content-Length %ld\r\n\r\n", (long)[data length] ] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name= userfile\r\n; filename=\"%@.jpg\"\r\n; ",recipe.photoURL] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:data]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%ld", (long)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    
    
    [NSURLConnection sendAsynchronousRequest:request
queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){if (self.completionBlock) self.completionBlock();}];
     
     //  completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){}];
    }




@end
