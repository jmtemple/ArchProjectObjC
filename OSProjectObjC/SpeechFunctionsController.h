//
//  SpeechFunctionsController
//  Contect
//
//  Created by Contect on 7/14/15.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <PocketSphinxiOSFramework/PocketSphinxiOSFramework.h>
#import "GlobalVars.h"
#import "ReportModel.h"

@protocol SpeechFunctionsControllerDelegate;

@interface SpeechFunctionsController : NSObject <PocketSphinxProgramsDelegate>

@property (nonatomic, weak) id <SpeechFunctionsControllerDelegate> delegate;

+ (SpeechFunctionsController *) sharedInstance ;

- (void)startRecordingInFile:(NSString *)wavPath;
- (void)startRecordingFor:(int)numberOfSeconds inFile:(NSString *)wavPath;
- (void)playFile:(NSString *)fileName;

- (void) stopAll;
- (void) stopRecording;
- (double) getDurationOfSoundFileAtPath:(NSURL*) recordingPath;

- (void) runPocketSphinxAnalysis:(ReportModel*) reportModel;

@end

@protocol SpeechFunctionsControllerDelegate <NSObject>
@optional
-(void) isDoneReadingWord:(NSString *)word;
-(void) isDoneReadingInstruction:(NSString *)instruction;
-(void) isDoneRecording;
-(void) isDonePlaying;
-(void) newPower:(float)power peakPower:(float)peakPower;
-(void) finishedRunningPocketSphinxAnalysisWithArguments:(NSString *)arguments returnValue:(int)retrurnValue;
@end
