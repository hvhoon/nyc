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
#import "NotificationsViewController.h"


@class FacebookLogin;
@class TTTAttributedLabel;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
    UINavigationController *navigationController;
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
    BOOL resetSuccess;
    BOOL _appIsInbackground;
    
    NSMutableData *responsedata;
    
    UIBackgroundTaskIdentifier bgTask;
    MainServiceManager *devServer;
    SoclivityManager *SOC;
    
    dispatch_queue_t currentBackgroundQueue;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, assign) BOOL resetSuccess;
@property (nonatomic, retain) TTTAttributedLabel *summaryLabel;
@property(nonatomic, retain) NSMutableData *responsedata;
@property (nonatomic, retain)RRAViewController *objrra;
@property(nonatomic, retain)UIView *vw_notification;
@property(nonatomic, retain)NSMutableDictionary *dict_notification;
@property (nonatomic, retain) NotificationsViewController *superDelegate;

-(FacebookLogin*)SetUpFacebook;
- (void)setUpActivityDataList;
-(void)IncreaseBadgeIcon;
-(void)PostBackgroundStatus;

@end
