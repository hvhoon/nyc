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
@class InfoActivityClass;
@class SoclivityManager;
@interface ActivityEventViewController : UIViewController<AddEventViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    IBOutlet UIScrollView* scrollView;
    IBOutlet AddEventView *eventView;
    IBOutlet ParticipantListTableView *participantListTableView;
    InfoActivityClass *activityInfo;
    IBOutlet UIButton *chatButton;
    IBOutlet UILabel *activityNameLabel;
    IBOutlet UIButton *addEventButton;
    IBOutlet UIButton *leaveActivityButton;
    IBOutlet UIButton *cancelRequestActivityButton;
    IBOutlet UIButton *organizerEditButton;
    IBOutlet UIButton *goingActivityButton;
    IBOutlet UIButton *notGoingActivityButton;
    IBOutlet UIButton *inviteUsersToActivityButton;
    IBOutlet UIButton *crossEditButton;
    IBOutlet UIButton *tickEditButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *newActivityButton;
    IBOutlet UIButton *deleteActivityButton;
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
    IBOutlet UIView *chatView;
    BOOL footerActivated;
    IBOutlet UIButton *backToActivityFromMapButton;
    SoclivityManager *SOC;
    IBOutlet UIButton *locationEditLeftCrossButton;
    IBOutlet UIButton *locationEditRightCheckButton;
    IBOutlet UIButton *currentLocationInMap;
    IBOutlet UIButton *editButtonForMapView;
}
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic,retain)InfoActivityClass *activityInfo;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)addEventActivityPressed:(id)sender;
-(IBAction)leaveEventActivityPressed:(id)sender;
-(IBAction)createANewActivityButtonPressed:(id)sender;
-(IBAction)goingActivityButtonPressed:(id)sender;
-(IBAction)notGoingActivityButtonPressed:(id)sender;
-(IBAction)inviteUsersButton:(id)sender;
-(IBAction)editButtonClicked:(id)sender;
-(IBAction)chatButtonPressed:(id)sender;
-(IBAction)cancelRequestButtonPressed:(id)sender;
-(void)scrollViewToTheTopOrBottom;
-(void)highlightSelection:(int)selection;
-(void)BottonBarButtonHideAndShow:(NSInteger)type;
-(IBAction)crossClickedByOrganizer:(id)sender;
-(IBAction)tickClickedByOrganizer:(id)sender;
-(IBAction)deleteActivtyPressed:(id)sender;
-(IBAction)backToActivityAnimateTransition:(id)sender;
-(IBAction)crossClickedInLocationEdit:(id)sender;
-(IBAction)tickClickedInLocationEdit:(id)sender;
-(IBAction)currentLocationBtnClicked:(id)sender;
-(IBAction)editViewToChangeActivityLocation:(id)sender;
@end
