//
//  ActivityEventViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventView.h"
#import "ParticipantListTableView.h"
#import "NotifyAnimationView.h"
#import "DetailedActivityInfoInvocation.h"
#import "ChatActivityView.h"
#import "CameraCustom.h"
#import "ChatServiceInvocation.h"
@class InfoActivityClass;
@class SoclivityManager;
@class MainServiceManager;
@class MBProgressHUD;
@class ActivityChatData;
@class NotificationClass;
@interface ActivityEventViewController : UIViewController<AddEventViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,ParticipantListDelegate,NotifyAnimationViewDelegate,DetailedActivityInfoInvocationDelegate,ChatActivityViewDelegate,UIActionSheetDelegate,CustomCameraUploadDelegate,ChatServiceInvocationDelegate,UIViewControllerRestoration>{
    IBOutlet UIScrollView* scrollView;
    IBOutlet AddEventView *eventView;
    IBOutlet ParticipantListTableView *participantListTableView;
    InfoActivityClass *activityInfo;
    IBOutlet UIView *staticToggleView;
    IBOutlet UIButton *activityButton;
    IBOutlet UIButton *chatButton;
    IBOutlet UILabel *activityNameLabel;
    IBOutlet UIButton *addEventButton;
    IBOutlet UIButton *leaveActivityButton;
    IBOutlet UIButton *cancelRequestActivityButton;
    IBOutlet UIButton *organizerEditButton;
    IBOutlet UIButton *goingActivityButton;
    IBOutlet UIButton *notGoingActivityButton;
    IBOutlet UIButton *inviteUsersToActivityButton;
    IBOutlet UIButton *blankInviteUsersAnimationButton;
    IBOutlet UIActivityIndicatorView *spinnerView;
    IBOutlet UIButton *reportButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *newActivityButton;
    UIButton *goingButton;
    UIButton *DOS1Button;
    UIButton *DOS3Button;
    UIButton *DOS2Button;
    UIImageView *DOS1ButtonHighlight;
    UIImageView *DOS2ButtonHighlight;
    UIImageView *DOS3ButtonHighlight;
    BOOL pageControlBeingUsed;
    int page;
    BOOL toggleFriends;
    int lastIndex;
    IBOutlet UIView *staticView;
    IBOutlet ChatActivityView *chatView;
    BOOL footerActivated;
    IBOutlet UIButton *backToActivityFromMapButton;
    SoclivityManager *SOC;
    IBOutlet UIButton *locationEditLeftCrossButton;
    IBOutlet UIButton *locationEditRightCheckButton;
    IBOutlet UIButton *currentLocationInMap;
    IBOutlet UIButton *editButtonForMapView;
    BOOL inTransition;
    MainServiceManager *devServer;
    MBProgressHUD *HUD;
    NotificationClass *notIdObject;
    

    
    //chat
    
    IBOutlet UIButton *enterChatTextButton;
    IBOutlet UILabel *commentChatLabel;
    IBOutlet UIButton *postChatImageButton;
    IBOutlet UILabel *imagePostChatlabel;
    IBOutlet UIButton *resignTextDoneButton;
    CameraCustom *cameraUpload;
    
    int tapType;
    BOOL enable;
    int menuSection;
    ActivityChatData *menuChat;
    int removeChatIndex;
    IBOutlet UIImageView *topBarImageView;
    IBOutlet UIImageView *bottomBarImageView;
}
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic,retain)InfoActivityClass *activityInfo;
@property (nonatomic,assign)BOOL footerActivated;
@property(nonatomic,retain)    NotificationClass *notIdObject;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)addEventActivityPressed:(id)sender;
-(IBAction)leaveEventActivityPressed:(id)sender;
-(IBAction)createANewActivityButtonPressed:(id)sender;
-(IBAction)goingActivityButtonPressed:(id)sender;
-(IBAction)notGoingActivityButtonPressed:(id)sender;
-(IBAction)reportButtonPressed:(id)sender;
-(IBAction)inviteUsersButton:(id)sender;
-(IBAction)editButtonClicked:(id)sender;
-(IBAction)chatButtonPressed:(id)sender;
-(IBAction)cancelRequestButtonPressed:(id)sender;
-(void)scrollViewToTheTopOrBottom;
-(void)highlightSelection:(int)selection;
-(void)BottonBarButtonHideAndShow:(NSInteger)type;
-(IBAction)backToActivityAnimateTransition:(id)sender;
-(IBAction)crossClickedInLocationEdit:(id)sender;
-(IBAction)tickClickedInLocationEdit:(id)sender;
-(IBAction)currentLocationBtnClicked:(id)sender;
-(void)startAnimation:(int)type;
-(IBAction)editViewToChangeActivityLocation:(id)sender;
-(IBAction)enterChatTextButtonPressed:(id)sender;
-(IBAction)postImageOnChatScreenPressed:(id)sender;
-(IBAction)resignTextDonePressed:(id)sender;
-(void)startUpdatingChat;
-(void)postAImageOnTheServer:(UIImage*)image;
@end
