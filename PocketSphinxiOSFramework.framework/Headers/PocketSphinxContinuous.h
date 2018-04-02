//
//  PocketSphinxContinuous.h
//  PocketSphinxiOSFramework
//
//  Created by Louis Daudet on 7/6/16.
//  Copyright © 2016 Notre Dame. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PocketSphinxContinuousDelegate;

@interface PocketSphinxContinuous : NSObject

    @property (nonatomic, weak) id <PocketSphinxContinuousDelegate> delegate;

    +(int) pocketSphinxContinuousWithArguments: (NSString*) arguments;
    -(void) pocketSphinxContinuousWithDelegateAndArguments: (NSString*) arguments;

@end

@protocol PocketSphinxContinuousDelegate <NSObject>
    @optional
    -(void) isDoneRunningPocketSphinxContinuousWithArguments:(NSString *) arguments returnValue:(int) returnValue;

@end
