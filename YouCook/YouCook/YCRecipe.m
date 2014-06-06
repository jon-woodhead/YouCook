//
//  YCRecipe.m
//  YouCook
//
//  Created by Jon Woodhead on 15/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCRecipe.h"
#import "YCImageUploadService.h"

@implementation YCRecipe

- (id)init
{
    self = [super init];
    if (self) {
        self.ingredients = [NSMutableArray new];
    }
    return self;
}

-(NSString*)description{
    
    return [NSString stringWithFormat:@"YCRecipe %@ %@",self.ID,self.title];
}

-(void)makeURL{
    int random = arc4random() % 9999;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    self.photoURL = [NSString stringWithFormat:@"%@%i",dateString,random];
    
}
-(UIImage*)photo{
    if (! _photoURL || [_photoURL isEqualToString:@"-1"]) return [UIImage imageNamed:@"Logo200.jpg"];
    
    if (_photo) return _photo;
    //ToDo consider putting this on a background string 
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@.jpg",[YCImageUploadService baseUploadURL],_photoURL]];
   NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    if (imageData){
        _photo = [UIImage imageWithData:imageData];
        return _photo;
    }
    return nil;
}


-(void)addComment:(YCComment*)comment{
    if (! _comments) {
        //this is unexpected
        NSLog(@"WARNING - comment being added where no comments exist");
        _comments = @[comment];
        return;
    }
    NSMutableArray *mComments = [_comments mutableCopy];
    [mComments addObject:comment];
    _comments = [NSArray arrayWithArray:mComments];
    
}
@end
