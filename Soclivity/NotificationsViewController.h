//
//  NotificationsViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingOnYouView.h"
#import "MBProgressHUD.h"
#import "GetNotificationsInvocation.h"
#import "NotifyAnimationView.h"
#import "PostActivityRequestInvocation.h"
@class MainServiceManager;
@protocol NotificationsScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;

@end

@interface NotificationsViewController : UIViewController<WaitingOnYouDelegate,MBProgressHUDDelegate,DetailedActivityInfoInvocationDelegate,GetNotificationsInvocationDelegate,PostActivityRequestInvocationDelegate,NotifyAnimationViewDelegate>{
    id <NotificationsScreenViewDelegate>delegate;
    IBOutlet UILabel *waitingOnYouLabel;
    MBProgressHUD *HUD;
    MainServiceManager *devServer;
    IBOutlet UIButton *btnnotify;
    WaitingOnYouView *notificationView;
    IBOutlet UIButton *sliderButton;
    IBOutlet UIButton *backButton;
    BOOL isPushedFromStack;
    IBOutlet UIButton *btnnotify2;
}
@property (nonatomic,retain)id <NotificationsScreenViewDelegate>delegate;
@property(copy, readwrite)NSString *notId;
@property (nonatomic,assign)BOOL isPushedFromStack;
-(IBAction)profileSliderPressed:(id)sender;
-(void)startAnimation:(int)tag;

@end
