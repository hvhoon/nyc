//
//  AppDelegate.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "FBConnect.h"
#import "RRAViewController.h"
#import "MainServiceManager.h"
#import "SoclivityManager.h"
#import "DetailedActivityInfoInvocation.h"


@class FacebookLogin;
@class SlideViewController;
@class TTTAttributedLabel;
@class MainServiceManager;
@class SoclivityManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,DetailedActivityInfoInvocationDelegate>{
    UINavigationController *navigationController;
    DDMenuController *menuController;
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
    BOOL resetSuccess;
    BOOL _appIsInbackground;
    
    NSMutableData *responsedata;
    
    UIBackgroundTaskIdentifier bgTask;
    MainServiceManager *devServer;
    SoclivityManager *SOC;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (retain, nonatomic) DDMenuController *menuController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, assign) BOOL resetSuccess;
@property (nonatomic, retain) TTTAttributedLabel *summaryLabel;
@property(nonatomic, retain) NSMutableData *responsedata;
@property (nonatomic, retain)RRAViewController *objrra;

@property(nonatomic, retain)UIView *vw_notification;

-(FacebookLogin*)SetUpFacebook;
- (void)setUpActivityDataList;
-(void)IncreaseBadgeIcon;
-(void)PostBackgroundStatus:(int)status;
 //-(void)registerForNotifications;
@end
