//
//  ActivityEventViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityEventViewController.h"
#import "SoclivityUtilities.h"
#import "InfoActivityClass.h"
#import "SoclivitySqliteClass.h"
#import "SoclivityManager.h"
#import "InvitesViewController.h"
#import "MainServiceManager.h"
#import "EditActivityEventInvocation.h"
#import "MBProgressHUD.h"
#import "PostActivityRequestInvocation.h"
#import "GetPlayersClass.h"
#import "SocPlayerClass.h"
#import "SOCProfileViewController.h"
#import "UpComingCompletedEventsViewController.h"
#import "ParticipantClass.h"
#import "GetActivityInvitesInvocation.h"
#import "CreateActivityViewController.h"
#import "NotificationClass.h"
#import "MessageInputView.h"
#import "ActivityChatData.h"
#import "FeedbackBugReport.h"

#define kEditMapElements 10
#define kJoinRequest 11
#define kCancelPendingRequest 13
#define kConfirmPresenceRequest 14
#define kSorryNotGoingRequest 15
#define kLeavingActivityRequest 16
#define kPlayerConfirmedRequest 17
#define kDeclinePlayerRequest 18
#define kRemovePlayerRequest 19
#define kLeaveActivity 20
#define kActivityLabel 21
#define kChatPostRequest 22
#define kChatPostMessageRequest 23
#define kChatPostDelete 24

@interface ActivityEventViewController (private)<EditActivityEventInvocationDelegate,MBProgressHUDDelegate,PostActivityRequestInvocationDelegate,GetActivityInvitesInvocationDelegate,NewActivityViewDelegate>
@end

@implementation ActivityEventViewController
@synthesize activityInfo,scrollView,footerActivated,notIdObject;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatInAppNotification:) name:@"ChatNotification" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (getDeltaUpdateInbackground) name:@"ChatDeltaUpdate" object:nil];

    


    [self.navigationController.navigationBar setHidden:YES];
}


-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoteNotificationReceivedWhileRunning" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatDeltaUpdate" object:nil];
    
    
    
}


-(void)getDeltaUpdateInbackground{
    if([chatView.bubbleData count]==0)
    [devServer chatPostsOnActivity:activityInfo.activityId chatId:0 delegate:self message:nil chatRequest:6 imageToPost:nil];
    else{
        ActivityChatData *lastObject=[chatView.bubbleData lastObject];
        [devServer chatPostsOnActivity:activityInfo.activityId chatId:lastObject.chatId delegate:self message:nil chatRequest:6 imageToPost:nil];

    }

}

-(void)deltaPostInBackground:(NSArray*)responses{
    if([responses count]!=0){
        if([chatView.bubbleData count]==0){
            [chatView updateDeltaChatWithNewData:[NSMutableArray arrayWithArray:responses]];
        }
        else{
            [chatView postsNewUpdateOnChatScreen:[NSMutableArray arrayWithArray:responses]];
        }
    }
}
#pragma mark - View lifecycle

- (void)didReceiveBackgroundNotification:(NSNotification*) note{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:note];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 58) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
}
-(void)chatInAppNotification:(NSNotification*)note{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationChatPost:note];
    if(notifObject.activityId==activityInfo.activityId)
    
    [devServer chatPostsOnActivity:activityInfo.activityId chatId:notifObject.notificationId delegate:self message:nil chatRequest:5 imageToPost:nil];
    else{
        NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 58) andNotif:notifObject];
        notif.delegate=self;
        [self.view addSubview:notif];

    }
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_6_0)){
    self.restorationIdentifier = @"ActivityEventViewController";
    self.restorationClass = [self class];
        }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        topBarImageView.frame=CGRectMake(0, 0, 320, 64);
        topBarImageView.image=[UIImage imageNamed:@"topbarIOS7.png"];
        activityNameLabel.frame=CGRectMake(56, 27, 209, 29);
        resignTextDoneButton.frame=CGRectMake(262, 20, 50, 44);
        leaveActivityButton.frame=CGRectMake(262, 20, 50, 44);
        organizerEditButton.frame=CGRectMake(262, 20, 50, 44);
        editButtonForMapView.frame=CGRectMake(262, 20, 50, 44);
        backButton.frame=CGRectMake(5, 20, 40, 40);
        backToActivityFromMapButton.frame=CGRectMake(5, 20, 40, 40);
        locationEditLeftCrossButton.frame=CGRectMake(262, 20, 50, 44);
        if([SoclivityUtilities deviceType] & iPhone5){
            
            locationEditRightCheckButton.frame=CGRectMake(127, 420+88+20, 65, 40);
            staticView.frame=CGRectMake(0, 64, 320, 436);
            bottomBarImageView.frame=CGRectMake(0, 568-40, 320, 40);
            addEventButton.frame=CGRectMake(121,441+88, 79, 39);
            staticToggleView.frame=CGRectMake(275,440+88, 40, 40);
            cancelRequestActivityButton.frame=CGRectMake(89,441+88, 143, 39);
            goingActivityButton.frame=CGRectMake(73,440+88, 90, 40);
            notGoingActivityButton.frame=CGRectMake(160,440+88, 90, 40);
            inviteUsersToActivityButton.frame=CGRectMake(5,440+88, 40, 40);
            currentLocationInMap.frame=CGRectMake(5,440+88, 40, 40);
            spinnerView.frame=CGRectMake(15,450+88, 20, 20);
            enterChatTextButton.frame=CGRectMake(108,441+88, 104, 39);
            postChatImageButton.frame=CGRectMake(5,440+88, 40, 40);
            reportButton.frame=CGRectMake(5,440+88, 40, 40);
        }
        else{
             locationEditRightCheckButton.frame=CGRectMake(127, 420+20, 65, 40);
            staticView.frame=CGRectMake(0, 64, 320, 396);
            bottomBarImageView.frame=CGRectMake(0, 568-40-88, 320, 40);
            addEventButton.frame=CGRectMake(121,441, 79, 39);
            staticToggleView.frame=CGRectMake(275,440, 40, 40);
            cancelRequestActivityButton.frame=CGRectMake(89,441, 143, 39);
             goingActivityButton.frame=CGRectMake(73,440, 90, 40);
            notGoingActivityButton.frame=CGRectMake(160,440+88, 90, 40);
            inviteUsersToActivityButton.frame=CGRectMake(5,440, 40, 40);
            currentLocationInMap.frame=CGRectMake(5,440, 40, 40);
            spinnerView.frame=CGRectMake(15,450, 20, 20);
            enterChatTextButton.frame=CGRectMake(108,441, 104, 39);
            postChatImageButton.frame=CGRectMake(5,440, 40, 40);
            reportButton.frame=CGRectMake(5,440, 40, 40);

        }
        
    }
    else{
        topBarImageView.autoresizesSubviews = YES;
        topBarImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        topBarImageView.frame=CGRectMake(0, 0, 320, 44);
        if([SoclivityUtilities deviceType] & iPhone5){
            
            bottomBarImageView.frame=CGRectMake(0, 548-40, 320, 40);
            
        }
        else{
            bottomBarImageView.frame=CGRectMake(0, 548-40-88, 320, 40);
        }
        
    }

    toggleFriends=TRUE;
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];
    lastIndex=-1;
    [spinnerView stopAnimating];
    [spinnerView setHidden:YES];
    
    commentChatLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    commentChatLabel.textColor=[UIColor whiteColor];
    commentChatLabel.backgroundColor=[UIColor clearColor];
    commentChatLabel.text=@"Comment";
    
    imagePostChatlabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    imagePostChatlabel.textColor=[UIColor whiteColor];
    imagePostChatlabel.backgroundColor=[UIColor clearColor];
    imagePostChatlabel.text=@"Image";
    
    chatView.delegate=self;
    [self startUpdatingChat];
    
#if 0
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,464)];
    
    scrollView.clipsToBounds = YES;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator =NO;
    scrollView.alwaysBounceVertical= YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
#endif

    scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    scrollView.clipsToBounds = YES;
    
    if([activityInfo.goingCount intValue]==1 && activityInfo.pendingRequestCount==0){
        scrollView.scrollEnabled=NO;
    }
    else if([activityInfo.goingCount intValue]==2 && (activityInfo.activityRelationType==5)){
        scrollView.scrollEnabled=NO;        
    }
    else{
    scrollView.scrollEnabled = YES;
    }
    
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator =NO;
    scrollView.alwaysBounceVertical= YES;
    scrollView.delegate = self;
    scrollView.bounces=NO;
    
    eventView.delegate=self;
    participantListTableView.delegate=self;
    participantListTableView.tableActivityInfo=activityInfo;
    participantListTableView.activityLinkIndex=activityInfo.activityRelationType;
    participantListTableView.participantTableView.bounces=NO;
    if(page==0){
        participantListTableView.participantTableView.scrollEnabled=NO;
    }
     participantListTableView.participantTableView.clipsToBounds=YES;
    
    
    for (int i = 0; i < 2; i++) {
		CGRect frame;
		frame.origin.x = 0;
        frame.origin.y = self.scrollView.frame.size.height*i+44.0f;
		frame.size = self.scrollView.frame.size;
		
        switch (i) {
            case 0:
            {
            if([SoclivityUtilities deviceType] & iPhone5){
                eventView.frame=CGRectMake(0, 0, 640, 329+88);
            }
            else{
                eventView.frame=CGRectMake(0, 0, 640, 329);
            }
                [self.scrollView addSubview:eventView];
                
             }
                break;
            case 1:
            {
                int delta=0;

                UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, delta, 320, 48)];
                headerView.backgroundColor=[SoclivityUtilities returnBackgroundColor:6];
                
                UIButton *pArrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
                pArrowButton.frame=CGRectMake(2,delta+4,33,40);
                [pArrowButton setBackgroundImage:[UIImage imageNamed:@"S05_participantArrow"] forState:UIControlStateNormal];
                [pArrowButton addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                pArrowButton.tag=103;
                [headerView addSubview:pArrowButton];
                
                // People going section in the participant bar
                goingButton=[UIButton buttonWithType:UIButtonTypeCustom];
                goingButton.frame=CGRectMake(35,delta,55,47);
                [goingButton addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                goingButton.tag=104;
                [headerView addSubview:goingButton];
                
                
                CGRect goingCountLabelRect=CGRectMake(35,delta+11,55,12);
                UILabel *goingCountLabel=[[UILabel alloc] initWithFrame:goingCountLabelRect];
                goingCountLabel.textAlignment=NSTextAlignmentCenter;
                goingCountLabel.text=[NSString stringWithFormat:@"%@",activityInfo.goingCount];
                goingCountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingCountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingCountLabel.tag=235;
                goingCountLabel.backgroundColor=[UIColor clearColor];
                
                
                CGRect goingLabelTextRect=CGRectMake(35,delta+26,55,12);
                UILabel *goingTextLabel=[[UILabel alloc] initWithFrame:goingLabelTextRect];
                goingTextLabel.textAlignment=NSTextAlignmentCenter;
                goingTextLabel.text=[NSString stringWithFormat:@"GOING"];
                goingTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingTextLabel.tag=236;
                goingTextLabel.backgroundColor=[UIColor clearColor];
                
                if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount>0){
                
                    goingCountLabel.text=[NSString stringWithFormat:@"%d",activityInfo.pendingRequestCount];
                    goingTextLabel.text=[NSString stringWithFormat:@"REQUESTS"];
                    goingCountLabel.textColor=[UIColor redColor];
                    goingTextLabel.textColor=[UIColor redColor];

               }
                
                [headerView addSubview:goingCountLabel];
                [headerView addSubview:goingTextLabel];
                [goingCountLabel release];
                [goingTextLabel release];
                
                // Friends going section in the participant bar
                DOS1Button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                DOS1Button.frame=CGRectMake(95,delta,75,47);
                DOS1Button.backgroundColor = [UIColor clearColor];
                [headerView addSubview:DOS1Button];
                
                CGRect DOS_1LabelRect=CGRectMake(100,delta+11,25,12);
                UILabel *DOS_1countLabel=[[UILabel alloc] initWithFrame:DOS_1LabelRect];
                DOS_1countLabel.textAlignment=NSTextAlignmentRight;
                DOS_1countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS1];
                DOS_1countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_1countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_1countLabel.tag=237;
                DOS_1countLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:DOS_1countLabel];
                [DOS_1countLabel release];
                
                UIImageView *DOS_1ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallDOS1.png"]];
                DOS_1ImageView.frame=CGRectMake(128, delta+11, 19, 11);
                DOS_1ImageView.tag=238;
                [headerView addSubview:DOS_1ImageView];
                [DOS_1ImageView release];
                
                CGRect friendsLabelTextRect=CGRectMake(106,delta+26,55,12);
                UILabel *friendsTextLabel=[[UILabel alloc] initWithFrame:friendsLabelTextRect];
                friendsTextLabel.textAlignment=NSTextAlignmentCenter;
                friendsTextLabel.text=[NSString stringWithFormat:@"FRIENDS"];
                friendsTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                friendsTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                friendsTextLabel.tag=239;
                friendsTextLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:friendsTextLabel];
                [friendsTextLabel release];
                
                // People you may know section in the participant bar
                DOS2Button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                DOS2Button.frame=CGRectMake(174,delta,75,47);
                DOS2Button.backgroundColor = [UIColor clearColor];
                [headerView addSubview:DOS2Button];
                
                CGRect DOS_2LabelRect=CGRectMake(178,delta+11,25,12);
                UILabel *DOS_2countLabel=[[UILabel alloc] initWithFrame:DOS_2LabelRect];
                DOS_2countLabel.textAlignment=NSTextAlignmentRight;
                DOS_2countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS2];
                DOS_2countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_2countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_2countLabel.tag=240;
                DOS_2countLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:DOS_2countLabel];
                [DOS_2countLabel release];
                
                UIImageView *DOS_2ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallDOS2.png"]];
                DOS_2ImageView.frame=CGRectMake(207, delta+11, 19, 11);
                DOS_2ImageView.tag=241;
                [headerView addSubview:DOS_2ImageView];
                [DOS_2ImageView release];
                
                CGRect mayknowLabelTextRect=CGRectMake(179,delta+26,65,12);
                UILabel *mayknowTextLabel=[[UILabel alloc] initWithFrame:mayknowLabelTextRect];
                mayknowTextLabel.textAlignment=NSTextAlignmentCenter;
                mayknowTextLabel.text=[NSString stringWithFormat:@"MAY KNOW"];
                mayknowTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                mayknowTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                mayknowTextLabel.tag=242;
                mayknowTextLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:mayknowTextLabel];
                [mayknowTextLabel release];
                
                
                // Other section in the participant bar
                DOS3Button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                DOS3Button.frame=CGRectMake(248,delta,72,47);
                DOS3Button.backgroundColor = [UIColor clearColor];
                [headerView addSubview:DOS3Button];
                
                
                CGRect DOS_3LabelRect=CGRectMake(256,delta+11,55,12);
                UILabel *DOS_3countLabel=[[UILabel alloc] initWithFrame:DOS_3LabelRect];
                DOS_3countLabel.textAlignment=NSTextAlignmentCenter;
                DOS_3countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS3];
                DOS_3countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_3countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_3countLabel.tag=243;
                DOS_3countLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:DOS_3countLabel];
                [DOS_3countLabel release];
                
                
                CGRect othersLabelTextRect=CGRectMake(256,delta+26,55,12);
                UILabel *othersTextLabel=[[UILabel alloc] initWithFrame:othersLabelTextRect];
                othersTextLabel.textAlignment=NSTextAlignmentCenter;
                othersTextLabel.text=[NSString stringWithFormat:@"OTHERS"];
                othersTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                othersTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                othersTextLabel.tag=244;
                othersTextLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:othersTextLabel];
                [othersTextLabel release];
                participantListTableView.participantTableView.tableHeaderView=headerView;
                
                    if([SoclivityUtilities deviceType] & iPhone5)
                [participantListTableView setFrame:CGRectMake(0,416, 320, 470)];
                    else
                [participantListTableView setFrame:CGRectMake(0, 329, 320, 423)];                                
                            
                [self.scrollView addSubview:participantListTableView];
            }
                break;
                
        }		
	}

    // Activity label
    activityNameLabel.text=[NSString stringWithFormat:@"%@",activityInfo.activityName];
    activityNameLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    activityNameLabel.textColor=[UIColor whiteColor];
    activityNameLabel.backgroundColor=[UIColor clearColor];
    activityNameLabel.tag=kActivityLabel;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    activityNameLabel.frame=CGRectMake(55, 20, 210, 44);
    }else{
    activityNameLabel.frame=CGRectMake(55, 0, 210, 44);
    }
    
    [activityNameLabel setContentMode:UIViewContentModeScaleAspectFill];
    [activityNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    activityNameLabel.adjustsFontSizeToFitWidth=NO;//This is main for shrinking font
    
    leaveActivityButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:17];
    organizerEditButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:17];
    editButtonForMapView.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:17];
    locationEditLeftCrossButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:17];
    resignTextDoneButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:17];
    locationEditRightCheckButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:17];
    locationEditRightCheckButton.backgroundColor=[SoclivityUtilities returnBackgroundColor:15];
    
    if([SoclivityUtilities deviceType] & iPhone5)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,940);
    else
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,705);

    // Do any additional setup after loading the view from its nib.
    
    [eventView loadViewWithActivityDetails:activityInfo];
    [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];

    activityButton.hidden=YES;

    if(footerActivated){
        
        chatButton.hidden=YES;
        if(activityInfo.activityRelationType==5||activityInfo.activityRelationType==6)
            activityButton.hidden=NO;
        [scrollView setHidden:YES];
        [chatView setHidden:NO];
        
        if(activityInfo.activityRelationType==5)
        {
            leaveActivityButton.hidden=YES;
            reportButton.hidden=YES;
        }
        enterChatTextButton.hidden=NO;
        commentChatLabel.hidden=NO;
        postChatImageButton.hidden=NO;
        imagePostChatlabel.hidden=NO;
        backButton.hidden = YES;
        if(activityInfo.activityRelationType==6){
            organizerEditButton.hidden=YES;
            inviteUsersToActivityButton.hidden=YES;
        }
        
        
        newActivityButton.hidden=YES;
        [editButtonForMapView setHidden:YES];

    }
    

}

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"ActivityEventViewController_iphone5";
    }
    else{
        nibNameBundle=@"ActivityEventViewController";
    }
    
    UIViewController * myViewController =
    [[ActivityEventViewController alloc]
     initWithNibName:nibNameBundle
     bundle:nil];
    
    return myViewController;
}


- (void)backgroundTapToPush:(NotificationClass*)notification{
    
    NSLog(@"Activity Selected");
    
        notIdObject=[notification retain];
    
    switch ([notIdObject.notificationType integerValue]) {
        case 7:
        case 8:
        case 9:
        case 10:
        case 13:
        case 16:
            
        {
            SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
            socProfileViewController.friendId=notIdObject.referredId;
            [[self navigationController] pushViewController:socProfileViewController animated:YES];
            [socProfileViewController release];
            
        }
            
            break;
            
        default:
        {

    
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    

    GetPlayersClass *obj=SOC.loggedInUser;
    
    if([SoclivityUtilities hasNetworkConnection]){
        [devServer getDetailedActivityInfoInvocation:[obj.idSoc intValue]  actId:notification.activityId  latitude:[notification.latitude floatValue] longitude:[notification.longitude floatValue] delegate:self];
        
    }
    else{
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
            
        }
            break;
    }
}




#pragma mark DetailedActivityInfoInvocationDelegate Method
-(void)DetailedActivityInfoInvocationDidFinish:(DetailedActivityInfoInvocation*)invocation
                                  withResponse:(InfoActivityClass*)response
                                     withError:(NSError*)error{
    
    
        
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
switch ([notIdObject.notificationType integerValue]) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 11:
            case 17:
            default:
                
                
            {
                NSString*nibNameBundle=nil;
                
                if([SoclivityUtilities deviceType] & iPhone5){
                    nibNameBundle=@"ActivityEventViewController_iphone5";
                }
                else{
                    nibNameBundle=@"ActivityEventViewController";
                }
                
                ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
                activityEventViewController.activityInfo=response;
                if([notIdObject.notificationType integerValue]==17){
                    activityEventViewController.footerActivated=YES;
                }
                [[self navigationController] pushViewController:activityEventViewController animated:YES];
                [activityEventViewController release];
                
            }
                break;
                
                
        }
        
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if([chatView.inputView.textView isFirstResponder] && !enable){
        
        tapType=-1;
    }
    switch (tapType) {
        case 1:
        {
            if (action == @selector(delete:)) {
                return YES;
            }
            
        }
            break;
        case 2:
        {
            if (action == @selector(copy:) ||
                action == @selector(delete:)) {
                return YES;
            }
            
        }
            break;
            
        case 3:
        {
            
            if (action == @selector(paste:)) {
                return NO;
            }

            else if (action == @selector(copy:)) {
                return YES;
            }

            
        }
            break;
            
    }
    return NO;
}

- (void)copy:(id)sender {
    enable=FALSE;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* copyCode = pasteboard.string;
    NSLog(@"copyCode=%@",copyCode);
//    ActivityChatData *chat=[chatView.bubbleData objectAtIndex:menuSection];
    UILabel *label=(UILabel*)menuChat.view;
//    pasteboard.string =label.text;
    pasteboard.string=label.text;
    
    //[self.delegate tellToStopInteraction:YES];
}

- (void)delete:(id)sender {
	enable=FALSE;
    
    switch (tapType) {
        case 1:
        case 2:
        {
            int index=0;
            int chatI=0;
            BOOL found=FALSE;
            for(ActivityChatData *chat in chatView.bubbleData){
                if([chat.date isEqualToDate:menuChat.date]){
                    NSLog(@"test success");
                    found=TRUE;
                    chatI=chat.chatId;
                    break;
                }
                else{
                    NSLog(@"test failed");                    
                }
                index++;
            }
            if(found){
                removeChatIndex=index;
                [self deleteChatPost:chatI];
            }

        }
            break;
            
        default:
            break;
    }
}
-(void)deleteChatPost:(NSInteger)chatid{
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        [self startAnimation:kChatPostDelete];
        
        [devServer chatPostsOnActivity:activityInfo.activityId chatId:chatid delegate:self message:nil chatRequest:4 imageToPost:nil];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }

}

-(void)chatDeleted:(NSString*)message{
    
    [HUD hide:YES];
    [chatView.bubbleData removeObjectAtIndex:removeChatIndex];
    [chatView.bubbleTable reloadData];

}

-(void)showMenu:(ActivityChatData*)type tapTypeSelect:(NSInteger)tapTypeSelect{
    [self becomeFirstResponder];
    enable=TRUE;
    tapType=tapTypeSelect;
    menuChat=[type retain];
    
}

-(IBAction)resignTextDonePressed:(id)sender{
    
    if([chatView.bubbleData count]==0){
        
    [chatView.bubbleTable setHidden:YES];
    [chatView.chatBackgroundView setHidden:NO];

    }
    else{
        [chatView.bubbleTable setHidden:NO];
            [chatView.chatBackgroundView setHidden:YES];
    }
    
    chatView.inputView.hidden=YES;
    [chatView.inputView.textView resignFirstResponder];
}

-(void)showDoneButton:(BOOL)show{
    
    if(footerActivated){
    
    if(show){
        resignTextDoneButton.hidden=NO;
    }
    else{
        resignTextDoneButton.hidden=YES;
    }
    }
    
}


-(IBAction)enterChatTextButtonPressed:(id)sender{
    chatView.inputView.hidden=NO;
    [chatView.chatBackgroundView setHidden:YES];

    [self.inputView setUserInteractionEnabled:YES];
    [chatView.inputView.textView becomeFirstResponder];
}

-(void)userPostedAText:(ActivityChatData*)msg{
    
    [HUD hide:YES];
    [chatView messageSentOrRecieved:msg type:1];
}

-(void)addAPost:(ActivityChatData*)responses{
    
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:SOC.loggedInUser.badgeCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];

    if([chatView.bubbleData count]==0){
            [chatView updateChatScreen:[NSMutableArray arrayWithObject:responses]];
    }
    else{
    if([responses.description isEqualToString:@"IMG"]){
        
        [chatView postImagePressed:responses type:2];
    }
    else
        [chatView messageSentOrRecieved:responses type:2];
        
    }
}


-(IBAction)postImageOnChatScreenPressed:(id)sender{
    
    cameraUpload=[[CameraCustom alloc]init];
    cameraUpload.delegate=self;

    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Post an image"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Image Gallery", @"Photo Capture",nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    [sheet release];
    


}

#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //restore view opacities to normal
    
    switch (buttonIndex) {
        case 0:
        {
            [self PushImageGallery];
        }
            break;
            
        case 1:
        {
            [self PushCamera];
        }
            break;
    }
    
}

#pragma mark -
#pragma  mark CustomCamera Gallery and Capture Methods



-(void)PushImageGallery{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
	if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        cameraUpload.galleryImage=TRUE;
		cameraUpload.m_picker.sourceType = sourceType;
        [self presentViewController:cameraUpload.m_picker animated:YES completion:nil];
    }
    
}


-(void)PushCamera{
    UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
	if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        cameraUpload.galleryImage=FALSE;
		cameraUpload.m_picker.sourceType = sourceType;
        [self presentViewController:cameraUpload.m_picker animated:YES completion:nil];
        
	}
    
}


-(void)imageCapture:(UIImage*)Img{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
    [self postAImageOnTheServer:Img];
    
    if([chatView.bubbleData count]==0){
        [chatView.bubbleTable setHidden:NO];
        [chatView.chatBackgroundView setHidden:YES];
        
    }

    

}
-(void)userPostedAnImage:(ActivityChatData*)imagePost{
    
    [HUD hide:YES];
    [chatView postImagePressed:imagePost type:1];
    
}


-(void)dismissPickerModalController{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}




-(void)BottonBarButtonHideAndShow:(NSInteger)type{
    
    switch (type) {
            //join 
        case 1:
        {
            cancelRequestActivityButton.hidden=YES;
            
            if([activityInfo.access isEqualToString:@"public"])
               addEventButton.hidden=NO;
            
              else
                addEventButton.hidden=YES;
            
            organizerEditButton.hidden=YES;
            goingActivityButton.hidden=YES;
            notGoingActivityButton.hidden=YES;
            inviteUsersToActivityButton.hidden=YES;
            leaveActivityButton.hidden=YES;
            chatButton.hidden=YES;
            reportButton.hidden=NO;
            
            [eventView decideToShowMapView:1];
        }
            break;
            //pending request
        case 2:
        {
            cancelRequestActivityButton.hidden=NO;
            addEventButton.hidden=YES;
            organizerEditButton.hidden=YES;
            inviteUsersToActivityButton.hidden=YES;
            goingActivityButton.hidden=YES;
            notGoingActivityButton.hidden=YES;
            leaveActivityButton.hidden=YES;
            chatButton.hidden=YES;
            reportButton.hidden=NO;

            [eventView decideToShowMapView:2];
        }
            break;
            
            //invited
        case 3:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=YES;
            organizerEditButton.hidden=YES;
            goingActivityButton.hidden=NO;
            notGoingActivityButton.hidden=NO;
            chatButton.hidden=NO;
            inviteUsersToActivityButton.hidden=YES;
            leaveActivityButton.hidden=YES;
            reportButton.hidden=NO;

            
                [eventView decideToShowMapView:3];
        }
            break;
            
            // going/not Going
        case 4:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=YES;
            chatButton.hidden=YES;
            organizerEditButton.hidden=YES;
            goingActivityButton.hidden=NO;
            notGoingActivityButton.hidden=NO;
            leaveActivityButton.hidden=YES;
            inviteUsersToActivityButton.hidden=YES;
            reportButton.hidden=NO;
            
            [eventView decideToShowMapView:5];
            
        }
            break;
            
            //going //request approved(invited)
        case 5:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=YES;
            chatButton.hidden=NO;
            organizerEditButton.hidden=YES;
            goingActivityButton.hidden=YES;
            notGoingActivityButton.hidden=YES;
            leaveActivityButton.hidden=NO;
            inviteUsersToActivityButton.hidden=YES;
            reportButton.hidden=NO;
            
            [eventView decideToShowMapView:5];
            
            
        }
            break;
            
            //organizer
        case 6:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=YES;
            chatButton.hidden=NO;
            notGoingActivityButton.hidden=YES;
            organizerEditButton.hidden=NO;
            goingActivityButton.hidden=YES;
            inviteUsersToActivityButton.hidden=NO;
            leaveActivityButton.hidden=YES;
            reportButton.hidden=YES;
            
           [eventView decideToShowMapView:6];

         }
            break;
    }
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ButtonTapped:(UIButton*)sender{
    
    //int tag=sender.tag;
    if(page==0){
        if(activityInfo.activityRelationType==6){
            
            if(activityInfo.pendingRequestCount==0 && [activityInfo.goingCount intValue]==1){//0
                
                return;
            }
            else{
                [self scrollViewToTheTopOrBottom];
            }
        }
        else{
            if([activityInfo.goingCount intValue]==1)//0
                return;
            
            else if([activityInfo.goingCount intValue]==2 && (activityInfo.activityRelationType==5))//0
                return;
            
            else{
                [self scrollViewToTheTopOrBottom];
            }
            
        }
        
    }
    
    switch (sender.tag) {
        case 103:
        {
            if(page==1){
                [self scrollViewToTheTopOrBottom];
            }
        }
            break;
        case 104:
        {
            if(lastIndex!=-1){
                
                
                participantListTableView.noLine=FALSE;
                [participantListTableView openAllSectionsExceptOne];
                toggleFriends=TRUE;
                lastIndex=-1;
            }
            
        }
            break;
        default:
            break;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (!pageControlBeingUsed) {
		
        // Switch the indicator when more than 50% of the previous/next view is visible
		CGFloat pageWidth = self.scrollView.frame.size.height;
		page = floor((self.scrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
        
        switch (page) {
            case 1:
            {
                [(UIButton*)[self.scrollView viewWithTag:103] setFrame:CGRectMake(2, 3, 33, 40)];//343
                [(UIButton*)[self.scrollView viewWithTag:103] setBackgroundImage:[UIImage imageNamed:@"S05_participantDownArrow.png"] forState:UIControlStateNormal];
                participantListTableView.participantTableView.scrollEnabled=YES;
            }
                break;
                
                
            case 0:
            {
                [(UIButton*)[self.scrollView viewWithTag:103] setFrame:CGRectMake(2,4,33,40)];//343
                [(UIButton*)[self.scrollView viewWithTag:103] setBackgroundImage:[UIImage imageNamed:@"S05_participantArrow.png"] forState:UIControlStateNormal];
                participantListTableView.participantTableView.scrollEnabled=NO;

            }
                break;

                
        }
    }
    
    if(activityInfo.pendingRequestCount==0 && [activityInfo.goingCount intValue]==1 && page==0){
        self.scrollView.scrollEnabled=NO;
    }
    
    if([activityInfo.goingCount intValue]==2 && (activityInfo.activityRelationType==5)&& page==0){
        self.scrollView.scrollEnabled=NO;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

-(void)scrollViewToTheTopOrBottom{
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = self.scrollView.frame.size.height;
    frame.size = self.scrollView.frame.size;
    
    switch (page) {
        case 0:
        {
            if([SoclivityUtilities deviceType] & iPhone5){
                
            frame.origin.y = 416;
                }
                else{
            frame.origin.y = 376;
                }
        }
            break;
            
        case 1:
        {
            frame.origin.y = 0;
        }
            break;
    }
    
	[self.scrollView scrollRectToVisible:frame animated:YES];
}


-(IBAction)addEventActivityPressed:(id)sender{
    
    
    switch (activityInfo.activityRelationType) {
        case 1:
        {
            if([SoclivityUtilities hasNetworkConnection]){
                [self startAnimation:kJoinRequest];
                [devServer postActivityRequestInvocation:1  playerId:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId delegate:self];
            }
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [alert show];
                [alert release];
                return;
                
                
            }


            
        }
            break;
            
        case 2:
        {
            
            if([SoclivityUtilities hasNetworkConnection]){
                [self startAnimation:kCancelPendingRequest];
                [devServer postActivityRequestInvocation:2  playerId:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId delegate:self];
            }
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [alert show];
                [alert release];
                return;
                
                
            }

            
        }
            break;
            
        case 3:
        case 4:
        case 5:
        case 6:
        {
            activityInfo.activityRelationType=1;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }
            break;

    }
    
    
}

-(void)PostActivityRequestInvocationDidFinish:(PostActivityRequestInvocation*)invocation
                                 withResponse:(BOOL)response relationTypeTag:(NSInteger)relationTypeTag
                                    withError:(NSError*)error{
    
    [HUD hide:YES];
    
    switch (relationTypeTag) {
        case 1:
        {
            activityInfo.activityRelationType=2;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];

        }
            break;
        case 2:
        case 14://case 3
        {
            activityInfo.activityRelationType=1;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }
            break;

        case 5:
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }               
            break;
         
        case 4:
        {
            
            activityInfo.activityRelationType=5;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }            
        break;
            
        case 7:
        {
            [participantListTableView updateParticipantListView:YES];
            
        }
            
        break;
        case 13://case 8
        {
            [participantListTableView updateParticipantListView:NO];
            
        }               
            break;

        case 9:
        {
            [participantListTableView updatePlayerListWithSectionHeaders];
            
        }               
            break;

        case 10:
        {
            SOC.localCacheUpdate=TRUE;
            [SoclivitySqliteClass deleteActivityRecords:activityInfo.activityId];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
            
        case 15:
        {
            [participantListTableView updatePlayerListWithSectionHeaders];
            
        }
            break;

    
        default:
            break;
    }
}

-(void)deleteActivityEventByOrganizer{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)leaveEventActivityPressed:(id)sender{
    
    
    switch (activityInfo.activityRelationType) {
        case 5:
        {
            
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leave Activity?"
                                                            message:@"Are you sure you want to leave the activity?"
                                                           delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
            
            alert.tag=kLeaveActivity;
            [alert show];
            [alert release];

        }
            break;
    }
    
    
}
-(IBAction)createANewActivityButtonPressed:(id)sender{
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"CreateActivityViewController_iphone5";
    }
    else{
        nibNameBundle=@"CreateActivityViewController";
    }

    
    CreateActivityViewController *avEditController = [[CreateActivityViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    avEditController.delegate=self;
    avEditController.newActivity=YES;
    UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:avEditController];
	
    [self.navigationController presentViewController:addNavigationController animated:YES completion:nil];


    
}

#pragma mark -
#pragma mark Create New Activity methods


-(void)cancelCreateActivityEventScreen{
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
-(void)pushToNewActivity:(InfoActivityClass *)activity{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    SOC.editOrNewActivity=TRUE;
    
    NSString*nibNameBundle=nil;
    
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"ActivityEventViewController_iphone5";
    }
    else{
        nibNameBundle=@"ActivityEventViewController";
    }

    
    ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    
    activityEventViewController.activityInfo=activity;
	[[self navigationController] pushViewController:activityEventViewController animated:YES];
    [activityEventViewController release];

}
-(IBAction)goingActivityButtonPressed:(id)sender{
    
    
    
    switch (activityInfo.activityRelationType) {
        case 4:
        {
            
            if([SoclivityUtilities hasNetworkConnection]){
                [self startAnimation:kConfirmPresenceRequest];
                [devServer postActivityRequestInvocation:4  playerId:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId delegate:self];
            }
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [alert show];
                [alert release];
                return;
                
                
            }
            
            
        }
            break;
    }
    
    
}
-(IBAction)notGoingActivityButtonPressed:(id)sender{
    
    
    switch (activityInfo.activityRelationType) {
        case 4:
        {
            
            if([SoclivityUtilities hasNetworkConnection]){
                [self startAnimation:kSorryNotGoingRequest];
                [devServer postActivityRequestInvocation:14  playerId:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId delegate:self];
            }
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [alert show];
                [alert release];
                return;
                
                
            }
            
            
        }
            break;
    }
    
    
}
-(IBAction)inviteUsersButton:(id)sender{
    
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        inviteUsersToActivityButton.hidden=YES;
        blankInviteUsersAnimationButton.hidden=NO;
        [spinnerView startAnimating];
        [spinnerView setHidden:NO];

        [devServer getActivityPlayerInvitesInvocation:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId inviteeListType:1 abContacts:@"" delegate:self];
     }
    
  else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }

    


}
-(void)ActivityInvitesInvocationDidFinish:(GetActivityInvitesInvocation*)invocation
                             withResponse:(NSArray*)responses type:(NSInteger)type
                                withError:(NSError*)error{
    
    
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"InvitesViewController_iphone5";
    }
    else{
        nibNameBundle=@"InvitesViewController";
    }
    
    InvitesViewController *invitesViewController=[[InvitesViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    invitesViewController.activityName=[NSString stringWithFormat:@"%@",activityInfo.activityName];
    invitesViewController.inviteArray=responses;
    NSNumber*slots=[[NSUserDefaults standardUserDefaults] valueForKey:@"ActivityOpenSlots"];

    invitesViewController.num_of_slots=[slots intValue];
    invitesViewController.inviteFriends=YES;
    invitesViewController.activityId=activityInfo.activityId;
    [[self navigationController] pushViewController:invitesViewController animated:YES];
    [invitesViewController release];
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];

    
    inviteUsersToActivityButton.hidden=NO;
    blankInviteUsersAnimationButton.hidden=YES;
    [spinnerView stopAnimating];
    [spinnerView setHidden:YES];

    
}
-(IBAction)editButtonClicked:(id)sender{
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"CreateActivityViewController_iphone5";
    }
    else{
        nibNameBundle=@"CreateActivityViewController";
    }
    
    
    CreateActivityViewController *avEditController = [[CreateActivityViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    avEditController.delegate=self;
    avEditController.newActivity=NO;
    avEditController.activityObject=activityInfo;
    UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:avEditController];
	
    [self.navigationController presentViewController:addNavigationController animated:YES completion:nil];

}

-(IBAction)chatButtonPressed:(id)sender{
    
   if(!footerActivated){
        footerActivated=TRUE;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:staticView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        [scrollView setHidden:YES];
        [chatView setHidden:NO];
       
       if(activityInfo.activityRelationType==5)
           leaveActivityButton.hidden=YES;
       
       enterChatTextButton.hidden=NO;
       commentChatLabel.hidden=NO;
       postChatImageButton.hidden=NO;
       imagePostChatlabel.hidden=NO;
       reportButton.hidden=YES;
       backButton.hidden=YES;

       if(activityInfo.activityRelationType==6){
           organizerEditButton.hidden=YES;
           inviteUsersToActivityButton.hidden=YES;
       }
       
       
        newActivityButton.hidden=YES;
       
        [UIView commitAnimations];
        [editButtonForMapView setHidden:YES];
        
       if(inTransition)
            currentLocationInMap.hidden=YES;
       
        context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:staticToggleView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
       
        chatButton.hidden=YES;
        activityButton.hidden=NO;

       
        [UIView commitAnimations];
       
       
    }
    else{
        footerActivated=FALSE;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:staticView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        [scrollView setHidden:NO];
        [chatView setHidden:YES];
        enterChatTextButton.hidden=YES;
        commentChatLabel.hidden=YES;
        postChatImageButton.hidden=YES;
        imagePostChatlabel.hidden=YES;
        backButton.hidden=NO;
        
        newActivityButton.hidden=NO;
        resignTextDoneButton.hidden=YES;
        reportButton.hidden=NO;
        
        if(activityInfo.activityRelationType==5)
            leaveActivityButton.hidden=NO;
        
        if(activityInfo.activityRelationType==6){
            organizerEditButton.hidden=NO;
            inviteUsersToActivityButton.hidden=NO;
            reportButton.hidden=YES;
        }


        [UIView commitAnimations];
        
       // if(activityInfo.activityRelationType==6)
         //   [editButtonForMapView setHidden:NO];
        
        
        if(inTransition){
            currentLocationInMap.hidden=NO;
            reportButton.hidden=YES;
            inviteUsersToActivityButton.hidden=YES;

        }
        
        context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:staticToggleView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        chatButton.hidden=NO;
        activityButton.hidden=YES;

        
        [UIView commitAnimations];
    }
    
    
}
-(void)startUpdatingChat{
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        [self startAnimation:kChatPostRequest];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];

        NSString  *currentTime=[dateFormatter stringFromDate:[NSDate date]];

        [[NSUserDefaults standardUserDefaults] setValue:currentTime forKey:@"ChatTimeStamp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [devServer chatPostsOnActivity:activityInfo.activityId chatId:[SOC.loggedInUser.idSoc intValue] delegate:self message:nil chatRequest:1 imageToPost:nil];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }

}

-(void)chatPostToDidFinish:(ChatServiceInvocation*)invocation
              withResponse:(NSArray*)responses
                 withError:(NSError*)error{
    
    [HUD hide:YES];
    
    [chatView updateChatScreen:[NSMutableArray arrayWithArray:responses]];
}


-(void)postAtTextMessageOnTheServer:(NSString*)message{
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        [self startAnimation:kChatPostMessageRequest];
        
        [devServer chatPostsOnActivity:activityInfo.activityId chatId:[SOC.loggedInUser.idSoc intValue] delegate:self message:message chatRequest:2 imageToPost:nil];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }

}


-(void)postAImageOnTheServer:(UIImage*)image{
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        [self startAnimation:kChatPostMessageRequest];
        NSData *imageData=UIImagePNGRepresentation(image);
        NSLog(@"Bytes of the image=%d",[imageData length]);
        
        [devServer chatPostsOnActivity:activityInfo.activityId chatId:[SOC.loggedInUser.idSoc intValue] delegate:self message:nil chatRequest:3 imageToPost:imageData];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
    
}


-(void)postDidFailed:(NSError*)error{
    
    [HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:nil
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    return;

}

-(IBAction)cancelRequestButtonPressed:(id)sender{
    
    
    switch (activityInfo.activityRelationType) {
        case 2:
    {
        
        if([SoclivityUtilities hasNetworkConnection]){
            [self startAnimation:kCancelPendingRequest];
            [devServer postActivityRequestInvocation:2  playerId:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId delegate:self];
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            [alert release];
            return;
            
            
        }
        
        
    }
            break;
    }
    
    
}
- (void)viewDidUnload
{
    [reportButton release];
    reportButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [reportButton release];
    [super dealloc];
    [eventView release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Start of the transition from the Activity Event Details page to the Activity Event map view.
-(void)slideInTransitionToLocationView{
    
    inTransition=TRUE;
    
    // Turning the buttons on and off.
    
    // Check if the user is the organizer
    if(activityInfo.activityRelationType==6)
      editButtonForMapView.hidden=NO; //Show the EDIT button
    
    // Check if the user is a participant
    if(activityInfo.activityRelationType==5)
        leaveActivityButton.hidden=YES; //Show the LEAVE button
    
    // Show these buttons regardless of whether the user is an organizer or a participant
    currentLocationInMap.hidden=NO; //Show the current location button
    scrollView.scrollEnabled=NO; //Cannot scroll
    backToActivityFromMapButton.hidden=NO; //Show the
    
    // Hide these buttons
    backButton.hidden=YES; //Back button to the main map/list view is disabled.
    [participantListTableView setHidden:YES]; //Can't scroll down to see the participants
    chatButton.hidden = YES;
    newActivityButton.hidden=YES;
    organizerEditButton.hidden=YES;
    reportButton.hidden=YES;
    inviteUsersToActivityButton.hidden=YES;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    [eventView.searchBarIOS7 setHidden:YES];
    }else{
    [eventView.addressSearchBar setHidden:YES];
    }
        if([SoclivityUtilities deviceType] & iPhone5)
    eventView.frame=CGRectMake(0, 0, 640, 376+88);
         else
    eventView.frame=CGRectMake(0, 0, 640, 376);
    
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            eventView.transform = CGAffineTransformMakeTranslation(-320.0f, 0.0f);
            
        } completion:^(BOOL finished) {
            
            
        }];
        
}
-(IBAction)backToActivityAnimateTransition:(id)sender{
   
    inviteUsersToActivityButton.hidden=YES;
    inTransition=FALSE;
    
    // If the user is a participant show these buttons
    if(activityInfo.activityRelationType==5)
    {
        leaveActivityButton.hidden=NO;
        chatButton.hidden=NO;
    }
        currentLocationInMap.hidden=YES;
    
    if(footerActivated){
        
        footerActivated=FALSE;
        chatView.hidden=YES;
        enterChatTextButton.hidden=YES;
        commentChatLabel.hidden=YES;
        postChatImageButton.hidden=YES;
        imagePostChatlabel.hidden=YES;
        backButton.hidden=NO;
        scrollView.hidden=NO;
    }
    scrollView.scrollEnabled=YES;
    backButton.hidden=NO;
    backToActivityFromMapButton.hidden=YES;
    newActivityButton.hidden=NO;
    activityButton.hidden=YES;
    reportButton.hidden=NO;
    
    // If the user is the organizer show these buttons
    if(activityInfo.activityRelationType==6){
        editButtonForMapView.hidden=YES;//check for organizer
        organizerEditButton.hidden=NO;
        inviteUsersToActivityButton.hidden=NO;
        chatButton.hidden=NO;
        reportButton.hidden=YES;
    }

    locationEditLeftCrossButton.hidden=YES;
    locationEditRightCheckButton.hidden=YES;
     [participantListTableView setHidden:NO];
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        eventView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];

}
-(IBAction)crossClickedInLocationEdit:(id)sender{
    
    
    if(activityInfo.activityRelationType==6)
        editButtonForMapView.hidden=NO;//check for organizer
    
    locationEditLeftCrossButton.hidden=YES;
    locationEditRightCheckButton.hidden=YES;
    backToActivityFromMapButton.hidden=NO;

     if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    [eventView.searchBarIOS7 resignFirstResponder];
    [eventView.searchBarIOS7 setHidden:YES];
     }else{
         [eventView.addressSearchBar resignFirstResponder];
         [eventView.addressSearchBar setHidden:YES];
         
     }
    [eventView hideSearchBarAndAnimateWithListViewInMiddle];
    [eventView cancelClicked];
    eventView.editMode=FALSE;
    [eventView setUpLabelViewElements:NO];
    
    NSArray *hashCount=[activityInfo.where_address componentsSeparatedByString:@"#"];
    if([hashCount count]==2){
        
        if(activityInfo.venueId!=nil && [activityInfo.venueId class]!=[NSNull class] && [activityInfo.venueId length]!=0 && ![activityInfo.venueId isEqualToString:@""]){
            
            eventView.firstALineddressLabel.text=[hashCount objectAtIndex:1];
        }
        else{
            eventView.firstALineddressLabel.text=[NSString stringWithFormat:@"%@,%@",[hashCount objectAtIndex:0],[hashCount objectAtIndex:1]];
        }

        [eventView.secondLineAddressLabel setHidden:YES];
    }
}
-(IBAction)tickClickedInLocationEdit:(id)sender{
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        [eventView setNewLocation];
        [self startAnimation:kEditMapElements];
        [devServer editActivityEventRequestInvocation:activityInfo requestType:kEditMapElements delegate:self];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }

}

-(void)startAnimation:(int)type{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    switch (type) {
        case kEditMapElements:
        {
            HUD.labelText = @"Updating Location";
            
        }
            break;
            
        case kJoinRequest:
        {
            HUD.labelText = @"Sending Request...";
            
        }
            break;
            
        case kCancelPendingRequest:
        {
            HUD.labelText = @"Cancel Pending Request";
            
        }
            break;
            
        case kSorryNotGoingRequest:
        {
            HUD.labelText = @"Sorry Can't make it to the event...! ";
            
        }
            break;
            
            
        case kConfirmPresenceRequest:
        {
            HUD.labelText = @"Confirming...";
            
        }
            break;
            
        case kLeavingActivityRequest:
        {
            HUD.labelText = @"Leaving...";
            
        }
            break;
        case kPlayerConfirmedRequest:
        {
            HUD.labelText = @"Confirming...";
            
        }
            break;
            
        case kDeclinePlayerRequest:
        {
            HUD.labelText = @"Declining...";
            
        }
            break;
            
        case kRemovePlayerRequest:
        {
            HUD.labelText = @"Removing...";
            
        }
            break;
            
        case kChatPostRequest:
        {
            HUD.labelText = @"Fetching";
            
        }
            break;

        case kChatPostMessageRequest:
        {
                HUD.yOffset = -70.0;
            HUD.labelText = @"Posting...";
        }
            break;
            
        case kChatPostDelete:
        {
           HUD.labelText = @"Deleting...";
        }
            break;
        default:
            break;
    }
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)EditActivityEventInvocationDidFinish:(EditActivityEventInvocation*)invocation
                               withResponse:(NSString*)responses requestType:(int)requestType withError:(NSError*)error{
    
    [HUD hide:YES];
    switch (requestType) {
        case kEditMapElements:
        {
            
            SOC.editOrNewActivity=TRUE;
            if(activityInfo.activityRelationType==6)
                editButtonForMapView.hidden=NO;//check for organizer
            
            locationEditLeftCrossButton.hidden=YES;
            locationEditRightCheckButton.hidden=YES;
            backToActivityFromMapButton.hidden=NO;

            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
            [eventView.searchBarIOS7 resignFirstResponder];
            [eventView.searchBarIOS7 setHidden:YES];
            }else{
                [eventView.addressSearchBar resignFirstResponder];
                [eventView.addressSearchBar setHidden:YES];
                
            }
            [eventView hideSearchBarAndAnimateWithListViewInMiddle];
            eventView.editMode=FALSE;
            
            [SOC deltaUpdateSyncCalendar:activityInfo];

        }
            break;
            
        default:
            break;
    }

}
-(void)updateDetailedActivityScreen:(InfoActivityClass*)activityObj{
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    SOC.editOrNewActivity=TRUE;
    activityNameLabel.text=activityObj.activityName;
    [eventView updateEditedActivityFields:activityObj];
}

-(void)enableDisableTickOnTheTopRight:(BOOL)show{
    
    if(show)
     locationEditRightCheckButton.hidden=NO;
    else{
        locationEditRightCheckButton.hidden=YES;
        
    }
}

-(IBAction)editViewToChangeActivityLocation:(id)sender{
    
    locationEditLeftCrossButton.hidden=NO;
    backToActivityFromMapButton.hidden=YES;
    editButtonForMapView.hidden=YES;
    eventView.editMode=TRUE;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    
        eventView.searchBarIOS7.text=@"";
        [eventView.searchBarIOS7 setHidden:NO];
    }
    
    else{
        eventView.addressSearchBar.text=@"";
        [eventView.addressSearchBar setHidden:NO];
    }
    
    [eventView setUpLabelViewElements:YES];
    [eventView showSearchBarAndAnimateWithListViewInMiddle];
    
    
}

-(IBAction)currentLocationBtnClicked:(id)sender{
    [eventView gotoLocation];
}

-(IBAction)reportButtonPressed:(id)sender{

    NSString* flagMessage = [NSString stringWithFormat:@"Please tell us why you find this activity objectionable? (Enter below):\n\n\n\n--\nFlag Report:\nActivity: %@ (%ld)\nOrganizer: %@ (%ld)", activityInfo.activityName, (long)activityInfo.activityId, activityInfo.organizerName, (long)activityInfo.organizerId];
    
    if ([[FeedbackBugReport sharedInstance] canSendFeedback]) {
        UINavigationController* tellAFriendController = [[FeedbackBugReport sharedInstance] reportActivityController:flagMessage];
        
        [self presentViewController:tellAFriendController animated:YES completion:nil];

        
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please setup your email account" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }
}
#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //[alertView resignFirstResponder];
    
    if(alertView.tag==kLeaveActivity){

                if (buttonIndex == 0) {
        if([SoclivityUtilities hasNetworkConnection]){
            [self startAnimation:kLeavingActivityRequest];
            [devServer postActivityRequestInvocation:5  playerId:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId delegate:self];
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            [alert release];
            return;
            
            
        }
                }
    }
}
#pragma mark -
#pragma mark Delegate From Participant List methods

-(void)confirm_RejectPlayerToTheEvent:(BOOL)request playerId:(NSInteger)playerId{

    
    if([SoclivityUtilities hasNetworkConnection]){

    if(request)
    {
            [self startAnimation:kPlayerConfirmedRequest];
            [devServer postActivityRequestInvocation:7  playerId:playerId actId:activityInfo.activityId delegate:self];
    }
    else{
        [self startAnimation:kDeclinePlayerRequest];
        [devServer postActivityRequestInvocation:13  playerId:playerId actId:activityInfo.activityId delegate:self];
        
    }
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }


}
-(void)removeParticipantFromEvent:(NSInteger)playerId{
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        
            [self startAnimation:kRemovePlayerRequest];
            [devServer postActivityRequestInvocation:15  playerId:playerId actId:activityInfo.activityId delegate:self];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
    
    
}
-(void)pushUserProfileView{
   
    if([SOC.loggedInUser.idSoc intValue]==activityInfo.organizerId){
        NSString*nibNameBundle=nil;
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"UpComingCompletedEventsViewController_iphone5";
        }
        else{
            nibNameBundle=@"UpComingCompletedEventsViewController";
        }
        
        UpComingCompletedEventsViewController *upComingCompletedEventsViewController=[[UpComingCompletedEventsViewController alloc] initWithNibName:nibNameBundle bundle:nil];
            upComingCompletedEventsViewController.isNotSettings=TRUE;
        [[self navigationController] pushViewController:upComingCompletedEventsViewController animated:YES];
        [upComingCompletedEventsViewController release];

    }
    else{
    SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
    socProfileViewController.friendId=activityInfo.organizerId;
    [[self navigationController] pushViewController:socProfileViewController animated:YES];
    [socProfileViewController release];
    }
}
-(void)pushToprofileOfThePlayer:(ParticipantClass*)player{
    if([SOC.loggedInUser.idSoc intValue]==player.participantId){
        NSString*nibNameBundle=nil;
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"UpComingCompletedEventsViewController_iphone5";
        }
        else{
            nibNameBundle=@"UpComingCompletedEventsViewController";
        }
        
        UpComingCompletedEventsViewController *upComingCompletedEventsViewController=[[UpComingCompletedEventsViewController alloc] initWithNibName:nibNameBundle bundle:nil];
            upComingCompletedEventsViewController.isNotSettings=TRUE;
        [[self navigationController] pushViewController:upComingCompletedEventsViewController animated:YES];
        [upComingCompletedEventsViewController release];
        
    }
    else{
        SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
        socProfileViewController.friendId=player.participantId;
        [[self navigationController] pushViewController:socProfileViewController animated:YES];
        [socProfileViewController release];
    }
}

@end
