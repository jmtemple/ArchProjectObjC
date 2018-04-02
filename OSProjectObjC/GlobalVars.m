//
//  GlobalVars.m
//  PatakaApp
//
//  Created by Louis Daudet on 7/18/16.
//  Copyright © 2016 Notre Dame. All rights reserved.
//

#import "GlobalVars.h"
#import "GlobalFunctions.h"

@implementation GlobalVars

int defaultTime = 5;

+ (GlobalVars *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalVars *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVars alloc] init];
    });
    return instance;
}

- (void) refreshTestTimes {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString  *parametersDictionaryPath= [[paths objectAtIndex:0] stringByAppendingPathComponent:@"parameters.txt"];
    NSMutableDictionary *parametersDictionnary = [NSMutableDictionary dictionaryWithContentsOfFile:parametersDictionaryPath];
    if (parametersDictionnary) {
        _timeTest = [[parametersDictionnary objectForKey:@"timeTest"] intValue];
        _birthdate = [parametersDictionnary objectForKey:@"birthDate"];
        _isTestTimed = [[parametersDictionnary objectForKey:@"isTestTimed"] intValue];
        _gender = [[parametersDictionnary objectForKey:@"gender"] intValue];
    } else {
        _timeTest = defaultTime;
        _isTestTimed = 1;
        _gender = 1;
        _birthdate = @"";
    }
}

- (void)save{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString  *parametersDictionaryPath= [[paths objectAtIndex:0] stringByAppendingPathComponent:@"parameters.txt"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[NSString stringWithFormat:@"%i",_timeTest] forKey:@"timeTest"];
    [parameters setValue:[NSString stringWithFormat:@"%i",(_isTestTimed ? 1 : 0)] forKey:@"isTestTimed"];
    [parameters setValue:[NSString stringWithFormat:@"%i",(_gender ? 1 : 0)] forKey:@"isTestTimed"];
    [parameters setObject:_birthdate forKey:@"birthDate"];
    [[NSFileManager defaultManager] removeItemAtPath:parametersDictionaryPath error:nil];
    [parameters writeToFile:parametersDictionaryPath atomically:YES];
}


- (id)init {
    self = [super init];
    if (self) {
        _statusBarHeight = 0;
        _navBarHeight = 0;
        _tabBarHeight = 0;
        _screenHeight = 0;
        _screenWidth = 0;
        
        
        _birthdate  = @"Enter Birthdate";

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        _documentDirectoryPath = paths[0];
//        _parametersFilePath = [_documentDirectoryPath stringByAppendingPathComponent:@"parameters.txt"];
//        _reportsFilePath = [_documentDirectoryPath stringByAppendingPathComponent:@"reports.txt"];
//        _htmlFolderFilePath = [_documentDirectoryPath stringByAppendingPathComponent:@"Html/"];
//        _recordingsFolderFilePath = [_htmlFolderFilePath stringByAppendingPathComponent:@"Recordings/"];
       
        _parametersFilePath = @"parameters.txt";
        _reportsFilePath = @"reports.txt";
        _htmlFolderFilePath = @"Html/";
        _recordingsFolderFilePath = @"Recordings/";
        
        NSLog(@"%@", _documentDirectoryPath);
        NSMutableDictionary *parametersDictionnary = [NSMutableDictionary dictionaryWithContentsOfFile:[_documentDirectoryPath stringByAppendingPathComponent:_parametersFilePath]];
        if (parametersDictionnary) {
            _timeTest = [[parametersDictionnary objectForKey:@"timeTest"] intValue];
            _isTestTimed = [[parametersDictionnary objectForKey:@"isTestTimed"] intValue];
            _gender = [[parametersDictionnary objectForKey:@"gender"] intValue];
        } else {
            _timeTest = defaultTime;
            _isTestTimed = 1;
            _gender = 1;
        }
        _hasTestJustBeenTaken = FALSE;
    }
    return self;
}

@end
