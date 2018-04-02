//
//  ReportModel.h
//  PatakaApp
//
//  Created by Louis Daudet on 9/1/16.
//  Copyright © 2016 Notre Dame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportModel : NSObject

@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) NSString *isSelected;
@property (nonatomic, strong) NSString *isBeingUploaded;
@property (nonatomic, strong) NSString *isManual;

@property (nonatomic, strong) NSString *reportName;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSString *hypContent;
@property (nonatomic, strong) NSString *hypSegContent;
@property (nonatomic, strong) NSString *hypothesis;
@property (nonatomic, strong) NSString *hypothesisScore;
@property (nonatomic, strong) NSNumber *numberOfCorrectIterations;
@property (nonatomic, strong) NSNumber *numberOfIncorrectIterations;
@property (nonatomic, strong) NSNumber *ratioCorrectToIncorrectIterations;
@property (nonatomic, strong) NSNumber *minDuration;
@property (nonatomic, strong) NSNumber *maxDuration;
@property (nonatomic, strong) NSNumber *maxMinDurationDifference;
@property (nonatomic, strong) NSNumber *durationAverage;
@property (nonatomic, strong) NSNumber *durationStdDev;

@property (nonatomic, strong) NSDictionary *timingData;


@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *typeOfTest;
@property (nonatomic, strong) NSString *typeOfTestName;
@property (nonatomic, strong) NSString *recordingName;
@property (nonatomic, strong) NSString *htmlName;


+ (ReportModel *) sharedReport;
- (ReportModel *) initWithContentOfDictionary:(NSMutableDictionary*) reportDictionary;

- (NSMutableDictionary *)toNSDictionary;

@end
