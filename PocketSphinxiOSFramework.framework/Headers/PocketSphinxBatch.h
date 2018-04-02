//
//  PocketSphinxBatch.h
//  PocketSphinxiOSFramework
//
//  Created by Louis Daudet on 7/6/16.
//  Copyright © 2016 Notre Dame. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PocketSphinxBatchDelegate;

@interface PocketSphinxBatch : NSObject

    @property (nonatomic, weak) id <PocketSphinxBatchDelegate> delegate;

    +(int) pocketSphinxBatchWithArguments: (NSString*) arguments;
    -(void) pocketSphinxBatchWithDelegateAndArguments: (NSString*) arguments;

@end

@protocol PocketSphinxBatchDelegate <NSObject>
    @optional
    -(void) isDoneRunningPocketSphinxBatchWithArguments:(NSString *) arguments returnValue:(int) returnValue;

@end