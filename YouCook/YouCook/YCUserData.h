

#import <Foundation/Foundation.h>
#import "YCRecipe.h"
/**
 * @class YCUserData
 * @author Jon Woodhead
 * @date 18/04/2014
 * @version 1.0
 *  @discussion A place to store and access any specific data the user wishes to persist /nProbably Saved Recipes and The UUID of this device.
 */
@interface YCUserData : NSObject
@property (nonatomic,strong) NSMutableArray *savedRecipeIDs;
@property (nonatomic,strong) NSString *UUID;


/** 
 to add a recipe to the saved list
@param recipe a YCRecipe object
 */
-(void)saveRecipe:(YCRecipe*)recipe;
/** 
 to add a recipe to the saved list
 essentially identical to -(void)saveRecipe:(YCRecipe*)recipe;
 but just providing the ID
 @param recipeID
 */
-(void)saveRecipeID:(NSString*)recipeID;

/** 
 to remove a recipe from the saved list
 @param recipe a YCRecipe object
 */
-(void)unsaveRecipe:(YCRecipe*)recipe;
/** 
 to remove a recipe from the saved list
 essentially identical to -(void)saveRecipe:(YCRecipe*)recipe;
 but just providing the ID
 @param recipeID
 */
-(void)unsaveRecipeID:(NSString*)recipeID;


/** 
 To find out whether a recipe has already been saved
 @param recipe  a YCRecipe object
  @returns if this recipe is saved
 */
-(BOOL)isItASavedRecipe:(YCRecipe*)recipe;
/** 
 To find out whether a recipe has already been saved
  essentially identical to -(BOOL)isItASavedRecipe:(YCRecipe*)recipe;
 but just providing the ID
 @param recipeID
 @returns if this recipe is saved
 
 */
-(BOOL)isItASavedRecipeID:(NSString*)recipeID;
/** 
 return YES if any recipes are currently saved
 @returns whether any recipes are saved
 */
-(BOOL)areThereSavedRecipes;

/**
 * deletes all the existing saved recipes
 * only projected use is during testing
 */
-(void)clearAllSavedRecipes;
/** 
 A UUID specific to this device is saved in the keychain
 This function determines whether the candidate is the same as that saved
 This can be used to determine whether a recipe was originally submitted by me.
 @param candidateUUID
 @returns BOOL
 */
-(BOOL)isThisMyUUID:(NSString*)candidateUUID;
/** 
 A UUID specific to this device is saved in the keychain this reurns the value
 */
-(NSString*)getUUID;
@end
