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
#import "PostActivityRequestInvocation.h"
@class MainServiceManager;
@class NotificationClass;
@protocol NotificationsScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;

@end

@interface NotificationsViewController : UIViewController<WaitingOnYouDelegate,MBProgressHUDDelegate,DetailedActivityInfoInvocationDelegate,GetNotificationsInvocationDelegate,PostActivityRequestInvocationDelegate,UIViewControllerRestoration>{
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
    int calendarInc;
    NSMutableArray*calendarArray;
    BOOL isSyncing;
    NSArray*notificationListingArray;
}
@property (nonatomic,retain)id <NotificationsScreenViewDelegate>delegate;
@property(nonatomic, retain)NotificationClass *notIdObject;
@property(nonatomic, retain)NSArray*notificationListingArray;
@property (nonatomic,assign)BOOL isPushedFromStack;
-(IBAction)profileSliderPressed:(id)sender;
-(void)startAnimation:(int)tag;
-(void)getUserNotifications;
@end
