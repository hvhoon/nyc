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
@interface ActivityEventViewController : UIViewController<AddEventViewDelegate,UIScrollViewDelegate>{
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
    UIButton *goingButton;
    UIButton *DOS1Button;
    UIButton *DOS3Button;
    UIButton *DOS2Button;
    BOOL pageControlBeingUsed;
    int page;
    BOOL toggleFriends;
    BOOL toogleFriendsOfFriends;
    int colpseExpdType;
    BOOL touchDisable;

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
@end
