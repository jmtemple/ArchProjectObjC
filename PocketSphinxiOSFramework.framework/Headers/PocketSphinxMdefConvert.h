//
//  PocketSphinxMdefConvert.h
//  PocketSphinxiOSFramework
//
//  Created by Louis Daudet on 7/8/16.
//  Copyright © 2016 Notre Dame. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PocketSphinxMdefConvertDelegate;

@interface PocketSphinxMdefConvert : NSObject

    @property (nonatomic, weak) id <PocketSphinxMdefConvertDelegate> delegate;

    +(int) pocketSphinxMdefConvertWithArguments:(NSString *) arguments;
    -(void) pocketSphinxMdefConvertWithDelegateAndArguments:(NSString *) arguments;

@end

@protocol PocketSphinxMdefConvertDelegate <NSObject>
    @optional
    -(void) isDoneRunningPocketSphinxMdefConvertWithArguments:(NSString *) arguments returnValue:(int) returnValue;

@end