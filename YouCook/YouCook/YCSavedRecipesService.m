//
//  YCSavedRecipesService.m
//  YouCook
//
//  Created by Jon Woodhead on 18/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCSavedRecipesService.h"
#import "YCUserData.h"

@implementation YCSavedRecipesService
-(void)retrieveRecipesWithCompletionBlock:(SearchServiceBlock)block{
    self.completionBlock = block;
    YCUserData *userData = [YCUserData new];
    NSArray *savedIDs = [userData savedRecipeIDs]; //we will use this later when we have the back end
    NSString *savedIDString = [savedIDs  componentsJoinedByString:@","];
    NSString *totalPath = [NSString stringWithFormat:@"%@ycRecipesByID.php?ids=%@",[YCAbstractNetworkService webServiceAddress],[[savedIDString description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [[NSURL alloc] initWithString:totalPath];
    [self startWithUrl:url];
}



@end
