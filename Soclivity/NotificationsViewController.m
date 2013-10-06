//
//  NotificationsViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationsViewController.h"
#import "SoclivityUtilities.h"
#import "NotificationClass.h"
#import <QuartzCore/QuartzCore.h>
#import "ActivityEventViewController.h"
#import "SOCProfileViewController.h"
#import "SocPlayerClass.h"
#import "GetPlayersClass.h"
@implementation NotificationsViewController
@synthesize delegate,notIdObject,isPushedFromStack, notificationListingArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)autoSlideToHome:(id)sender{
    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    SOC.pushStateOn=TRUE;
    [self profileSliderPressed:sender];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    SOC.loggedInUser.badgeCount=0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoteNotificationReceivedWhileRunning" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RandomFetch" object:nil];


    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:SOC.loggedInUser.badgeCount];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatNotification" object:nil];


}


-(void)viewWillAppear:(BOOL)animated{

    
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserNotifications) name:@"RandomFetch" object:Nil];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (BadgeNotification) name:@"WaitingOnYou_Count" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserNotifications) name:@"ChatNotification" object:Nil];


    
    
    [self getUserNotifications];

}

-(void)getUserNotifications{
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:1];
        [devServer getUserNotificationsInfoInvocation:self notificationType:kGetNotifications notficationId:-1];
        
    }
    else{
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }

}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_6_0)){
    self.restorationIdentifier = @"NotificationsViewController";
    self.restorationClass = [self class];
        }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        topBarImageView.frame=CGRectMake(0, 0, 320, 64);
        topBarImageView.image=[UIImage imageNamed:@"topbarIOS7.png"];
        waitingOnYouLabel.frame=CGRectMake(50, 20, 220, 44);
        homeButton.frame=CGRectMake(280,20, 40, 40);
        backButton.frame=CGRectMake(5,20, 40, 40);
        btnnotify2.frame=CGRectMake(30,20, 27, 27);
        if([SoclivityUtilities deviceType] & iPhone5){
            
            
            bottomBarImageView.frame=CGRectMake(0, 568-40, 320, 40);
            sliderButton.frame=CGRectMake(5, 420+20+88, 40, 40);
            btnnotify.frame=CGRectMake(28, 412+20+88, 27, 27);
            
        }
        else{
            
            bottomBarImageView.frame=CGRectMake(0, 568-40-88, 320, 40);
            sliderButton.frame=CGRectMake(5, 420+20, 40, 40);
            btnnotify.frame=CGRectMake(28, 412+20, 27, 27);
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

    self.view.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
    backButton.hidden=YES;
    sliderButton.hidden=NO;
    btnnotify2.hidden=YES;
    btnnotify.hidden=NO;
    
    if(isPushedFromStack){
        backButton.hidden=NO;
        sliderButton.hidden=YES;
        btnnotify.hidden=YES;
        btnnotify2.hidden=NO;

    }

    
    
    CGRect waitingOnYouRect;
    
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        
        if([SoclivityUtilities deviceType] & iPhone5){
             waitingOnYouRect=CGRectMake(0, 64, 320,375+85);
        }
        else{
            waitingOnYouRect=CGRectMake(0, 64, 320, 377);
        }
        
    }
    else{
        if([SoclivityUtilities deviceType] & iPhone5)
            waitingOnYouRect=CGRectMake(0, 44, 320,375+85);
        
        else
            waitingOnYouRect=CGRectMake(0, 44, 320, 377);
    }
    notificationView=[[WaitingOnYouView alloc]initWithFrame:waitingOnYouRect];
    notificationView.delegate=self;
    [self.view addSubview:notificationView];
    [self.view insertSubview:btnnotify aboveSubview:notificationView];

    devServer=[[MainServiceManager alloc]init];
    [self BadgeNotification];
    
    waitingOnYouLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    waitingOnYouLabel.textColor=[UIColor whiteColor];
    waitingOnYouLabel.backgroundColor=[UIColor clearColor];

}

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"NotificationsViewController_iphone5";
    }
    else{
        nibNameBundle=@"NotificationsViewController";
    }
    
    UIViewController * myViewController =
    [[NotificationsViewController alloc]
     initWithNibName:nibNameBundle
     bundle:nil];
    
    return myViewController;
}


- (void)didReceiveBackgroundNotification:(NSNotification*) note{

    // time to refresh the notification screen
    
    [self getUserNotifications];
}


-(void)BadgeNotification
{
    if(isPushedFromStack){
        [SoclivityUtilities returnNotificationButtonWithCountUpdate:btnnotify2];
    }
    else{
    [SoclivityUtilities returnNotificationButtonWithCountUpdate:btnnotify];
    }
}


-(void)notificationsToShowDidFinish:(GetNotificationsInvocation *)invocation withResponse:(NSArray *)responses withError:(NSError *)error{
    
    
    [HUD hide:YES];
    
    [self BadgeNotification];
    calendarInc=0;
    self.notificationListingArray=[responses retain];
    calendarArray=[[NSMutableArray alloc]init];
    // sync your calendar too
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    
    if([responses count]>0){
     
        for(NotificationClass *obj in responses){
            
            if(([obj.notificationType integerValue]==1||[obj.notificationType integerValue]==2||[obj.notificationType integerValue]==3||[obj.notificationType integerValue]==4||[obj.notificationType integerValue]==15)&& !obj.isRead){
                [calendarArray addObject:obj];
            }
        }
        if([calendarArray count]>0){
        NotificationClass *notify=[calendarArray objectAtIndex:calendarInc];
            isSyncing=TRUE;
            
        [devServer getDetailedActivityInfoInvocation:[SOC.loggedInUser.idSoc intValue]    actId:notify.activityId  latitude:[notify.latitude floatValue] longitude:[notify.longitude floatValue] delegate:self];
        }
        else{
          [notificationView toReloadTableWithNotifications:[NSMutableArray arrayWithArray:responses]];            
        }
    }
    else{
        [notificationView toReloadTableWithNotifications:[NSMutableArray arrayWithArray:responses]];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:SOC.loggedInUser.badgeCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];
}


-(void)backgroundTapToPush:(NotificationClass*)notification{
    
}

-(NSMutableArray*) SetUpDummyNotifications{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Notifications" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    NSMutableArray *content = [NSMutableArray new];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        NotificationClass *play = [[NotificationClass alloc] init];
        play.notificationString = [playDictionary objectForKey:@"Notification"];
        NSNumber * n = [playDictionary objectForKey:@"type"];
        play.type= [n intValue];
        play.date = [playDictionary objectForKey:@"Date"];
        play.profileImage = [playDictionary objectForKey:@"ImageName"];
        play.count = [playDictionary objectForKey:@"Count"];
        
        NSLog(@"Value=%d",[n intValue]);
        
        switch (play.type) {
            case 0:
            {
            }
                break;
            case 1:
            {
                
            }
                break;
                
            case 2:
            {
                
            }
                break;
                
        }
        [content addObject:play];
    }
    
    return content;
    
}

-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
}

-(void)startAnimation:(int)tag{
    
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    switch (tag) {
        case 1:
        {
            HUD.labelText = @"Loading...";
            
        }
            break;
            
        case 2:
        {
            HUD.labelText = @"Going...";
            
        }
            break;
            
        case 3:
        {
            HUD.labelText = @"Not Going...";
            
        }
            break;
            
        case 4:
        {
            HUD.labelText = @"Accepted...";
            
        }
            break;
            
            
        case 5:
        {
            HUD.labelText = @"Declined...";
            
        }
            break;


        case 6:
        {
            HUD.labelText = @"Updating...";
            
        }
            break;


            
        default:
            break;
    }
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)hideMBProgress{
    [HUD hide:YES];
}


#pragma mark -

- (void)pushUserToDetailedNavigation:(NotificationClass*)notify{
    
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    notIdObject=[notify retain];
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        switch ([notify.notificationType intValue]) {
            case 7:
            case 8:
            case 9:
            case 10:
            case 13:
            case 16:
            {
                [devServer getDetailedActivityInfoInvocation:notify.referredId    actId:notify.activityId  latitude:[notify.latitude floatValue] longitude:[notify.longitude floatValue] delegate:self];
                
            }
                break;
                
            default:
            {
                [devServer getDetailedActivityInfoInvocation:[notify.userId intValue]    actId:notify.activityId  latitude:[notify.latitude floatValue] longitude:[notify.longitude floatValue] delegate:self];
                
            }
                break;
        }
    
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

-(void)loadNextCalendarEvent{
    
    calendarInc++;

    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    
    NotificationClass *notify=[calendarArray objectAtIndex:calendarInc];
    isSyncing=TRUE;
    [devServer getDetailedActivityInfoInvocation:[SOC.loggedInUser.idSoc intValue]    actId:notify.activityId  latitude:[notify.latitude floatValue] longitude:[notify.longitude floatValue] delegate:self];
    
}


#pragma mark DetailedActivityInfoInvocationDelegate Method
-(void)DetailedActivityInfoInvocationDidFinish:(DetailedActivityInfoInvocation*)invocation
                                  withResponse:(InfoActivityClass*)response
                                     withError:(NSError*)error{
    
    
    
    if(isSyncing){
        isSyncing=FALSE;
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        [SOC deltaUpdateSyncCalendar:response];


        if(calendarInc==[calendarArray count]-1){
            [notificationView toReloadTableWithNotifications:[NSMutableArray arrayWithArray:self.notificationListingArray]];
        }
        else{

            [self loadNextCalendarEvent];
        }
    }
    else{
    [HUD hide:YES];
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    

    
    
        
        switch ([notIdObject.notificationType intValue]) {
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
                if([notIdObject.notificationType intValue]==17)
                    activityEventViewController.footerActivated=YES;
                [[self navigationController] pushViewController:activityEventViewController animated:YES];
                [activityEventViewController release];
                
            }
                break;
                
                
                case 7:
                case 8:// leave an activity
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
        }
        
    [notificationView updateButtonAndAnimation];
    }
    
}
-(void)userWantsToDeleteTheNofication:(NSInteger)notificationId{
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        [self startAnimation:6];
    [devServer getUserNotificationsInfoInvocation:self notificationType:kRemoveNotification notficationId:notificationId];
}
else{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    return;
    
}

}

-(void)successRemoveNotification:(NSString*)msg{
    
    [HUD hide:YES];
    [notificationView notificationRemoved];
}

-(void)userGoingNotification:(NSInteger)tag{
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:2];
        [devServer postActivityRequestInvocation:4  playerId:[SOC.loggedInUser.idSoc intValue] actId:tag delegate:self];
        
    }
    else{
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }


}

-(void)userNotGoingNotification:(NSInteger)tag{
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:3];
        [devServer postActivityRequestInvocation:14  playerId:[SOC.loggedInUser.idSoc intValue] actId:tag delegate:self];
        
    }
    else{
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
    
    
}
-(void)acceptNotification:(NSInteger)tag player:(NSInteger)player{
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:4];
        
        [devServer postActivityRequestInvocation:7  playerId:player actId:tag delegate:self];

        
    }
    else{
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
    
    
}

-(void)declineNotification:(NSInteger)tag player:(NSInteger)player{
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:5];
        
        [devServer postActivityRequestInvocation:13  playerId:player actId:tag delegate:self];
        
        
    }
    else{
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
    
    
}

-(void)PostActivityRequestInvocationDidFinish:(PostActivityRequestInvocation*)invocation
                                 withResponse:(BOOL)response relationTypeTag:(NSInteger)relationTypeTag
                                    withError:(NSError*)error{
    [HUD hide:YES];
    
    switch (relationTypeTag) {
        case 4:
        case 7:
        case 14:
        case 13:
        {
            [notificationView requestComplete];
        }
            break;
            
    }
}

#pragma mark - View lifecycle


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

@end
