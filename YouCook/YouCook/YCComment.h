//
//  YCComment.h
//  YouCook
//
//  Created by Jon Woodhead on 14/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCComment : NSObject
@property (nonatomic,strong)NSString* id;
@property (nonatomic,strong) NSString* user;
@property (nonatomic,strong) NSString* body;
@property (nonatomic,strong) NSDate* date;

-(void)setDateFromString:(NSString*)dateString;
-(NSString*)getDateString;

@end
