//
//  YCUserData.m
//  YouCook
//
//  Created by Jon Woodhead on 18/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCUserData.h"
#import "SSKeychain.h"

#define kSavedRecipeKey  @"savedRecipeKey"

@interface YCUserData(){
   
    //persist in keychain is a way of determining whether this functionality is used permanaently
    //it should be set to YES on release, but can be NO during development
    BOOL persistInKeychain;
}
@end

@implementation YCUserData


#pragma mark - saved recipe functions
-(NSMutableArray*) savedRecipeIDs{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSArray *savedRecipes = [defaults objectForKey:kSavedRecipeKey];
    
    if (savedRecipes)
        _savedRecipeIDs = [savedRecipes mutableCopy];
    else
        _savedRecipeIDs = [NSMutableArray new];
    return _savedRecipeIDs;
}
-(void)saveRecipe:(YCRecipe*)recipe{
    [self saveRecipeID:recipe.ID];
}

-(void)saveRecipeID:(NSString*)recipeID{
    if ([self isItASavedRecipeID:recipeID]) return;
    [[self savedRecipeIDs] addObject:recipeID];
    [self saveRecipesToDefaults];

}


-(void)unsaveRecipe:(YCRecipe*)recipe{
     [self unsaveRecipeID:recipe.ID];
}

-(void)unsaveRecipeID:(NSString*)recipeID{
    [[self savedRecipeIDs] removeObject:recipeID];
     [self saveRecipesToDefaults];
}



-(BOOL)isItASavedRecipe:(YCRecipe*)recipe{
    return [self isItASavedRecipeID:recipe.ID];
}

-(BOOL)isItASavedRecipeID:(NSString*)recipeID{
    NSUInteger index = [[self savedRecipeIDs] indexOfObject:recipeID];
    return (index!=NSNotFound) ;
}

-(void)saveRecipesToDefaults{
    if (!_savedRecipeIDs) return;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedRecipes = [NSArray arrayWithArray:_savedRecipeIDs];
    [defaults setObject:savedRecipes forKey:kSavedRecipeKey];
    [defaults synchronize];
    
}

-(void)clearAllSavedRecipes{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults removeObjectForKey:kSavedRecipeKey];
    [defaults synchronize];
}
-(BOOL)areThereSavedRecipes{
    return [self savedRecipeIDs].count > 0;
}


#pragma mark - The device code UUID

-(BOOL)isThisMyUUID:(NSString*)candidateUUID{
    NSString *myUUID = [self getUUID];
    return [myUUID isEqualToString:candidateUUID];
}


-(NSString*)getUUID{
    //ToDo ensure that persistInKeyChain is set to YES before release
    persistInKeychain = NO;
    if (_UUID) return [_UUID copy];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _UUID = [defaults objectForKey:@"udidKey"];
    if (! _UUID && persistInKeychain){
        NSString *retrieveuuid = [SSKeychain passwordForService:@"com.wcs.youcook" account:@"udid"];
        _UUID = retrieveuuid;
        [defaults setObject:_UUID forKey:@"udidKey"];
        [defaults synchronize];
    }
    
    if (! _UUID){
        [self createUUID];
    }
    return [_UUID copy];
}

-(void)createUUID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CFUUIDRef identifierObject = CFUUIDCreate(kCFAllocatorDefault);
    // Convert the CFUUID to a string
    NSString *identifierString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, identifierObject);
    CFRelease((CFTypeRef) identifierObject);
    _UUID = identifierString;
    
    [defaults setObject:_UUID forKey:@"udidKey"];
    [defaults synchronize];
    if (persistInKeychain) [SSKeychain setPassword:_UUID forService:@"com.wcs.youcook" account:@"udid"];
    
}

@end
