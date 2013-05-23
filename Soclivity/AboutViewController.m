//
//  AboutViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "SoclivityUtilities.h"
#import "NotificationClass.h"
#import "ActivityEventViewController.h"
#import "SOCProfileViewController.h"
#import "GetPlayersClass.h"
#import "SoclivityManager.h"
@implementation AboutViewController
@synthesize delegate,notIdObject;
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];

    // Color background
    self.view.backgroundColor = [SoclivityUtilities returnBackgroundColor:0];
    
    // Extract App Name
    NSDictionary *appMetaData = [[NSBundle mainBundle] infoDictionary];
    NSString* bundleName = [appMetaData objectForKey:@"CFBundleShortVersionString"];
    NSString* buildNumber = [appMetaData objectForKey:@"CFBundleVersion"];
    
    // Build text
    self.buildText.text = [NSString stringWithFormat:@"Soclivity iOS v%@ (%@)", bundleName, buildNumber];
    self.buildText.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    self.buildText.textColor = [SoclivityUtilities returnTextFontColor:5];
    
    // Badge logic
    [self UpdateBadgeNotification];
    
}
-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
}

- (void)viewDidUnload
{
    [self setBuildText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)UpdateBadgeNotification{
    [SoclivityUtilities returnNotificationButtonWithCountUpdate:btnnotify];
}

-(void)didReceiveBackgroundNotification:(NSNotification*)object{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:object];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 60) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
}
-(void)backgroundTapToPush:(NotificationClass*)notification{
    
    NSLog(@"Activity Selected");
    
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    notIdObject=[notification retain];
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
    }
    
    
}

- (void)dealloc {
    [_buildText release];
    [super dealloc];
}
@end
