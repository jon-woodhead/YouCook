//
//  YCComment.m
//  YouCook
//
//  Created by Jon Woodhead on 14/05/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCComment.h"

@implementation YCComment

-(void)setDateFromString:(NSString*)dateString{
   NSDateFormatter *dateFormatter = [self dateFormatter];self.date  = [dateFormatter dateFromString:dateString];
}

-(NSString*)getDateString{
    NSDateFormatter *dateFormatter = [self dateFormatter];
   
    NSString *strDate = [dateFormatter stringFromDate:self.date];
    return strDate;
}

-(NSDateFormatter*) dateFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    return dateFormatter;

}
@end
