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

@class MBProgressHUD;
@class MainServiceManager;

@protocol NotificationsScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end

@interface NotificationsViewController : UIViewController<WaitingOnYouDelegate,MBProgressHUDDelegate,DetailedActivityInfoInvocationDelegate,GetActivitiesInvocationDelegate>{
    id <NotificationsScreenViewDelegate>delegate;
    IBOutlet UILabel *waitingOnYouLabel;
    IBOutlet UIImageView*notificationImageView;
    IBOutlet UIImageView*socFadedImageView;
    
    NSMutableData *responsedata;
    
    NSMutableArray *arrnotification;
    
    UIActionSheet * loadingActionSheet;
    
    MBProgressHUD *HUD;
    MainServiceManager *devServer;
    
    WaitingOnYouView *notificationView;
}
@property (nonatomic,retain)id <NotificationsScreenViewDelegate>delegate;
@property(nonatomic, retain) NSMutableData *responsedata;
@property(nonatomic, retain) NSMutableArray *arrnotification;
@property (nonatomic, retain)IBOutlet UIButton *btnnotify;

//@property (nonatomic, retain) WaitingOnYouView *waitingonyouviewdelegate;

@property(copy, readwrite)NSString *lstrnotificationtypeid;

-(IBAction)profileSliderPressed:(id)sender;
//-(NSMutableArray*) SetUpNotifications;

-(void)startAnimation;
-(void)hideMBProgress;

-(void) navigate:(NSMutableDictionary*)dict;
-(void)synchronousDownloadProfilePhotoBytes:(InfoActivityClass*)player;

@end
