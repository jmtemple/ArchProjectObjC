//
//  ReportModel.m
//  PatakaApp
//
//  Created by Louis Daudet on 9/1/16.
//  Copyright © 2016 Notre Dame. All rights reserved.
//

#import "ReportModel.h"

@implementation ReportModel

+ (ReportModel *)sharedReport
{
    static ReportModel *sharedReport;
    @synchronized(self)
    {
        if (!sharedReport)
            sharedReport = [[ReportModel alloc] init];
        
        return sharedReport;
    }
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:_uniqueID forKey:@"uniqueID"];
    [dictionary setValue:_isSelected forKey:@"isSelected"];
    [dictionary setValue:_isBeingUploaded forKey:@"isBeingUploaded"];
    [dictionary setValue:_isManual forKey:@"isManual"];
    [dictionary setValue:_reportName forKey:@"reportName"];
    [dictionary setValue:_date forKey:@"date"];
    [dictionary setValue:_hypContent forKey:@"hypContent"];
    [dictionary setValue:_hypSegContent forKey:@"hypSegContent"];
    [dictionary setValue:_birthDate forKey:@"birthDate"];
    [dictionary setValue:_gender forKey:@"gender"];
    [dictionary setValue:_typeOfTest forKey:@"typeOfTest"];
    [dictionary setValue:_typeOfTestName forKey:@"typeOfTestName"];
    [dictionary setValue:_hypothesis forKey:@"hypothesis"];
    [dictionary setValue:_hypothesisScore forKey:@"hypothesisScore"];
    [dictionary setValue:_numberOfCorrectIterations forKey:@"numberOfCorrectIterations"];
    [dictionary setValue:_numberOfIncorrectIterations forKey:@"numberOfIncorrectIterations"];
    [dictionary setValue:_ratioCorrectToIncorrectIterations forKey:@"ratioCorrectToIncorrectIterations"];
    
    [dictionary setValue:_minDuration forKey:@"minDuration"];
    [dictionary setValue:_maxDuration forKey:@"maxDuration"];
    [dictionary setValue:_maxMinDurationDifference forKey:@"maxMinDurationDifference"];
    [dictionary setValue:_durationAverage forKey:@"durationAverage"];
    [dictionary setValue:_durationStdDev forKey:@"durationStdDev"];
    
    [dictionary setValue:_timingData forKey:@"timingData"];
    [dictionary setValue:_recordingName forKey:@"recordingName"];
    [dictionary setValue:_htmlName forKey:@"htmlName"];
    return dictionary;
}

- (ReportModel *) initWithContentOfDictionary:(NSMutableDictionary*) reportDictionary {
    ReportModel* reportModel = [[ReportModel alloc] init];
    reportModel.uniqueID = reportDictionary[@"uniqueID"];
    reportModel.isSelected = reportDictionary[@"isSelected"];
    reportModel.isBeingUploaded = reportDictionary[@"isBeingUploaded"];
    reportModel.isManual = reportDictionary[@"isManual"];
    reportModel.reportName = reportDictionary[@"reportName"];
    reportModel.date = reportDictionary[@"date"];
    reportModel.hypContent = reportDictionary[@"hypContent"];
    reportModel.hypSegContent = reportDictionary[@"hypSegContent"];
    reportModel.birthDate = reportDictionary[@"birthDate"];
    reportModel.gender  = reportDictionary[@"gender"];
    reportModel.typeOfTest = reportDictionary[@"typeOfTest"];
    reportModel.typeOfTestName = reportDictionary[@"typeOfTestName"];
    reportModel.hypothesis = reportDictionary[@"hypothesis"];
    reportModel.hypothesisScore = reportDictionary[@"hypothesisScore"];
    reportModel.numberOfCorrectIterations = reportDictionary[@"numberOfCorrectIterations"];
    reportModel.numberOfIncorrectIterations = reportDictionary[@"numberOfIncorrectIterations"];
    reportModel.ratioCorrectToIncorrectIterations = reportDictionary[@"ratioCorrectToIncorrectIterations"];
    
    reportModel.minDuration = reportDictionary[@"minDuration"];
    reportModel.maxDuration = reportDictionary[@"ratioCorrectToIncorrectIterations"];
    reportModel.maxMinDurationDifference = reportDictionary[@"maxMinDurationDifference"];
    reportModel.durationAverage = reportDictionary[@"durationAverage"];
    reportModel.durationStdDev = reportDictionary[@"durationStdDev"];
    
    reportModel.timingData = reportDictionary[@"timingData"];
    reportModel.recordingName = reportDictionary[@"recordingName"];
    reportModel.htmlName = reportDictionary[@"htmlName"];
    return reportModel;
}

@end
