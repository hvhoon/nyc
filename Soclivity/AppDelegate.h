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
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
    UINavigationController *navigationController;
    DDMenuController *menuController;
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (retain, nonatomic) DDMenuController *menuController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
-(FacebookLogin*)SetUpFacebook;
@end
