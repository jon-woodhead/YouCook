//
//  YCImageUploadService.h
//  YouCook
//
//  Created by Jon Woodhead on 05/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCAbstractNetworkService.h"
#import "YCRecipe.h"
/**
 * @class YCRecipe
 * @author Jon Woodhead
 * @date 05/05/2014
 * @version 1.0
 *  @discussion This service uploads the photo image to the tourbeagle server
 */
@interface YCImageUploadService : NSObject <NSURLSessionTaskDelegate>
@property (nonatomic, copy)  void (^completionBlock)(void);
/**
 * class method to return location where uploads will be based
 * @returns web address. Probably the same as [YCAbstractNetworkService webServiceAddress]
 */
+(NSString*)baseUploadURL;

/**
 * the instruction to upload image data
 * @param data the image in jpg format
 * recipe The associated YCRecipe object which will provide the URL
 */
-(void)uploadImage:(NSData*)data forRecipe:(YCRecipe*)recipe withCompletionBlock:(void(^)(void))block;


@end
