//
//  InvitesViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInvitesView.h"
#import "ContactsListViewController.h"
#import "UserContactList.h"
#import "NotifyAnimationView.h"
@class MBProgressHUD;
@class MainServiceManager;
@class SoclivityManager;
@protocol InvitesViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end

@interface InvitesViewController : UIViewController<ActivityInvitesViewDelegate,ContactsListViewDelegate,UserContactListDelegate,NotifyAnimationViewDelegate>{
    id <InvitesViewDelegate>delegate;
    IBOutlet UIButton*settingsButton;
    IBOutlet UIButton*activityBackButton;
    IBOutlet UILabel *inviteTitleLabel;
    IBOutlet UILabel *openSlotsNoLabel;
    NSInteger num_of_slots;
    NSString *activityName;
    BOOL inviteFriends;
    ActivityInvitesView *activityInvites;
    NSArray *inviteArray;
    MBProgressHUD *HUD;
    MainServiceManager *devServer;
    NSInteger activityId;
    SoclivityManager *SOC;
    IBOutlet UIButton*btnnotify;
}
@property (nonatomic,retain)id <InvitesViewDelegate>delegate;
@property (nonatomic,retain)ActivityInvitesView *activityInvites;
@property (nonatomic,retain)UIButton*settingsButton;
@property (nonatomic,retain)UIButton*activityBackButton;
@property (nonatomic,retain)UILabel *inviteTitleLabel;
@property (nonatomic,retain)UILabel *openSlotsNoLabel;
@property (nonatomic,assign)NSInteger num_of_slots;
@property (nonatomic,retain)NSString *activityName;
@property (nonatomic,assign)BOOL inviteFriends;
@property (nonatomic,retain)NSArray *inviteArray;
@property (nonatomic,assign)NSInteger activityId;

-(IBAction)profileSliderPressed:(id)sender;
-(IBAction)popBackToActivityScreen:(id)sender;
-(void)startAnimation:(int)type;
-(void)hideMBProgress;
@end
