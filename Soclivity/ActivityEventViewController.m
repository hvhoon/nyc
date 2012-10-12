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
@interface ActivityEventViewController (private)<EditActivityEventInvocationDelegate,MBProgressHUDDelegate,PostActivityRequestInvocationDelegate,GetActivityInvitesInvocationDelegate,NewActivityViewDelegate>
@end

@implementation ActivityEventViewController
@synthesize activityInfo,scrollView;
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
    NSLog(@"viewWillAppear in slide View Controller Called");
    
    [self.navigationController.navigationBar setHidden:YES];
}
#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    toggleFriends=TRUE;
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];
    lastIndex=-1;
    [spinnerView stopAnimating];
    [spinnerView setHidden:YES];

    scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    scrollView.clipsToBounds = YES;
    
    
    if([activityInfo.goingCount intValue]==0 && activityInfo.pendingRequestCount==0){
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
                eventView.frame=CGRectMake(0, 0, 640, 416);
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

                UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, delta, 320, 47)];
                headerView.backgroundColor=[UIColor clearColor];
                UIImageView *participantBarImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_participantBar.png"]];
                participantBarImgView.frame=CGRectMake(0, delta, 320, 47);
                [headerView addSubview:participantBarImgView];
                
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
                goingCountLabel.textAlignment=UITextAlignmentCenter;
                goingCountLabel.text=[NSString stringWithFormat:@"%@",activityInfo.goingCount];
                goingCountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingCountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingCountLabel.tag=235;
                goingCountLabel.backgroundColor=[UIColor clearColor];
                
                
                CGRect goingLabelTextRect=CGRectMake(35,delta+26,55,12);
                UILabel *goingTextLabel=[[UILabel alloc] initWithFrame:goingLabelTextRect];
                goingTextLabel.textAlignment=UITextAlignmentCenter;
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
                
                // Highlight for the DOS1 button
                DOS1ButtonHighlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_sectionHighlighted"]];
                DOS1ButtonHighlight.frame = CGRectMake(98, delta, 72, 47);
                DOS1ButtonHighlight.hidden = YES;
                [headerView addSubview:DOS1ButtonHighlight];
                
                DOS1Button.frame=CGRectMake(95,delta,75,47);
                [DOS1Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS1Button.tag=105;
                DOS1Button.backgroundColor = [UIColor clearColor];
                [headerView addSubview:DOS1Button];
                
                CGRect DOS_1LabelRect=CGRectMake(100,delta+11,25,12);
                UILabel *DOS_1countLabel=[[UILabel alloc] initWithFrame:DOS_1LabelRect];
                DOS_1countLabel.textAlignment=UITextAlignmentRight;
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
                friendsTextLabel.textAlignment=UITextAlignmentCenter;
                friendsTextLabel.text=[NSString stringWithFormat:@"FRIENDS"];
                friendsTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                friendsTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                friendsTextLabel.tag=239;
                friendsTextLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:friendsTextLabel];
                [friendsTextLabel release];
                
                // People you may know section in the participant bar
                DOS2Button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                // Highlight for the DOS2 button
                DOS2ButtonHighlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_sectionHighlighted"]];
                DOS2ButtonHighlight.frame = CGRectMake(176, delta, 72, 47);
                DOS2ButtonHighlight.hidden = YES;
                [headerView addSubview:DOS2ButtonHighlight];
                
                DOS2Button.frame=CGRectMake(174,delta,75,47);
                [DOS2Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS2Button.tag=106;
                DOS2Button.backgroundColor = [UIColor clearColor];
                [headerView addSubview:DOS2Button];
                
                CGRect DOS_2LabelRect=CGRectMake(178,delta+11,25,12);
                UILabel *DOS_2countLabel=[[UILabel alloc] initWithFrame:DOS_2LabelRect];
                DOS_2countLabel.textAlignment=UITextAlignmentRight;
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
                mayknowTextLabel.textAlignment=UITextAlignmentCenter;
                mayknowTextLabel.text=[NSString stringWithFormat:@"MAY KNOW"];
                mayknowTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                mayknowTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                mayknowTextLabel.tag=242;
                mayknowTextLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:mayknowTextLabel];
                [mayknowTextLabel release];
                
                
                // Other section in the participant bar
                DOS3Button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                // Highlight for the DOS1 button
                DOS3ButtonHighlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_sectionHighlighted"]];
                DOS3ButtonHighlight.frame = CGRectMake(248, delta, 72, 47);
                DOS3ButtonHighlight.hidden = YES;
                [headerView addSubview:DOS3ButtonHighlight];
                
                DOS3Button.frame=CGRectMake(248,delta,72,47);
                [DOS3Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS3Button.tag=107;
                DOS3Button.backgroundColor = [UIColor clearColor];
                [headerView addSubview:DOS3Button];
                
                
                CGRect DOS_3LabelRect=CGRectMake(256,delta+11,55,12);
                UILabel *DOS_3countLabel=[[UILabel alloc] initWithFrame:DOS_3LabelRect];
                DOS_3countLabel.textAlignment=UITextAlignmentCenter;
                DOS_3countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS3];
                DOS_3countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_3countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_3countLabel.tag=243;
                DOS_3countLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:DOS_3countLabel];
                [DOS_3countLabel release];
                
                
                CGRect othersLabelTextRect=CGRectMake(256,delta+26,55,12);
                UILabel *othersTextLabel=[[UILabel alloc] initWithFrame:othersLabelTextRect];
                othersTextLabel.textAlignment=UITextAlignmentCenter;
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
    activityNameLabel.shadowColor = [UIColor blackColor];
    activityNameLabel.shadowOffset = CGSizeMake(0,-1);
    activityNameLabel.tag=kActivityLabel;

    [eventView loadViewWithActivityDetails:activityInfo];
    
    [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];

    
    if([SoclivityUtilities deviceType] & iPhone5)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,940);
    else
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,705);

    // Do any additional setup after loading the view from its nib.
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
            
            [eventView decideToShowMapView:4];
            
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
            
           [eventView decideToShowMapView:6];

         }
            break;
    }
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ButtonTapped:(UIButton*)sender{
    
    int tag=sender.tag;
    NSLog(@"tag=%d",tag);
    if(page==0){
        
        
        if(activityInfo.activityRelationType==6){
            
            if(activityInfo.pendingRequestCount==0 && [activityInfo.goingCount intValue]==0){
                
                return;
            }
            else{
                [self scrollViewToTheTopOrBottom];
            }
        }
        else{
        if([activityInfo.goingCount intValue]==0)
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
             [self highlightSelection:0];
             if(lastIndex!=-1){
                           
               
                participantListTableView.noLine=FALSE;
                 [participantListTableView openAllSectionsExceptOne];
                toggleFriends=TRUE;
                lastIndex=-1;
            }
            
        }
            break;
        case 105:
        {
            int section_105;
            if(lastIndex!=0){
           //this section may be zero or one 
                if(activityInfo.DOS1!=0)
                {
                    [self highlightSelection:1];
                    
                    if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0){
                        //we need to check the pending Requests
                        section_105=1;
                        
                    }
                    else{
                        section_105=0;
                    }
                    if(toggleFriends){
                        toggleFriends=FALSE;
                         [participantListTableView collapseSectionsExceptOne:section_105];
                         lastIndex=0;
                    }
                    
                    else{
                        [participantListTableView alternateBetweenSectionsWithCollapseOrExpand:section_105];
                        lastIndex=0;

                    }
                }
            
            }
        }
            break;
        case 107:
        {
            int section_107;
            if(activityInfo.activityRelationType==6 || activityInfo.activityRelationType==5){
            if(lastIndex!=2){  
                
                if(activityInfo.DOS3!=0)
                {
                    [self highlightSelection:3];
                    if((activityInfo.activityRelationType==6 || activityInfo.activityRelationType==5) && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1!=0 && activityInfo.DOS2!=0){
                        //we need to check the pending Requests
                        section_107=3;
                        
                    }
                    else if((activityInfo.activityRelationType==6 || activityInfo.activityRelationType==5) && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1!=0 && activityInfo.DOS2==0){
                        section_107=2;
                    }
                    else if((activityInfo.activityRelationType==6 || activityInfo.activityRelationType==5) && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1==0 && activityInfo.DOS2!=0){
                        section_107=2;
                    }
                    else if((activityInfo.activityRelationType==6 || activityInfo.activityRelationType==5) && activityInfo.pendingRequestCount==0 && activityInfo.DOS1!=0 && activityInfo.DOS2!=0){
                        section_107=2;
                    }
                    else if((activityInfo.activityRelationType==6 || activityInfo.activityRelationType==5) && activityInfo.pendingRequestCount==0 && activityInfo.DOS1!=0 && activityInfo.DOS2==0){
                        section_107=1;
                    }
                    else if((activityInfo.activityRelationType==6 || activityInfo.activityRelationType==5) && activityInfo.pendingRequestCount==0 && activityInfo.DOS1==0 && activityInfo.DOS2!=0){
                        section_107=1;
                    }
                    else if((activityInfo.activityRelationType==6 || activityInfo.activityRelationType==5) && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1==0 && activityInfo.DOS2==0){
                        section_107=1;
                    }
                    else {
                        section_107=0;
                    }
                    if(toggleFriends){
                        toggleFriends=FALSE;
                        [participantListTableView collapseSectionsExceptOne:section_107];
                        lastIndex=2;
                    }
                    
                    else{
                        [participantListTableView alternateBetweenSectionsWithCollapseOrExpand:section_107];
                        lastIndex=2;
                    }
                }
            }
            }
        }
            break;
        case 106:
        {
            int section_106;
            if(lastIndex!=1){  
            
                if(activityInfo.DOS2!=0)
                {
                    [self highlightSelection:2];
                    if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1!=0){
                        //we need to check the pending Requests
                        section_106=2;
                        
                    }
                    else if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1==0){
                        section_106=1;
                    }
                    else if(activityInfo.DOS1==0){
                         section_106=0;
                    }
                    else if(activityInfo.DOS1!=0){
                        section_106=1;
                    }
                    if(toggleFriends){
                        toggleFriends=FALSE;
                        [participantListTableView collapseSectionsExceptOne:section_106];
                        lastIndex=1;
                    }
                    
                    else{
                        [participantListTableView alternateBetweenSectionsWithCollapseOrExpand:section_106];
                        lastIndex=1;
                    }
                }
            
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
    
    if(activityInfo.pendingRequestCount==0 && [activityInfo.goingCount intValue]==0 && page==0){
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
                                 withResponse:(NSString*)responses relationTypeTag:(NSInteger)relationTypeTag
                                    withError:(NSError*)error{
    
    NSLog(@"responses=%@",responses);
    [HUD hide:YES];
    
    switch (relationTypeTag) {
        case 1:
        {
            activityInfo.activityRelationType=2;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];

        }
            break;
        case 2:
        case 3:
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
        case 8:
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

    
        default:
            break;
    }
}

-(void)deleteActivityEventByOrganizer{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)leaveEventActivityPressed:(id)sender{
    
    
    switch (activityInfo.activityRelationType) {
        case 5:
        {
            
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you  Sure"
                                                            message:@"You want to leave the activity"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
            
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
	
    
	[self.navigationController presentModalViewController:addNavigationController animated:YES];

    
}

#pragma mark -
#pragma mark Create New Activity methods


-(void)cancelCreateActivityEventScreen{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)pushToNewActivity:(InfoActivityClass *)activity{
    
[self.navigationController dismissModalViewControllerAnimated:YES];
    
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
                [devServer postActivityRequestInvocation:3  playerId:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId delegate:self];
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

            [devServer getActivityPlayerInvitesInvocation:[SOC.loggedInUser.idSoc intValue] actId:activityInfo.activityId delegate:self];
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
                             withResponse:(NSArray*)responses
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
    NSNumber *slots=[[NSUserDefaults standardUserDefaults] valueForKey:@"ActivityOpenSlots"];

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
	
    
	[self.navigationController presentModalViewController:addNavigationController animated:YES];

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
        [UIView commitAnimations];
        [editButtonForMapView setHidden:YES];
        
        if(inTransition)
        currentLocationInMap.hidden=YES;
        
        
        context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:chatButton cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        
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
        [UIView commitAnimations];
        
        if(activityInfo.activityRelationType==6)
            [editButtonForMapView setHidden:NO];
        
        if(inTransition)
            currentLocationInMap.hidden=NO;
        
        context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:chatButton cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        [UIView commitAnimations];
    }
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [super dealloc];
    [eventView release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)highlightSelection:(int)selection {
    
    // Highlight only the item selected and remove highlights from the other areas
    
    // Unhighlight all the other selections
    DOS1ButtonHighlight.hidden = YES;
    DOS2ButtonHighlight.hidden = YES;
    DOS3ButtonHighlight.hidden = YES;

    
    // Highlight just the 'Going' or 'Requests' section
    switch (selection) {
        case 1:
            DOS1ButtonHighlight.hidden = NO;
            break;
        case 2:
            DOS2ButtonHighlight.hidden = NO;
            break;
        case 3:
            DOS3ButtonHighlight.hidden = NO;
        default:
            break;
    }    
}
-(void)slideInTransitionToLocationView{
    
    inTransition=TRUE;
    
    
    
    if(activityInfo.activityRelationType==6)
      editButtonForMapView.hidden=NO;//check for organizer
    
    
    if(activityInfo.activityRelationType==5)
        leaveActivityButton.hidden=YES;
    currentLocationInMap.hidden=NO;
    
    scrollView.scrollEnabled=NO;
    backButton.hidden=YES;
    [participantListTableView setHidden:YES];
    backToActivityFromMapButton.hidden=NO;
    chatButton.hidden=NO;
    newActivityButton.hidden=YES;
    organizerEditButton.hidden=YES;
    inviteUsersToActivityButton.hidden=YES;
    [eventView.addressSearchBar setHidden:YES];
        if([SoclivityUtilities deviceType] & iPhone5)
    eventView.frame=CGRectMake(0, 0, 640, 416);
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
    if(activityInfo.activityRelationType==6){
      editButtonForMapView.hidden=YES;//check for organizer
      organizerEditButton.hidden=NO;
      inviteUsersToActivityButton.hidden=NO;   
    }
    
    
    
    
    if(activityInfo.activityRelationType==5)
        leaveActivityButton.hidden=NO;
    
        currentLocationInMap.hidden=YES;
    
    if(footerActivated){
        
        footerActivated=FALSE;
        chatView.hidden=YES;
        scrollView.hidden=NO;
    }
    scrollView.scrollEnabled=YES;
    backButton.hidden=NO;
    backToActivityFromMapButton.hidden=YES;
    newActivityButton.hidden=NO;


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
    chatButton.hidden=NO;
    [eventView.addressSearchBar resignFirstResponder];
    [eventView.addressSearchBar setHidden:YES];
    [eventView hideSearchBarAndAnimateWithListViewInMiddle];
    [eventView cancelClicked];
    eventView.editMode=FALSE;
    [eventView setUpLabelViewElements:NO];
    eventView.firstALineddressLabel.text=activityInfo.where_address;
    eventView.secondLineAddressLabel.text=activityInfo.where_zip;    
    eventView.activityInfoButton.hidden=NO;

    
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
            HUD.labelText = @"Requesting To Join";
            
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
            HUD.labelText = @"Confirming to the event...! ";
            
        }
            break;
            
        case kLeavingActivityRequest:
        {
            HUD.labelText = @"Leaving";
            
        }
            break;
        case kPlayerConfirmedRequest:
        {
            HUD.labelText = @"Confirming Player";
            
        }
            break;
            
        case kDeclinePlayerRequest:
        {
            HUD.labelText = @"Declining Request";
            
        }
            break;
            
        case kRemovePlayerRequest:
        {
            HUD.labelText = @"Removing Player";
            
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
    
    
    NSLog(@"responses=%@",responses);
    [HUD hide:YES];
    switch (requestType) {
        case kEditMapElements:
        {
            if(activityInfo.activityRelationType==6)
                editButtonForMapView.hidden=NO;//check for organizer
            
            locationEditLeftCrossButton.hidden=YES;
            locationEditRightCheckButton.hidden=YES;
            backToActivityFromMapButton.hidden=NO;
            chatButton.hidden=NO;
            [eventView.addressSearchBar resignFirstResponder];
            [eventView.addressSearchBar setHidden:YES];
            [eventView hideSearchBarAndAnimateWithListViewInMiddle];

            eventView.activityInfoButton.hidden=NO;
            eventView.editMode=FALSE;

        }
            break;
            
        default:
            break;
    }

}
-(void)updateDetailedActivityScreen:(InfoActivityClass*)activityObj{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    chatButton.hidden=YES;
    editButtonForMapView.hidden=YES;
    
    eventView.editMode=TRUE;
    eventView.addressSearchBar.text=@"";
    [eventView.addressSearchBar setHidden:NO];
    
    [eventView setUpLabelViewElements:YES];
    eventView.activityInfoButton.hidden=YES;

    [eventView showSearchBarAndAnimateWithListViewInMiddle];
    
    
}

-(IBAction)currentLocationBtnClicked:(id)sender{
    [eventView gotoLocation];
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
        [devServer postActivityRequestInvocation:8  playerId:playerId actId:activityInfo.activityId delegate:self];
        
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
            [devServer postActivityRequestInvocation:9  playerId:playerId actId:activityInfo.activityId delegate:self];
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
    SocPlayerClass *myClass=[[SocPlayerClass alloc]init];
    myClass.playerName=activityInfo.organizerName;
    myClass.DOS=activityInfo.DOS;
    myClass.activityId=activityInfo.activityId;
    myClass.latestActivityName=activityInfo.activityName;
    myClass.activityType=activityInfo.type;
    myClass.profilePhotoUrl=activityInfo.ownerProfilePhotoUrl;
    myClass.distance=[activityInfo.distance floatValue];
    SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
    socProfileViewController.playerObject=myClass;
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
        SocPlayerClass *myClass=[[SocPlayerClass alloc]init];
        myClass.playerName=player.name;
        myClass.DOS=player.dosConnection;
        myClass.activityId=activityInfo.activityId;
        myClass.latestActivityName=activityInfo.activityName;
        myClass.activityType=activityInfo.type;
        myClass.profilePhotoUrl=player.photoUrl;
        myClass.distance=[activityInfo.distance floatValue];
        SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
        socProfileViewController.playerObject=myClass;
        [[self navigationController] pushViewController:socProfileViewController animated:YES];
        [socProfileViewController release];
    }
}
@end
