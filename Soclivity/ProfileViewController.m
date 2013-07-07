//
//  ProfileViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "SoclivityUtilities.h"
#import "MainServiceManager.h"
#import "RegistrationDetailInvocation.h"
#import "MBProgressHUD.h"
#import "GetPlayersClass.h"
#import "SoclivityManager.h"
#import "SlidingDrawerViewController.h"
#import "NotificationClass.h"
#import "DetailedActivityInfoInvocation.h"
#import "SOCProfileViewController.h"
#import "ActivityEventViewController.h"
@interface ProfileViewController(Private) <MBProgressHUDDelegate,RegistrationDetailDelegate,DetailedActivityInfoInvocationDelegate>
@end

@implementation ProfileViewController
@synthesize delegate,activityTypesView,isFirstTime,notIdObject;
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

-(void)UpdateBadgeNotification
{
    [SoclivityUtilities returnNotificationButtonWithCountUpdate:btnnotify];
}

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


-(void)didReceiveBackgroundNotification:(NSNotification*)object{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:object];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 60) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
}

-(void)chatInAppNotification:(NSNotification*)note{
    NotificationClass *notifObject=[SoclivityUtilities getNotificationChatPost:note];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 60) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
    
    
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];
    updateActivityLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    updateActivityLabel.textColor=[UIColor whiteColor];
    updateActivityLabel.backgroundColor=[UIColor clearColor];
    updateActivityLabel.shadowColor = [UIColor blackColor];
    updateActivityLabel.shadowOffset = CGSizeMake(0,-1);
    btnnotify.hidden=FALSE;

    activityTypesView.delegate=self;
    
    if(isFirstTime){
        getStartedButton.hidden=YES;
        profileButton.hidden=YES;
        updateActivityLabel.text=@"Pick stuff you like to do...";
        activityTypesView.isRegisteration=TRUE;
        btnnotify.hidden=TRUE;
    }
    else{
        
        [self UpdateBadgeNotification];
        

        activityTypesView.isRegisteration=FALSE;
        getStartedButton.hidden=YES;
        profileButton.hidden=NO;
        updateActivityLabel.text=@"Update Activity Types";
        [activityTypesView updateActivityTypes];
    }

    // Do any additional setup after loading the view from its nib.
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


-(IBAction)profileSliderPressed:(id)sender{
     [delegate showLeft:sender];
}
-(IBAction)getStartedAction:(id)sender{
    if([activityTypesView MakeSureAtLeastOneActivitySelected])
         [self RegisterUserForTheFirstTime];
}
-(void)showgetStartedBtnOrNot:(BOOL)show{
    if(show){
        getStartedButton.hidden=NO;
        
    }
    else{
        getStartedButton.hidden=YES;
    }
}

-(void)updateActivityTypes:(int)show{

    
        
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        
        [self startAnimation:show];
        [SOC userProfileDataUpdate];
        [devServer registrationDetailInvocation:self isFBuser:NO isActivityUpdate:2];
        
        
    }
    else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[alert show];
		[alert release];
		return;
		
	}
        
    

    
    
}

-(void)RegisterUserForTheFirstTime{
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        
            //implememt different registration procedure for facebook.
        [self startAnimation:1];
        [devServer registrationDetailInvocation:self isFBuser:YES isActivityUpdate:1];
        
        
    }
    else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[alert show];
		[alert release];
		return;
		
	}
    
    
}

- (void)startAnimation:(NSInteger)type{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    switch (type) {
        case 1:
        {
            HUD.labelText = @"Registering You";
            
        }
            break;
            
        case 2:
        {
            HUD.labelText = @"Adding";
            
        }
            break;
            
        case 3:
        {
            HUD.labelText = @"Removing";
            
        }
            break;

    }
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
}

#define kRegisterSucces 2

-(void)RegistrationDetailInvocationDidFinish:(RegistrationDetailInvocation*)invocation
                                  withResult:(NSArray*)result andUpdateType:(BOOL)andUpdateType
                                   withError:(NSError*)error{
    // Stop the animation
    [HUD hide:YES];
    
    
    switch (andUpdateType) {
        case 1:
        {
            NSLog(@"RegistrationDetailInvocationDidFinish called");
            GetPlayersClass *obj=[result objectAtIndex:0];
            NSLog(@"SOC ID=%d",[obj.idSoc intValue]);
            
            if([obj.idSoc intValue]==0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                                message:@"Sorry we couldn't register you."
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                
                [alert show];
                [alert release];
            }
            else {
                SOC.loggedInUser=obj;
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Successful"
                                                                message:@"Welcome to Soclivity!"
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                
                alert.tag=kRegisterSucces;
                [alert show];
                [alert release];
                
            }
            return;
        }
            break;
            
        case 2:
        {
            
        }
            break;

            
        default:
            break;
    }
    

    
}

#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //[alertView resignFirstResponder];
    
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kRegisterSucces:
            {
                [self PushHomeScreen];
            }
                break;
        }
    }
    else
        NSLog(@"Clicked Cancel Button");
    
}

-(void)PushHomeScreen{
    
    
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"SlideViewController_iphone5";
    }
    else{
        
        nibNameBundle=@"SlideViewController";
    }

    SlidingDrawerViewController *slideViewController = [[SlidingDrawerViewController alloc] initWithNibName:nibNameBundle bundle:[NSBundle mainBundle]];
    slideViewController.delegate = slideViewController;
    slideViewController.isFBlogged=YES;
    [self.navigationController pushViewController:slideViewController animated:YES];
    [slideViewController release];
    
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

@end
