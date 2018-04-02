//
//  GlobalVars.h
//  PatakaApp
//
//  Created by Louis Daudet on 7/18/16.
//  Copyright © 2016 Notre Dame. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define kButtonTint [UIColor colorWithRed:(110.0f/255.0f) green:(161.0f/255.0f) blue:(170.0f/255.0f) alpha:1.0f]
#define kCheckBoxColor [UIColor colorWithRed:(155.0f/255.0f) green:(198.0f/255.0f) blue:(206.0f/255.0f) alpha:1.0f]
#define kCellTintColorReports [UIColor colorWithRed:(102.0f/255.0f) green:(183.0f/255.0f) blue:(163.0f/255.0f) alpha:0.5f]
//#define kBackGroundTint [UIColor colorWithRed:(214.0f/255.0f) green:(211.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f]
#define kMyRed [[UIColor redColor] colorWithAlphaComponent:0.6]
#define kBackGroundTint2 [UIColor colorWithRed:(102.0f/255.0f) green:(183.0f/255.0f) blue:(163.0f/255.0f) alpha:1.0f]
#define kBackGroundTint  [UIColor whiteColor]
#define kCellTintColor [UIColor colorWithRed:(102.0f/255.0f) green:(183.0f/255.0f) blue:(163.0f/255.0f) alpha:1.0f]
#define kButtonTint [UIColor whiteColor]
#define kTextColor [UIColor colorWithRed:(102.0f/255.0f) green:(183.0f/255.0f) blue:(163.0f/255.0f) alpha:1.0f]
#define kEmail @"info@speechlight.com"
#define kAnimationTime .2

#define buttonTint [UIColor colorWithRed:(140.0f/255.0f) green:(198.0f/255.0f) blue:(63.0f/255.0f) alpha:1.0f]
#define tabButtonBackGroundColor [[UIColor blackColor] colorWithAlphaComponent:.33]
#define reportsListViewBackGroudColor [UIColor colorWithRed:(74.0f/255.0f) green:(74.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f]

#define InAppPurchaseManagerDidReceiveProducts @"InAppPurchaseManagerDidReceiveProducts"
#define InAppPurchaseManagerDidPurchaseProduct @"InAppPurchaseManagerDidPurchaseProduct"
#define InAppPurchaseManagerPaymentFailed @"InAppPurchaseManagerPaymentFailed"
#define InAppPurchaseManagerReceiptVerificationFailed @"InAppPurchaseManagerReceiptVerificationFailed"
#define InAppPurchaseManagerRestoreFailed @"InAppPurchaseManagerRestoreFailed"
#define InAppPurchaseManagerRestoreSuccessfull @"InAppPurchaseManagerRestoreSuccessfull"
#define InAppPurchaseManagerStartChecking @"InAppPurchaseManagerStartChecking"

#define SubscriptionEndDateKey  @"subscriptionEndDate"
#define CellHeight  60

#define chronoOnlineAddress @"https://static.wixstatic.com/media/3d1970_4418f69d0c07496aa4cea10c1f900b70~mv2.png?dn=chrono_3x.png"
#define cakeOnlineAddress @"https://static.wixstatic.com/media/3d1970_43aafc78374447c48b4ff8f3a5932454~mv2.png?dn=cake_3x.png"
#define calendarOnlineAddress @"https://static.wixstatic.com/media/3d1970_013b32c4fe08402f92a046df765badeb~mv2.png?dn=calendar_3x.png"

@interface GlobalVars : NSObject

+ (GlobalVars *)sharedInstance;
- (void) refreshTestTimes;
- (void) save;

// Display constants
@property(nonatomic, readwrite) int statusBarHeight;
@property(nonatomic, readwrite) int navBarHeight;
@property(nonatomic, readwrite) int tabBarHeight;
@property(nonatomic, readwrite) int screenWidth;
@property(nonatomic, readwrite) int screenHeight;

// Tests constants
@property(nonatomic, readwrite) int timeTest;
@property(nonatomic, readwrite) int gender;
@property(nonatomic, readwrite) BOOL isTestTimed;
@property(nonatomic, readwrite) BOOL hasTestJustBeenTaken;
@property(nonatomic, readwrite) NSString* birthdate;
@property(nonatomic, readwrite) NSString* inAppPurchaseManagerError;

// System constants
@property(nonatomic, readwrite) NSString* documentDirectoryPath;
@property(nonatomic, readwrite) NSString* parametersFilePath;
@property(nonatomic, readwrite) NSString* reportsFilePath;
@property(nonatomic, readwrite) NSString* htmlFolderFilePath;
@property(nonatomic, readwrite) NSString* recordingsFolderFilePath;


@end
