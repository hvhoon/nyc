//
//  AppDelegate.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *navigationController;
    DDMenuController *menuController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (retain, nonatomic) DDMenuController *menuController;
@end
