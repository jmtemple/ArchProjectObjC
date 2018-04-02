//
//  GlobalFunctions.h
//  PatakaApp
//
//  Created by Louis Daudet on 9/3/17.
//  Copyright © 2017 Contect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalFunctions : NSObject
NSString* convertDateToString(NSDate* date);
NSDate* convertStringToDate(NSString* dateString);
NSString* getFullPathForComponent(NSString* component);
@end
