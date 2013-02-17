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
@class WaitingOnYouView;
@protocol NotificationsScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;

@end

@interface NotificationsViewController : UIViewController<WaitingOnYouDelegate,MBProgressHUDDelegate,DetailedActivityInfoInvocationDelegate,GetNotificationsInvocationDelegate,PostActivityRequestInvocationDelegate>{
    id <NotificationsScreenViewDelegate>delegate;
    IBOutlet UILabel *waitingOnYouLabel;
    IBOutlet UIImageView*notificationImageView;
    IBOutlet UIImageView*socFadedImageView;
    MBProgressHUD *HUD;
    MainServiceManager *devServer;
    IBOutlet UIButton *btnnotify;
    WaitingOnYouView *notificationView;
}
@property (nonatomic,retain)id <NotificationsScreenViewDelegate>delegate;
@property(copy, readwrite)NSString *notId;

-(IBAction)profileSliderPressed:(id)sender;
-(void)startAnimation:(int)tag;

@end
