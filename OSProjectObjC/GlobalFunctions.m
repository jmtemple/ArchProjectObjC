//
//  GlobalFunctions.m
//  PatakaApp
//
//  Created by Louis Daudet on 9/3/17.
//  Copyright © 2017 Contect. All rights reserved.
//

#import "GlobalFunctions.h"
#import "GlobalVars.h"

@implementation GlobalFunctions

NSString* convertDateToString(NSDate* date) {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString* dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

NSDate* convertStringToDate(NSString* dateString) {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    return date;
}

NSString* getFullPathForComponent(NSString* component) {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    GlobalVars* gVars = [GlobalVars sharedInstance];
    
    NSString* fullPath = [gVars.documentDirectoryPath stringByAppendingPathComponent:component];
    
    return fullPath;
}

@end
