//
//  SpeechFunctionsController
//  Contect
//
//  Created by Contect on 7/14/15.
//
//

#import "SpeechFunctionsController.h"
#import "GlobalFunctions.h"
@interface SpeechFunctionsController ()

<AVAudioRecorderDelegate>
@property (nonatomic,strong) AVAudioRecorder *recorder ;
@property (nonatomic,strong) NSString *done ;
@property (nonatomic,strong) AVAudioPlayer *player ;
@property (nonatomic,strong) NSTimer *timer ;

@end


@implementation SpeechFunctionsController
@synthesize delegate;




+ (SpeechFunctionsController *) sharedInstance {
    static id sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

-(void) startRecordingInFile:(NSString *) recordingFilePath {
    _done = @"no";
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    NSError *err = nil ;
    [audioSession setActive:YES error:&err];
    if ([_recorder isRecording]) {
        [_recorder stop];
        [_recorder deleteRecording];
        _recorder = nil ;
    }
    if (_recorder) {
        [_recorder stop];
        _recorder = nil ;
    }
    [self createRecorder:recordingFilePath];
    _recorder.delegate = self ;
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    [_recorder record];
    _timer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(updateMeter) userInfo: nil repeats: YES];
}

-(void) startRecordingFor:(int) numberOfSeconds inFile:(NSString *) recordingFilePath {
    _done = @"no";
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    NSError *err = nil ;
    [audioSession setActive:YES error:&err];
    if ([_recorder isRecording]) {
        [_recorder stop];
        [_recorder deleteRecording];
        _recorder = nil ;
    }
    if (_recorder) {
        [_recorder stop];
        _recorder = nil ;
    }
    [self createRecorder:recordingFilePath];
    _recorder.delegate = self ;
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    [_recorder recordForDuration:numberOfSeconds];
    _timer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(updateMeter) userInfo: nil repeats: YES];
}

- (void) createRecorder:(NSString *) recordingFilePath {
    NSURL *soundFileURL = [NSURL fileURLWithPath:recordingFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityHigh],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 1],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:16000],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    _recorder = [[AVAudioRecorder alloc]
                 initWithURL:soundFileURL
                 settings:recordSettings
                 error:&error];
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

- (void) createPlayer:(NSString *) fileName {
    //    NSLog(@"NAME %@", fileName);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    NSError *err = nil ;
    [audioSession setActive:YES error:&err];    
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"]];
    NSURL *url = [NSURL fileURLWithPath:fileName];

    NSError *error = nil;
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
}

-(void) playFile: (NSString *) fileName {
    [self createPlayer:fileName];
    _player.delegate = (id) self;
    [_player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    [delegate isDonePlaying];
    
}


-(void) stopAll {
    _done = @"";
    if (_recorder.isRecording) {
        [_recorder stop];
        [_recorder deleteRecording];
        [_timer invalidate];
        _timer = nil;
    }
    [_player stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

-(void) stopRecording {
    NSLog(@"stopRecording");
    if (_recorder.isRecording) {
        [_recorder stop];
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark -
#pragma mark AVAudioRecorderDelegate
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"SpeechFunctionController: audioRecorderDidFinishRecording");
    [_timer invalidate];
    _timer = nil;
    if (![_done isEqualToString:@""]) {
        [delegate isDoneRecording];
    }
}


-(void)updateMeter
{
    //don't forget:
    [_recorder updateMeters];
    float averagePower   = [_recorder averagePowerForChannel:0];
    float peakPower      = [_recorder peakPowerForChannel:0];
    
    // we don't want to surprise a ViewController with a method call
    // not in the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate newPower:averagePower peakPower:peakPower];
    });
    [NSThread sleepForTimeInterval:.05]; // 20 FPS
}

-(double) getDurationOfSoundFileAtPath:(NSURL*) recordingPath {
    NSError *error = nil;
    AVAudioPlayer* avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:recordingPath error:&error];
    
    double duration = avAudioPlayer.duration;
    avAudioPlayer = nil;
    return duration;
}

- (void) runPocketSphinxAnalysis:(ReportModel *) reportModel {
    NSLog(@"launchAnalysis");
    GlobalVars* globalVars = [GlobalVars sharedInstance];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* pathOfNewFile =[NSTemporaryDirectory() stringByAppendingPathComponent:@"recording.wav"];
    [fileManager removeItemAtPath:pathOfNewFile error:nil];
    [fileManager copyItemAtPath:[getFullPathForComponent(globalVars.recordingsFolderFilePath) stringByAppendingPathComponent:reportModel.recordingName] toPath:pathOfNewFile error:nil];
    NSString *hyp = [globalVars.documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_seg.txt",[[reportModel.reportName componentsSeparatedByString:@" "] objectAtIndex:0]]];
    NSString *hypseg = [globalVars.documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_log.txt",[[reportModel.reportName componentsSeparatedByString:@" "] objectAtIndex:0]]];
    NSString *ctl = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion_test.fileids"];
    NSString *cepdir = NSTemporaryDirectory();
    cepdir = [cepdir substringToIndex:[cepdir length]-1];
    
    NSString *hmm = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion.ci_cont"];
    NSString *hmm2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hub4wsj_sc_8k"];
    
    NSString *dict = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion.dic"];
    NSString *dictPa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pa.dic"];
    NSString *dictTa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ta.dic"];
    NSString *dictKa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ka.dic"];
    
    NSString *lm = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion.lm.DMP"];
    
    NSString *gramPa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pa.gram"];
    
    NSString *gramTa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ta.gram"];
    
    NSString *gramKa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ka.gram"];

    NSString* argumentsBatch = @"";
    switch ([reportModel.typeOfTest intValue]) {
        case 0:
            argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 1 -fwdflatlw 1 -bestpathlw 1 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -adcin yes",hmm2,  gramPa, dictPa, ctl, cepdir, hyp, hypseg];
            break;
        case 1:
            argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 1 -fwdflatlw 1 -bestpathlw 1 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -adcin yes",hmm2,  gramTa, dictTa, ctl, cepdir, hyp, hypseg];
            break;
        case 2:
            argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 1 -fwdflatlw 1 -bestpathlw 1 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -adcin yes",hmm2,  gramKa, dictKa, ctl, cepdir, hyp, hypseg];
            break;
        case 3:
            argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 2 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -lm %@ -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm, dict, ctl, cepdir, hyp, lm, hypseg];
            break;
        default:
            break;
    }
    
    PocketSphinxPrograms* p = [[PocketSphinxPrograms alloc] init];
    p.delegate = (id) self;
    [p pocketSphinxBatchWithDelegateAndArguments:argumentsBatch];
}

-(void) isDoneRunningPocketSphinxBatchWithArguments:(NSString *)arguments returnValue:(int)retrurnValue {
    NSLog(@"isDoneRunningPocketSphinxBatchWithArguments");
    [self.delegate finishedRunningPocketSphinxAnalysisWithArguments:arguments returnValue:retrurnValue];
}

@end
