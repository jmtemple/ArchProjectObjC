//
//  ViewController.m
//  OSProjectObjC
//
//  Created by John Templeton on 11/7/17.
//  Copyright © 2017 John Templeton. All rights reserved.
//

#import "ViewController.h"
#import <PocketSphinxiOSFramework/PocketSphinxiOSFramework.h>
#import "GlobalVars.h"
#import "SpeechFunctionsController.h"
//#import "GlobalFunctions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self testPocketSphinx];
    [self launchAnalysis];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)launchAnalysis {
    NSString* fileName = @"0.wav";
    NSString* filePath = @"OSSoundFiles";
    NSString *hmm2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",filePath,fileName]];
    NSLog(@"%@", hmm2);
//
//    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//
//    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"foo.html"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:hmm2];
    
    
    SpeechFunctionsController * sp = [SpeechFunctionsController sharedInstance];
    
//    [sp playFile:hmm2];
    [self runPocketSphinxAnalysisLocal];
}

-(void) createFileIdFile {
    // create copies of the sounds files
    NSString* fileName = @"0.wav";
    NSString* filePath = @"OSSoundFiles";
    NSString *hmm2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",filePath,fileName]];

    
    
                                                                                           
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentDirectoryPath = paths[0];
    
    NSString *cepdir = NSTemporaryDirectory();
    cepdir = [cepdir substringToIndex:[cepdir length]-1];
    
//    [fileManager copyItemAtPath:[getFullPathForComponent(globalVars.recordingsFolderFilePath) stringByAppendingPathComponent:reportModel.recordingName] toPath:pathOfNewFile error:nil];
//
//    // create the .fileids file, by writing the fileids name to the file

                                                                                           
    [self runPocketSphinxAnalysisLocal];
}
- (void) runPocketSphinxAnalysisLocal {
    NSLog(@"launchAnalysis");
    GlobalVars* globalVars = [GlobalVars sharedInstance];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // Outputs
    NSString *hyp = [globalVars.documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"seg.txt"]];
    NSString *hypseg = [globalVars.documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"log.txt"]];
    
    // List of sound files names (without extention)
    NSString *ctl = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion_test.fileids"];
    
    // Folder of the sound files
    NSString *cepdir =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"OSSoundFiles"] ;


    // Pocketsphinx stuff
    NSString *hmm = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion.ci_cont"];
    
    // Pocketsphinx stuff for you
    NSString *hmm2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cmusphinx-en-us-8khz-5.2"];

    // Dictionaries
    NSString *dictCMU = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cmudict.dic"];
//    NSString *dictPa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pa.dic"];
//    NSString *dictTa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ta.dic"];
//    NSString *dictKa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ka.dic"];

// Language model stuff
    NSString *lm = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pocketsphinx/model/en-us/en-us-phone.lm.dmp -allphone phone.lm"];
    
// grammar files
//    NSString *gramPa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pa.gram"];
//
//    NSString *gramTa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ta.gram"];
//
//    NSString *gramKa =gr [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ka.gram"];
    
   NSString *multigram = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"multisyll.gram"];

  //  NSString *sentencegram = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sentence.gram"];
    
    NSString* argumentsBatch = @"";
    int typeOfTest = 3;
    switch (typeOfTest) {
        case 0:
            argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 1 -fwdflatlw 1 -bestpathlw 1 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 116 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -adcin yes",hmm, multigram, dictCMU, ctl, cepdir, hyp, hypseg];
            break;
      
//      case 2:
//        argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 1 -fwdflatlw 1 -bestpathlw 1 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 116 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -adcin yes",hmm2, multigram, dictCMU, ctl, cepdir, hyp, hypseg];
//            break;
      case 3:
          argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 116 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -lm %@ -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2, dictCMU, ctl, cepdir, hyp, lm, hypseg];
//            break;
//        default:
//            break;
    }

    PocketSphinxPrograms* p = [[PocketSphinxPrograms alloc] init];
    p.delegate = (id) self;
    NSLog(@"Args: %@", argumentsBatch);
    [p pocketSphinxBatchWithDelegateAndArguments:argumentsBatch];
}


#pragma mark -
#pragma mark Android Port Test
- (void) testPocketSphinx {
    NSMutableDictionary* recordingsInfo  = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* recordingInfo = [[NSMutableDictionary alloc] init];
    float totalCorrectnessBefore = 0.0;
    float totalCorrectnessAfter = 0.0;
    float totalCorrectnessProgression = 0.0;
    float totalNumberOfWrongBefore = 0.0;
    float totalNumberOfWrongAfter = 0.0;
    float totalNumberOfFilesWrongBefore = 0.0;
    float totalNumberOfFilesWrongAfter = 0.0;
    float totalNumberOfOmitedBefore = 0.0;
    float totalNumberOfAddedBefore = 0.0;
    float totalNumberOfOmitedAfter = 0.0;
    float totalNumberOfAddedAfter = 0.0;
    
    NSMutableArray* errorsBefore = [[NSMutableArray alloc] init];
    NSMutableArray* errorsAfter = [[NSMutableArray alloc] init];
    
    NSMutableArray* errorsPercentageBefore = [[NSMutableArray alloc] init];
    NSMutableArray* errorsPercentageAfter = [[NSMutableArray alloc] init];
    
    
    // recording 1
    [recordingInfo setObject:@"1" forKey:@"name"];
    [recordingInfo setObject:@"14" forKey:@"trueCount"];
    [recordingInfo setObject:@"12" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.57.57_14 T^ says 12 - 1" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"1"];
    
    // recording 2
    [recordingInfo setObject:@"2" forKey:@"name"];
    [recordingInfo setObject:@"17" forKey:@"trueCount"];
    [recordingInfo setObject:@"12" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.58.05_17 T^ says 12 - 2" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"2"];
    
    // recording 3
    [recordingInfo setObject:@"3" forKey:@"name"];
    [recordingInfo setObject:@"13" forKey:@"trueCount"];
    [recordingInfo setObject:@"12" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.58.37_ 13 K^ says 12 - 3" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"3"];
    
    // recording 4
    [recordingInfo setObject:@"4" forKey:@"name"];
    [recordingInfo setObject:@"16" forKey:@"trueCount"];
    [recordingInfo setObject:@"13" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_19.07.16_16 T^ says 13 - 4" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"4"];
    
    // recording 5
    [recordingInfo setObject:@"5" forKey:@"name"];
    [recordingInfo setObject:@"21" forKey:@"trueCount"];
    [recordingInfo setObject:@"18" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_19.08.02_20 T^ says 18 - 5" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"5"];
    
    // recording 6
    [recordingInfo setObject:@"6" forKey:@"name"];
    [recordingInfo setObject:@"21" forKey:@"trueCount"];
    [recordingInfo setObject:@"24" forKey:@"initialResult"];
    [recordingInfo setObject:@"Pa" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.20.59_21 pa - 6" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"6"];
    
    // recording 7
    [recordingInfo setObject:@"7" forKey:@"name"];
    [recordingInfo setObject:@"30" forKey:@"trueCount"];
    [recordingInfo setObject:@"31" forKey:@"initialResult"];
    [recordingInfo setObject:@"Pa" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.21.57_30 pa - 7" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"7"];
    
    // recording 8
    [recordingInfo setObject:@"8" forKey:@"name"];
    [recordingInfo setObject:@"38" forKey:@"trueCount"];
    [recordingInfo setObject:@"41" forKey:@"initialResult"];
    [recordingInfo setObject:@"Pa" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.22.50_38 pa - 8" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"8"];
    
    // recording 9
    [recordingInfo setObject:@"9" forKey:@"name"];
    [recordingInfo setObject:@"18" forKey:@"trueCount"];
    [recordingInfo setObject:@"18" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.23.31_18 ta - 9" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"9"];
    
    // recording 10
    [recordingInfo setObject:@"10" forKey:@"name"];
    [recordingInfo setObject:@"24" forKey:@"trueCount"];
    [recordingInfo setObject:@"25" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.23.58_24 ta - 10" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"10"];
    
    // recording 11
    [recordingInfo setObject:@"11" forKey:@"name"];
    [recordingInfo setObject:@"21" forKey:@"trueCount"];
    [recordingInfo setObject:@"19" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.24.30_21 ta - 11" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"11"];
    
    // recording 12
    [recordingInfo setObject:@"12" forKey:@"name"];
    [recordingInfo setObject:@"28" forKey:@"trueCount"];
    [recordingInfo setObject:@"26" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.24.58_28 ka - 12" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"12"];
    
    // recording 13
    [recordingInfo setObject:@"13" forKey:@"name"];
    [recordingInfo setObject:@"24" forKey:@"trueCount"];
    [recordingInfo setObject:@"24" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.25.45_24 ka - 13" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"13"];
    
    // recording 14
    [recordingInfo setObject:@"14" forKey:@"name"];
    [recordingInfo setObject:@"25" forKey:@"trueCount"];
    [recordingInfo setObject:@"26" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.26.19_25 ka - 14" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"14"];
    
    // recording 15
    [recordingInfo setObject:@"15" forKey:@"name"];
    [recordingInfo setObject:@"12" forKey:@"trueCount"];
    [recordingInfo setObject:@"12" forKey:@"initialResult"];
    [recordingInfo setObject:@"PaTaKa" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-14_07.26.49_12 pataka - 15" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"15"];
    
    // recording 16
    [recordingInfo setObject:@"16" forKey:@"name"];
    [recordingInfo setObject:@"16" forKey:@"trueCount"];
    [recordingInfo setObject:@"16" forKey:@"initialResult"];
    [recordingInfo setObject:@"Pa" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.57.30_P" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"16"];
    
    // recording 17
    [recordingInfo setObject:@"17" forKey:@"name"];
    [recordingInfo setObject:@"8" forKey:@"trueCount"];
    [recordingInfo setObject:@"8" forKey:@"initialResult"];
    [recordingInfo setObject:@"Pa" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.57.40_P" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"17"];
    
    // recording 18
    [recordingInfo setObject:@"18" forKey:@"name"];
    [recordingInfo setObject:@"12" forKey:@"trueCount"];
    [recordingInfo setObject:@"12" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.57.50_T" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"18"];
    
    // recording 19
    [recordingInfo setObject:@"19" forKey:@"name"];
    [recordingInfo setObject:@"11" forKey:@"trueCount"];
    [recordingInfo setObject:@"11" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.58.16_K" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"19"];
    
    // recording 20
    [recordingInfo setObject:@"20" forKey:@"name"];
    [recordingInfo setObject:@"10" forKey:@"trueCount"];
    [recordingInfo setObject:@"10" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.58.29_K" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"20"];
    
    // recording 21
    [recordingInfo setObject:@"21" forKey:@"name"];
    [recordingInfo setObject:@"17" forKey:@"trueCount"];
    [recordingInfo setObject:@"17" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.58.48_K" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"21"];
    
    // recording 22
    [recordingInfo setObject:@"22" forKey:@"name"];
    [recordingInfo setObject:@"8" forKey:@"trueCount"];
    [recordingInfo setObject:@"8" forKey:@"initialResult"];
    [recordingInfo setObject:@"PaTaKa" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.59.12_PTK" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"22"];
    
    // recording 23
    [recordingInfo setObject:@"23" forKey:@"name"];
    [recordingInfo setObject:@"8" forKey:@"trueCount"];
    [recordingInfo setObject:@"8" forKey:@"initialResult"];
    [recordingInfo setObject:@"PaTaKa" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_18.59.20_PTK" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"23"];
    
    // recording 24
    [recordingInfo setObject:@"24" forKey:@"name"];
    [recordingInfo setObject:@"13" forKey:@"trueCount"];
    [recordingInfo setObject:@"13" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_19.06.54_K" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"24"];
    
    // recording 25
    [recordingInfo setObject:@"25" forKey:@"name"];
    [recordingInfo setObject:@"19" forKey:@"trueCount"];
    [recordingInfo setObject:@"19" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"2017-09-13_19.09.08_K" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"25"];
    
    // recording 26
    [recordingInfo setObject:@"26" forKey:@"name"];
    [recordingInfo setObject:@"10" forKey:@"trueCount"];
    [recordingInfo setObject:@"11" forKey:@"initialResult"];
    [recordingInfo setObject:@"Pa" forKey:@"testType"];
    [recordingInfo setObject:@"26" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"26"];
    
    // recording 27
    [recordingInfo setObject:@"27" forKey:@"name"];
    [recordingInfo setObject:@"12" forKey:@"trueCount"];
    [recordingInfo setObject:@"13" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"27" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"27"];
    
    // recording 28
    [recordingInfo setObject:@"28" forKey:@"name"];
    [recordingInfo setObject:@"10" forKey:@"trueCount"];
    [recordingInfo setObject:@"11" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"28" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"28"];
    
    // recording 29
    [recordingInfo setObject:@"29" forKey:@"name"];
    [recordingInfo setObject:@"7" forKey:@"trueCount"];
    [recordingInfo setObject:@"8" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"29" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"29"];
    
    // recording 30
    [recordingInfo setObject:@"30" forKey:@"name"];
    [recordingInfo setObject:@"14" forKey:@"trueCount"];
    [recordingInfo setObject:@"13" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ka" forKey:@"testType"];
    [recordingInfo setObject:@"30" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"30"];
    
    // recording 31
    [recordingInfo setObject:@"31" forKey:@"name"];
    [recordingInfo setObject:@"16" forKey:@"trueCount"];
    [recordingInfo setObject:@"9" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"31" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"31"];
    
    // recording 32
    [recordingInfo setObject:@"32" forKey:@"name"];
    [recordingInfo setObject:@"11" forKey:@"trueCount"];
    [recordingInfo setObject:@"10" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"32" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"32"];
    
    // recording 33
    [recordingInfo setObject:@"33" forKey:@"name"];
    [recordingInfo setObject:@"12" forKey:@"trueCount"];
    [recordingInfo setObject:@"11" forKey:@"initialResult"];
    [recordingInfo setObject:@"Ta" forKey:@"testType"];
    [recordingInfo setObject:@"33" forKey:@"reportName"];
    [recordingsInfo setObject:[recordingInfo copy] forKey:@"33"];
    
    
    
    
    
    
    
    
    //    // recording
    //    [recordingInfo setObject:@"" forKey:@"name"];
    //    [recordingInfo setObject:@"" forKey:@"trueCount"];
    //    [recordingInfo setObject:@"" forKey:@"initialResult"];
    //    [recordingInfo setObject:@"" forKey:@"testType"];
    //    [recordingInfo setObject:@"" forKey:@"reportName"];
    //    [recordingsInfo setObject:[recordingInfo copy] forKey:@""];
    
    
    int numberOfRecordings = (int)[recordingsInfo count];
    
    for (int i = 1; i <= numberOfRecordings; i ++) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        GlobalVars* globalVars = [GlobalVars sharedInstance];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString* pathOfNewFile =[NSTemporaryDirectory() stringByAppendingPathComponent:@"recording.wav"];
        [fileManager removeItemAtPath:pathOfNewFile error:nil];
        NSString* wavName = [NSString stringWithFormat:@"%i.wav", i];
        NSString* wavSubpath = [NSString stringWithFormat:@"PocketSphinxTestFiles/%@", wavName];
        //        NSString* wavPath = [[NSBundle mainBundle] pathForResource:wavName ofType:@"m4a"];
        NSString *wavPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:wavSubpath];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavPath];
        
        BOOL fileIsCopied = [fileManager copyItemAtPath:wavPath toPath:pathOfNewFile error:nil];
        
        NSLog(@"fileExists: %i, fileisCopied: %i", fileExists, fileIsCopied);
        NSString *hyp = [globalVars.documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i_seg.txt",i]];
        NSString *hypseg = [globalVars.documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i_log.txt",i]];
        NSString *ctl = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion_test.fileids"];
        NSString *cepdir =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"OSSoundFiles"] ;
        cepdir = [cepdir substringToIndex:[cepdir length]-1];
        
        NSString *hmm = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion.ci_cont"];
        NSString *hmm2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cmusphinx-en-us-8khz-5.2"];
        
    //  NSString *dict = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion.dic"];
    //  NSString *dictPa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pa.dic"];
    //  NSString *dictTa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ta.dic"];
    //  NSString *dictKa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ka.dic"];
        NSString *dictCMU = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cmudict.dic"];
        
        NSString *lm = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UTDallas-concussion.lm.DMP"];
        
       // NSString *gramPa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pa.gram"];
        
       // NSString *gramTa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ta.gram"];
        
       // NSString *gramKa = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ka.gram"];
        
        NSString *multigram = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"multisyll.gram"];
        
        NSString* argumentsBatch = @"";
        
        
        NSString* testType = [[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"testType"];
        if ([testType isEqualToString:@"Pa"]) {
            argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 1 -fwdflatlw 1 -bestpathlw 1 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -adcin yes",hmm2,  multigram, dictCMU, ctl, cepdir, hyp, hypseg];
        }
        //else if ([testType isEqualToString:@"Ta"]) {
           // argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 1 -fwdflatlw 1 -bestpathlw 1 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -adcin yes",hmm2,  gramTa, dictTa, ctl, cepdir, hyp, hypseg];
        //} else if ([testType isEqualToString:@"Ka"]) {
          //  argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 1 -fwdflatlw 1 -bestpathlw 1 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -adcin yes",hmm2,  gramKa, dictKa, ctl, cepdir, hyp, hypseg];
        //} else if ([testType isEqualToString:@"PaTaKa"]) {
          //  argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 2 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -lm %@ -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm, dict, ctl, cepdir, hyp, lm, hypseg];
       // }
        
        //        switch (i) {
        //            case 1:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramTa, dictTa, ctl, cepdir, hyp, hypseg];
        //                break;
        //            case 2:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramTa, dictTa, ctl, cepdir, hyp, hypseg];
        //                break;
        //            case 3:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramKa, dictKa, ctl, cepdir, hyp, hypseg];
        //                break;
        //            case 4:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramTa, dictTa, ctl, cepdir, hyp, hypseg];
        //                break;
        //            case 5:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramTa, dictTa, ctl, cepdir, hyp, hypseg];                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramTa, dictTa, ctl, cepdir, hyp, hypseg];
        //                break;
        //            case 1:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramPa, dictPa, ctl, cepdir, hyp, hypseg];
        //                break;
        //            case 2:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramTa, dictTa, ctl, cepdir, hyp, hypseg];
        //                break;
        //            case 3:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -jsgf %@ -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 1 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm2,  gramKa, dictKa, ctl, cepdir, hyp, hypseg];
        //                break;
        //            case 4:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 2 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -lm %@ -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm, dict, ctl, cepdir, hyp, lm, hypseg];
        //                break;
        //            case 5:
        //                argumentsBatch = [NSString stringWithFormat:@"pocketsphinx_batch -hmm %@ -feat 1s_c_d_dd -ceplen 13 -ncep 13 -lw 10 -fwdflatlw 10 -bestpathlw 10 -beam 1e-80 -wbeam 1e-40 -fwdflatbeam 1e-80 -fwdflatwbeam 1e-40 -pbeam 1e-80 -lpbeam 1e-80 -lponlybeam 1e-80 -dict %@ -wip 0.2 -ctl %@ -ctloffset 0 -ctlcount 2 -cepdir %@ -cepext .wav -hyp %@ -agc none -varnorm no -cmn current -lm %@ -hypseg %@ -remove_noise no -remove_silence no -transform dct -adcin yes",hmm, dict, ctl, cepdir, hyp, lm, hypseg];
        //                break;
        //            default:
        //                break;
        //        }
        
//        argumentsBatch = [NSString stringWithFormat:@"%@ %@", argumentsBatch, @"-logfn /dev/null"];
        PocketSphinxPrograms* p = [[PocketSphinxPrograms alloc] init];
        p.delegate = (id) self;
        NSLog(@"sptest ***************************************************************************************************");
        [p pocketSphinxBatchWithDelegateAndArguments:argumentsBatch];
        
        NSString* hypContent = [NSString stringWithContentsOfFile:hyp
                                                         encoding:NSUTF8StringEncoding
                                                            error:NULL];
        //        NSString* hypsegContent = [NSString stringWithContentsOfFile:hypseg
        //                                                            encoding:NSUTF8StringEncoding
        //                                                               error:NULL];
        
        
        NSLog(@"spTest - Hypothesis: %@", hypContent);
        NSLog(@"spTest - Recording name: %i", i);
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"PAH" options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:hypContent options:0 range:NSMakeRange(0, [hypContent length])];
        regex = [NSRegularExpression regularExpressionWithPattern:@"TAH" options:NSRegularExpressionCaseInsensitive error:&error];
        numberOfMatches = numberOfMatches + [regex numberOfMatchesInString:hypContent options:0 range:NSMakeRange(0, [hypContent length])];
        regex = [NSRegularExpression regularExpressionWithPattern:@"KAH" options:NSRegularExpressionCaseInsensitive error:&error];
        numberOfMatches = numberOfMatches + [regex numberOfMatchesInString:hypContent options:0 range:NSMakeRange(0, [hypContent length])];
        
        if ([[[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"testType"] isEqualToString:@"PaTaKa"]) {
            regex = [NSRegularExpression regularExpressionWithPattern:@"PA" options:NSRegularExpressionCaseInsensitive error:&error];
            numberOfMatches = numberOfMatches + [regex numberOfMatchesInString:hypContent options:0 range:NSMakeRange(0, [hypContent length])];
            regex = [NSRegularExpression regularExpressionWithPattern:@"TA" options:NSRegularExpressionCaseInsensitive error:&error];
            numberOfMatches = numberOfMatches + [regex numberOfMatchesInString:hypContent options:0 range:NSMakeRange(0, [hypContent length])];
            regex = [NSRegularExpression regularExpressionWithPattern:@"KA" options:NSRegularExpressionCaseInsensitive error:&error];
            numberOfMatches = numberOfMatches + [regex numberOfMatchesInString:hypContent options:0 range:NSMakeRange(0, [hypContent length])];
            numberOfMatches = numberOfMatches / 3;
        }
        
        int result = (int) numberOfMatches;
        //        int result = (int)[[hypContent componentsSeparatedByString:@" "] count];
        NSLog(@"spTest - Result gotten: %i", result);
        NSLog(@"spTest - Result Initially gottent: %@", [[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"initialResult"]);
        NSLog(@"spTest - Expected Result: %@", [[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"trueCount"]);
        if ([[[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"trueCount"] intValue] == result) {
            NSLog(@"spTestResult - CORRECT FILE %i TYPE %@, Results => expected %@ == measured %i", i, [[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"testType"],  [[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"trueCount"], result);
        } else {
            int errorValue = (result - [[[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"trueCount"] intValue]);
            NSLog(@"spTestResult - WRONG   FILE %i TYPE %@, Results => expected %@ != measured %i >> %i", i, [[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"testType"], [[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"trueCount"], result, errorValue);
        }
        
        
        int errorValue = (result - [[[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"trueCount"] intValue]);
        int errorValueBefore = ([[[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"initialResult"] intValue] - [[[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"trueCount"] intValue]);
        totalNumberOfWrongAfter = totalNumberOfWrongAfter + abs(errorValue);
        totalNumberOfWrongBefore = totalNumberOfWrongBefore + abs(errorValueBefore);
        
        
        if (errorValue > 0) {
            totalNumberOfAddedAfter = totalNumberOfAddedAfter + errorValue;
            totalNumberOfFilesWrongAfter = totalNumberOfFilesWrongAfter + 1;
            [errorsAfter addObject:[NSString stringWithFormat:@"%i", errorValue]];
        } else if (errorValue < 0) {
            totalNumberOfOmitedAfter = totalNumberOfOmitedAfter + abs(errorValue);
            totalNumberOfFilesWrongAfter = totalNumberOfFilesWrongAfter + 1;
            [errorsAfter addObject:[NSString stringWithFormat:@"%i", errorValue]];
        }
        
        if (errorValueBefore > 0) {
            totalNumberOfAddedBefore = totalNumberOfAddedBefore + errorValueBefore;
            totalNumberOfFilesWrongBefore = totalNumberOfFilesWrongBefore + 1;
            [errorsBefore addObject:[NSString stringWithFormat:@"%i", errorValueBefore]];
        } else if (errorValueBefore < 0) {
            totalNumberOfOmitedBefore = totalNumberOfOmitedBefore + abs(errorValue);
            totalNumberOfFilesWrongBefore = totalNumberOfFilesWrongBefore + 1;
            [errorsBefore addObject:[NSString stringWithFormat:@"%i", errorValueBefore]];
        }
        
        float trueCount = [[[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"trueCount"] floatValue];
        float initialResult = [[[recordingsInfo objectForKey:[NSString stringWithFormat:@"%i", i]] objectForKey:@"initialResult"] floatValue];
        float correctnessBefore = (1 - (fabsf(initialResult - trueCount) / trueCount)) * 100;
        float correctnessAfter = (1 - (fabsf((float) result - trueCount) / trueCount)) * 100;
        float correctnessProgression = correctnessAfter - correctnessBefore;
        totalCorrectnessAfter = totalCorrectnessAfter + correctnessAfter;
        totalCorrectnessBefore = totalCorrectnessBefore + correctnessBefore;
        totalCorrectnessProgression = totalCorrectnessProgression + correctnessProgression;
        
        if (correctnessBefore != 100.0) {
            [errorsPercentageBefore addObject:[NSString stringWithFormat:@"%f",(100 - correctnessBefore)]];
        }
        
        if (correctnessAfter != 100.0) {
            [errorsPercentageAfter addObject:[NSString stringWithFormat:@"%f",(100 - correctnessAfter)]];
        }
        NSLog(@"spTest - Correctness before: %.2f", correctnessBefore);
        NSLog(@"spTest - Correctness after: %.2f", correctnessAfter);
        NSLog(@"spTest - Correctness progression: %.2f", correctnessProgression);
        
        //        NSLog(@"HYPSEG: %@", hypsegContent);
    }
    
    totalCorrectnessProgression = totalCorrectnessProgression / numberOfRecordings;
    totalCorrectnessAfter = totalCorrectnessAfter / numberOfRecordings;
    totalCorrectnessBefore = totalCorrectnessBefore / numberOfRecordings;
    
    NSLog(@"spTest - Total Correctness before: %.2f%%", totalCorrectnessBefore);
    NSLog(@"spTest - Total Correctness after: %.2f%%", totalCorrectnessAfter);
    NSLog(@"spTest - Total Correctness progression: %.2f\n\n%%", totalCorrectnessProgression);
    
    NSLog(@"spTest - Total number of files wrong before: %i", (int) totalNumberOfFilesWrongBefore);
    NSLog(@"spTest - Total number of files wrong after: %i\n", (int) totalNumberOfFilesWrongAfter);
    NSLog(@"spTest - Total number of wrong before: %i", (int) totalNumberOfWrongBefore);
    NSLog(@"spTest - Total number of wrong after: %i\n", (int) totalNumberOfWrongAfter);
    NSLog(@"spTest - Total number of utterances added before: %i", (int) totalNumberOfAddedBefore);
    NSLog(@"spTest - Total number of utterances added after: %i\n", (int) totalNumberOfAddedAfter);
    NSLog(@"spTest - Total number of utterances omitted before: %i", (int) totalNumberOfOmitedBefore);
    NSLog(@"spTest - Total number of utterances omitted after: %i", (int) totalNumberOfOmitedAfter);
    
    float avgErrorPercentBefore = 0.0;
    for (int i = 0; i < [errorsPercentageBefore count]; i++) {
        avgErrorPercentBefore += [[errorsPercentageBefore objectAtIndex:i] floatValue];
    }
    avgErrorPercentBefore = avgErrorPercentBefore / [errorsPercentageBefore count];
    
    float avgErrorPercentAfter = 0.0;
    for (int i = 0; i < [errorsPercentageAfter count]; i++) {
        avgErrorPercentAfter += [[errorsPercentageAfter objectAtIndex:i] floatValue];
    }
    avgErrorPercentAfter = avgErrorPercentAfter / [errorsPercentageAfter count];
    
    float avgErrorBefore = 0.0;
    for (int i = 0; i < [errorsBefore count]; i++) {
        avgErrorBefore += fabsf([[errorsBefore objectAtIndex:i] floatValue]);
    }
    avgErrorBefore = avgErrorBefore / [errorsBefore count];
    
    float avgErrorAfter = 0.0;
    for (int i = 0; i < [errorsAfter count]; i++) {
        avgErrorAfter += fabsf([[errorsAfter objectAtIndex:i] floatValue]);
    }
    avgErrorAfter = avgErrorAfter / [errorsAfter count];
    
    float stdDevErrorBefore = 0.0;
    for (int i = 0; i < [errorsBefore count]; i++) {
        stdDevErrorBefore += ([[errorsBefore objectAtIndex:i] floatValue]-avgErrorBefore) * ([[errorsBefore objectAtIndex:i] floatValue]-avgErrorBefore);
    }
    stdDevErrorBefore = sqrtf(stdDevErrorBefore/[errorsBefore count]);
    
    
    float stdDevErrorAfter = 0.0;
    for (int i = 0; i < [errorsAfter count]; i++) {
        stdDevErrorAfter += ([[errorsAfter objectAtIndex:i] floatValue]-avgErrorAfter) * ([[errorsAfter objectAtIndex:i] floatValue]-avgErrorAfter);
    }
    stdDevErrorAfter = sqrtf(stdDevErrorAfter/[errorsAfter count]);
    
    
    NSLog(@"spTest - Avg error percentage before: %.2f", avgErrorPercentBefore);
    NSLog(@"spTest - Avg error percentage after: %.2f", avgErrorPercentAfter);
    NSLog(@"spTest - Avg error before: %.2f", avgErrorBefore);
    NSLog(@"spTest - Avg error after: %.2f", avgErrorAfter);
    NSLog(@"spTest - Std dev error before: %.2f", stdDevErrorBefore);
    NSLog(@"spTest -  Std dev error after: %.2f", stdDevErrorAfter);
    
    for(NSString* error in errorsBefore) {
        NSLog(@"Error Before: %@", error);
    }
    
    for(NSString* error in errorsAfter) {
        NSLog(@"Error After: %@", error);
    }
    
}

-(void) isDoneRunningPocketSphinxBatchWithArguments:(NSString *)arguments returnValue:(int)retrurnValue {
    NSLog(@"***************************************************************************************************");
    // run the pocketsphinx results analysis
}

-(void) resultsAnalysis {
    // get the two files in Stirngs
    GlobalVars* globalVars = [GlobalVars sharedInstance];

    NSString *hyp = [globalVars.documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"seg.txt"]];
    NSString *hypseg = [globalVars.documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"log.txt"]];
    NSString* hypContent = [NSString stringWithContentsOfFile:hyp
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    NSString* hypsegContent = [NSString stringWithContentsOfFile:hypseg
                                                        encoding:NSUTF8StringEncoding
                                                           error:NULL];
    
    
    
    NSLog(@"HYP: %@", hypContent);
    NSLog(@"HYPSEG: %@", hypsegContent);
    
    // Get the times
    NSLog(@"HYPSEG: %@", hypsegContent);
    int count = 0;
    NSArray * hypsegContentArray = [hypsegContent componentsSeparatedByString:@" "];
    int len = (int) [hypsegContentArray count];
    for(int start=0;start<len-4;start=start+1){
        if ([hypsegContentArray[start] isEqualToString:@"Pa"] || [hypsegContentArray[start] isEqualToString:@"Ta"] || [hypsegContentArray[start] isEqualToString:@"Ka"]) {
            count = count + 1;
        }
    }
    
    
    NSMutableDictionary * timingDataMutableDictionnary = [[NSMutableDictionary alloc] initWithCapacity:count];
    int count2 = 0;
    for(int start=0;start<len-4;start=start+1){
        double start_time = 0.0;
        double end_time = 0.0;
        int correctness = 1;
        NSString* text = @"";
        NSLog(@"Count: %i", count2);
        NSLog(@"start: %i", start);
        NSLog(@"hypsegContentArray[start] (text): %@",hypsegContentArray[start]);
        NSLog(@"hypsegContentArray[start] (start time): %f",[hypsegContentArray[start-3] doubleValue]/100.0);
        NSLog(@"hypsegContentArray[start] (end time): %f",[hypsegContentArray[start+1] doubleValue]/100.0);
            start_time = [hypsegContentArray[start-3] doubleValue]/100.0;
        end_time = [hypsegContentArray[start+1] doubleValue]/100.0;
        text = hypsegContentArray[start];
        NSMutableDictionary* wordTimingDic = [[NSMutableDictionary alloc] initWithCapacity:4];
        [wordTimingDic setObject:[NSNumber numberWithDouble:start_time] forKey:@"startTime"];
        [wordTimingDic setObject:[NSNumber numberWithDouble:end_time] forKey:@"endTime"];
        [wordTimingDic setObject:text forKey:@"text"];
        [wordTimingDic setObject:[NSNumber numberWithInt:correctness] forKey:@"correctness"];
        [timingDataMutableDictionnary setObject:wordTimingDic forKey:[NSString stringWithFormat:@"%i",count2]];
        NSLog(@"Key: %i Text: %@ Start Time = %f End Time: %f", count2, text, start_time, end_time);
        count2 = count2 + 1;
    }
    
    
}

@end
