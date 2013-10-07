//
//  UpComingCompletedEventsViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpComingCompletedEventsViewController.h"
#import "SoclivityUtilities.h"
#import "SoclivityManager.h"
#import "MainServiceManager.h"
#import "GetPlayersClass.h"
#import "ActivityEventViewController.h"
#import "DetailedActivityInfoInvocation.h"
#import "SocPlayerClass.h"
#import "SOCProfileViewController.h"
#import "GetUpcomingActivitiesInvocation.h"
#import "NotificationClass.h"
@interface UpComingCompletedEventsViewController(Private) <DetailedActivityInfoInvocationDelegate,GetUpcomingActivitiesInvocationDelegate>{
}
@end


@implementation UpComingCompletedEventsViewController
@synthesize delegate,activityListView,isNotSettings,myActivitiesArray,invitedToArray,compeletedArray,goingToArray,playersName;
@synthesize isNotLoggedInUser,player2Id,notIdObject;
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

-(void)UpdateBadgeNotification{
    [SoclivityUtilities returnNotificationButtonWithCountUpdate:btnnotify];
    
}
#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (UpdateBadgeNotification) name:@"WaitingOnYou_Count" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatInAppNotification:) name:@"ChatNotification" object:Nil];



}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoteNotificationReceivedWhileRunning" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WaitingOnYou_Count" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatNotification" object:nil];
    
}

-(void)chatInAppNotification:(NSNotification*)note{
    NotificationClass *notifObject=[SoclivityUtilities getNotificationChatPost:note];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 60) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
    
    
}

-(IBAction)autoSlideToHome:(id)sender{
    SOC.pushStateOn=TRUE;
    [self profileSliderPressed:sender];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_6_0)){
    
        self.restorationIdentifier = @"UpComingCompletedEventsViewController";
        self.restorationClass = [self class];
        
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        topBarImageView.frame=CGRectMake(0, 0, 320, 64);
        topBarImageView.image=[UIImage imageNamed:@"topbarIOS7.png"];
        activititesLabel.frame=CGRectMake(50, 33, 220, 21);
        homeButton.frame=CGRectMake(280,20, 40, 40);
        backActivityButton.frame=CGRectMake(5,20, 40, 40);
        segmentedBarImageView.frame=CGRectMake(0, 64, 320, 40);

        if([SoclivityUtilities deviceType] & iPhone5){
            
            activityListView.frame=CGRectMake(0, 104, 320, 426);
            bottomBarImageView.frame=CGRectMake(0, 568-40, 320, 40);
            profileButton.frame=CGRectMake(5, 420+20+88, 40, 40);
            btnnotify.frame=CGRectMake(35, 539, 32, 21);
            
        }
        else{
            activityListView.frame=CGRectMake(0, 104, 320, 338);
            bottomBarImageView.frame=CGRectMake(0, 568-40-88, 320, 40);
            profileButton.frame=CGRectMake(5, 420+20, 40, 40);
            btnnotify.frame=CGRectMake(35, 449, 32, 21);
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

    typeOfAct=1;
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];

    [self UpdateBadgeNotification];
    

    activititesLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    activititesLabel.textColor=[UIColor whiteColor];
    activititesLabel.backgroundColor=[UIColor clearColor];
    
    if(isNotLoggedInUser){
        activititesLabel.text=[NSString stringWithFormat:@"%@'s Activities",playersName];
    }
    
    
    organizedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    organizedButton.frame = CGRectMake(9.6, 70, 71, 27);
    }
    else{
    organizedButton.frame = CGRectMake(9.6, 50, 71, 27);
    }
    [organizedButton setBackgroundImage:[UIImage imageNamed:
                                         @"S10_organizedHighlighted.png"] forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:[UIImage imageNamed:
                                         @"S10_organizedHighlighted.png"] forState:UIControlStateHighlighted    ];
    [organizedButton setTitle:@"Organized" forState:UIControlStateNormal];
    [organizedButton setTitle:@"Organized" forState:UIControlStateHighlighted];
    [organizedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [organizedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    organizedButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];

    [organizedButton addTarget:self action:@selector(organizedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:organizedButton];

    
    
    if(!isNotLoggedInUser){
        
    invitedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    invitedButton.frame = CGRectMake(90.2, 70, 68, 27);
            }else{
    invitedButton.frame = CGRectMake(90.2, 50, 68, 27);
            }
    [invitedButton setTitle:@"Invited" forState:UIControlStateNormal];
    [invitedButton setTitle:@"Invited" forState:UIControlStateHighlighted];
    [invitedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [invitedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    invitedButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    [invitedButton addTarget:self action:@selector(invitedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:invitedButton];

    }

    
    goingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
     if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    goingButton.frame = CGRectMake(167.8, 70, 58, 27);
     }
         else{
    goingButton.frame = CGRectMake(167.8, 50, 58, 27);
         }
    [goingButton setTitle:@"Going" forState:UIControlStateNormal];
    [goingButton setTitle:@"Going" forState:UIControlStateHighlighted];
    [goingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [goingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    goingButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];

    [goingButton addTarget:self action:@selector(goingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goingButton];
    
    
    completedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    completedButton.frame = CGRectMake(235.4, 70, 75, 27);
    }
    else{
    completedButton.frame = CGRectMake(235.4, 50, 75, 27);
    }
    [completedButton setTitle:@"Completed" forState:UIControlStateNormal];
    [completedButton setTitle:@"Completed" forState:UIControlStateHighlighted];
    [completedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [completedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    completedButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];

    [completedButton addTarget:self action:@selector(completedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completedButton];

    if(isNotLoggedInUser){
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
            organizedButton.frame = CGRectMake(29, 70, 71, 27);
            goingButton.frame = CGRectMake(129, 70, 58, 27);
            completedButton.frame = CGRectMake(216, 70, 75, 27);
        }
        else{
            organizedButton.frame = CGRectMake(29, 50, 71, 27);
            goingButton.frame = CGRectMake(129, 50, 58, 27);
            completedButton.frame = CGRectMake(216, 50, 75, 27);
            
        }
    }

    activityListView.delegate=self;
    [activityListView LoadTable];
    activityListView.isOrganizerList=TRUE;
    
    [self performSelector:@selector(RefreshFromTheListView) withObject:nil afterDelay:0.1];
    
    
    if(isNotSettings){
        profileButton.hidden=YES;
        backActivityButton.hidden=NO;
        btnnotify.hidden=YES;
        homeButton.hidden=YES;
    }
    else{
        homeButton.hidden=NO;
    }
        //activityListView.tableView.contentOffset = CGPointMake(0, -90.0f);
        //[activityListView pullToRefreshMannually];

        // Do any additional setup after loading the view from its nib.
}


+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"UpComingCompletedEventsViewController_iphone5";
    }
    else{
        nibNameBundle=@"UpComingCompletedEventsViewController";
    }
    
    UIViewController * myViewController =
    [[UpComingCompletedEventsViewController alloc]
     initWithNibName:nibNameBundle
     bundle:nil];
    
    return myViewController;
}

-(void)didReceiveBackgroundNotification:(NSNotification*)object{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:object];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 60) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
}
-(void)backgroundTapToPush:(NotificationClass*)notification{
    
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
        isInAppNotif=TRUE;

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

    
    if(!isInAppNotif){
        NSString*nibNameBundle=nil;
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"ActivityEventViewController_iphone5";
        }
        else{
            nibNameBundle=@"ActivityEventViewController";
        }
        
        ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
        
        activityEventViewController.activityInfo=response;
        [[self navigationController] pushViewController:activityEventViewController animated:YES];
        [activityEventViewController release];
        
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [activityListView BytesDownloadedTimeToHideTheSpinner];
        
    }

    
    else{
    
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
    
}


-(void)organizedButtonPressed:(id)sender{
    
    typeOfAct=1;
    [activityListView populateEvents:myActivitiesArray typeOfEvent:typeOfAct];
    
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organizedHighlighted.png"] forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organizedHighlighted.png"] forState:UIControlStateHighlighted];
    
    [organizedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [organizedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
    [invitedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [invitedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [invitedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [invitedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [goingButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [goingButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [goingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [goingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [completedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [completedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [completedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [completedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
}

-(void)invitedButtonPressed:(id)sender{
    
    typeOfAct=2;
    [activityListView populateEvents:invitedToArray typeOfEvent:typeOfAct];
    
    [organizedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [organizedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [organizedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invitedHighlighted.png"] forState:UIControlStateNormal];
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invitedHighlighted.png"] forState:UIControlStateHighlighted];
    [invitedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [invitedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
    
    [goingButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [goingButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [goingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [goingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [completedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [completedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [completedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [completedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
}


-(void)goingButtonPressed:(id)sender{
    
    typeOfAct=3;
    [activityListView populateEvents:goingToArray typeOfEvent:typeOfAct];
    
    [organizedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [organizedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [organizedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [invitedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [invitedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [invitedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [invitedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_goingHighlighted.png"] forState:UIControlStateNormal];
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_goingHighlighted.png"] forState:UIControlStateHighlighted];
    [goingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
    
    [completedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [completedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [completedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [completedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];


}

-(void)completedButtonPressed:(id)sender{
    
        typeOfAct=4;
    [activityListView populateEvents:compeletedArray typeOfEvent:typeOfAct];
    
    [organizedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [organizedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [organizedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [invitedButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [invitedButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [invitedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [invitedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [goingButton setBackgroundImage:Nil forState:UIControlStateNormal];
    [goingButton setBackgroundImage:Nil forState:UIControlStateHighlighted];
    [goingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [goingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    
    
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completedHighlighted.png"] forState:UIControlStateNormal];
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completedHighlighted.png"] forState:UIControlStateHighlighted];
    [completedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
}

-(void)PushToProfileView:(InfoActivityClass*)detailedInfo{
    
    NSLog(@"upcoming completed events");
    
    if([SOC.loggedInUser.idSoc intValue]==detailedInfo.organizerId){
        NSString*nibNameBundle=nil;
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"UpComingCompletedEventsViewController_iphone5";
        }
        else{
            nibNameBundle=@"UpComingCompletedEventsViewController";
        }
        
        UpComingCompletedEventsViewController *upComingCompletedEventsViewController=[[UpComingCompletedEventsViewController alloc] initWithNibName:nibNameBundle bundle:nil];
        
        [[self navigationController] pushViewController:upComingCompletedEventsViewController animated:YES];
        [upComingCompletedEventsViewController release];
        
    }
    else{
        SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
        socProfileViewController.friendId=detailedInfo.organizerId;
        [[self navigationController] pushViewController:socProfileViewController animated:YES];
        [socProfileViewController release];
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)RefreshFromTheListView{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    NSString  *currentTime=[dateFormatter stringFromDate:[NSDate date]];
    
    [[NSUserDefaults standardUserDefaults] setValue:currentTime forKey:@"SOCActivityTimeUpdate"];
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        if(!firstTime){
        [self startAnimation];
            firstTime=TRUE;
        }
        if(isNotLoggedInUser){
            [devServer getUpcomingActivitiesForUserInvocation:[SOC.loggedInUser.idSoc intValue] player2:player2Id delegate:self];
            
            
        }
        else{
            
            
            [devServer getUpcomingActivitiesForUserInvocation:[SOC.loggedInUser.idSoc intValue] player2:[SOC.loggedInUser.idSoc intValue] delegate:self];
            
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

-(void)startAnimation{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    HUD.labelText = @"Loading...";
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}


-(void)UpcomingActivitiesInvocationDidFinish:(GetUpcomingActivitiesInvocation*)invocation
                                withResponse:(NSArray*)responses
                                   withError:(NSError*)error{
    
    [HUD hide:YES];
    
    if([responses count]>0){
        
        for(int i=0;i<[responses count];i++){
        NSNumber *activityType=[[responses objectAtIndex:i] objectForKey:@"activityType"];
        switch ([activityType intValue]) {
            case 1:
            {
                NSLog(@"The user has got Organizing Activities");
                myActivitiesArray=[[responses objectAtIndex:i] objectForKey:@"Elements"];

            }
                break;
                
            case 2:
            {
                NSLog(@"The user has got invitedToArray Activities");
                invitedToArray=[[responses objectAtIndex:i] objectForKey:@"Elements"];
                
            }
                break;
            case 3:
            {
                NSLog(@"The user has got compeletedArray Activities");
                compeletedArray=[[responses objectAtIndex:i] objectForKey:@"Elements"];
                
            }
                break;
            case 4:
            {
                NSLog(@"The user has got goingToArray Activities");
                goingToArray=[[responses objectAtIndex:i] objectForKey:@"Elements"];
                
            }
                break;
        }
            
            
        }
        
        switch (typeOfAct) {
            case 1:
            {
                [activityListView populateEvents:myActivitiesArray typeOfEvent:typeOfAct];

            }
                break;
            case 2:
            {
                [activityListView populateEvents:invitedToArray typeOfEvent:typeOfAct];
                
            }
                break;
            case 4:
            {
                [activityListView populateEvents:compeletedArray typeOfEvent:typeOfAct];
                
            }
                break;
            case 3:
            {
                [activityListView populateEvents:goingToArray typeOfEvent:typeOfAct];
                
            }
                break;
                
            default:
                break;
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results Found" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;

    }
}


-(void)PushToDetailActivityView:(InfoActivityClass*)detailedInfo andFlipType:(NSInteger)andFlipType{
    NSLog(@"PushToDetailActivityView");
    

    
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        isInAppNotif=FALSE;

        
        [devServer getDetailedActivityInfoInvocation:[SOC.loggedInUser.idSoc intValue]    actId:detailedInfo.activityId  latitude:SOC.currentLocation.coordinate.latitude longitude:SOC.currentLocation.coordinate.longitude delegate:self];
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
#pragma mark -
#pragma mark DetailedActivityInfoInvocationDelegate Method


@end
