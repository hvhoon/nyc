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
@class FacebookLogin;
@class SlideViewController;
@class TTTAttributedLabel;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
    UINavigationController *navigationController;
    DDMenuController *menuController;
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
    BOOL resetSuccess;
    BOOL _appIsInbackground;
    
    NSMutableData *responsedata;
    
    UIBackgroundTaskIdentifier bgTask;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (retain, nonatomic) DDMenuController *menuController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, assign) BOOL resetSuccess;
@property (nonatomic, retain) TTTAttributedLabel *summaryLabel;

@property(nonatomic, retain) NSMutableData *responsedata;

@property(nonatomic, retain)UIView *vw_notification;

-(FacebookLogin*)SetUpFacebook;
- (void)setUpActivityDataList;
-(void)IncreaseBadgeIcon;
@end
