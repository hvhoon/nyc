//
//  AppDelegate.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "RRAViewController.h"
#import "MainServiceManager.h"
#import "SoclivityManager.h"
#import "AutoSessionClass.h"
@class FacebookLogin;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,AutoSessionClassDelegate>{
    UINavigationController *navigationController;
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
    BOOL resetSuccess;
    NSMutableData *responsedata;
    UIBackgroundTaskIdentifier bgTask;
    MainServiceManager *devServer;
    SoclivityManager *SOC;
    dispatch_queue_t currentBackgroundQueue;
    int status;
    id listViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, assign) BOOL resetSuccess;
@property (nonatomic, retain)RRAViewController *objrra;
@property(nonatomic, retain)NSMutableDictionary *dict_notification;
@property (nonatomic,assign) BOOL onlyOnce;
@property (nonatomic,retain)id listViewController;
-(FacebookLogin*)SetUpFacebook;
- (void)setUpActivityDataList;
-(void)IntimateServerForAPNSOrRocketSocket;

@end
