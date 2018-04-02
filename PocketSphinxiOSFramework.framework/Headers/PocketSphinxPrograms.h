//
//  PocketSphinxPrograms.h
//  PocketSphinxiOSFramework
//
//  Created by Louis Daudet on 7/22/16.
//  Copyright © 2016 Notre Dame. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PocketSphinxProgramsDelegate;

@interface PocketSphinxPrograms : NSObject

@property (nonatomic, weak) id <PocketSphinxProgramsDelegate> delegate;

+ (PocketSphinxPrograms *) sharedInstance ;

+(int) pocketSphinxContinuousWithArguments: (NSString*) arguments;
-(void) pocketSphinxContinuousWithDelegateAndArguments: (NSString*) arguments;

+(int) pocketSphinxBatchWithArguments: (NSString*) arguments;
-(void) pocketSphinxBatchWithDelegateAndArguments: (NSString*) arguments;

+(int) pocketSphinxMdefConvertWithArguments:(NSString *) arguments;
-(void) pocketSphinxMdefConvertWithDelegateAndArguments:(NSString *) arguments;

@end

@protocol PocketSphinxProgramsDelegate <NSObject>
    @optional
    -(void) isDoneRunningPocketSphinxContinuousWithArguments:(NSString *) arguments returnValue:(int) returnValue;
    -(void) isDoneRunningPocketSphinxBatchWithArguments:(NSString *) arguments returnValue:(int) returnValue;
    -(void) isDoneRunningPocketSphinxMdefConvertWithArguments:(NSString *) arguments returnValue:(int) returnValue;

@end
