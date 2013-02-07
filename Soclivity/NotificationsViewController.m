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
#import "ParticipantClass.h"

@implementation NotificationsViewController
@synthesize delegate,responsedata,arrnotification,btnnotify,lstrnotificationtypeid;

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

-(void)BadgeNotification
{
    self.btnnotify.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
    
    int count=[[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue];
    
    if (count==0)
    {
        self.btnnotify.alpha=0;
    }//END if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Wait
    
    else
    {
        if ([[NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue]] length]<2)
        {
            [self.btnnotify setBackgroundImage:[UIImage imageNamed:@"notifyDigit1.png"] forState:UIControlStateNormal];
            self.btnnotify.frame = CGRectMake(self.btnnotify.frame.origin.x,self.btnnotify.frame.origin.y,27,27);
        }//END if ([[NSString stringWithFormat:@"%i",[[[N
        
        else{
            [self.btnnotify setBackgroundImage:[UIImage imageNamed:@"notifyDigit2.png"] forState:UIControlStateNormal];
            self.btnnotify.frame = CGRectMake(self.btnnotify.frame.origin.x,self.btnnotify.frame.origin.y,33,28);
        }//END Else Statement
        
        self.btnnotify.alpha=1;
        [self.btnnotify setTitle:[NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue]] forState:UIControlStateNormal];
        [self.btnnotify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }//END Else Statement
}

-(void)GetNotifications
{
    NSString *lstrnotificationid=[[NSUserDefaults standardUserDefaults] valueForKey:@"Notification_id"];
    
    if(lstrnotificationid==NULL || [lstrnotificationid intValue]==0)
    {
      lstrnotificationid=@"";
    }//END if(lstrnotificationid==NULL || [lstrnotific
        
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/mynotifications.json?logged_in_user_id=%@&ids=%@",ProductionServer,[[NSUserDefaults standardUserDefaults] valueForKey:@"logged_in_user_id"],lstrnotificationid]];
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responsedata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responsedata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
													message:@"Try Again Later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
	return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
    
    self.arrnotification=[[NSMutableArray alloc] init];
    self.arrnotification = [[[NSString alloc] initWithData:self.responsedata
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    [self.responsedata release];
    
    if ([self.arrnotification count]==0) {
        self.view.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
        notificationImageView.hidden=NO;
        socFadedImageView.hidden=NO;
    }//END if ([[[self.arrnotification objectAtIndex:i] valueForKey:@
        
    else{
        
        [[NSUserDefaults standardUserDefaults] setValue:[self.arrnotification valueForKey:@"badge"] forKey:@"Waiting_On_You_Count"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:[self.arrnotification valueForKey:@"badge"]];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] IncreaseBadgeIcon];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Notification_id"];
        
        NSString *lstrviewexists;
        
        for(UIView *subview in [self.view subviews])
        {
            if([subview isKindOfClass:[WaitingOnYouView class]])
            {
                lstrviewexists=@"TRUE";
            }//END if([subview isKindOfClass:[WaitingOnYouView class]])
            
            else{
                lstrviewexists=@"FALSE";
            }//END Else Statemnt
        }//END for(UIView *subview in [self.view subviews])
        
        if ([lstrviewexists isEqualToString:@"TRUE"])
        {
            //notificationView = (WaitingOnYouView*)subview;
            notificationView._notifications=self.arrnotification;
            [notificationView.waitingTableView reloadData];
        }//END if ([lstrviewexists isEqualToString:@"TRUE"])
        
        else{
                notificationImageView.hidden=YES;
                socFadedImageView.hidden=YES;
                
                //NSMutableArray *notificationArray=[self SetUpDummyNotifications];
                CGRect waitingOnYouRect;
                if([SoclivityUtilities deviceType] & iPhone5)
                    waitingOnYouRect=CGRectMake(0, 44, 320,375+85);
                
                else
                    waitingOnYouRect=CGRectMake(0, 44, 320, 377);
                
                notificationView=[[WaitingOnYouView alloc]initWithFrame:waitingOnYouRect andNotificationsListArray:self.arrnotification];
                notificationView.superDelegate = self;
                notificationView.delegate=self;
                [self.view addSubview:notificationView];
                [self.view bringSubviewToFront:self.btnnotify];
        }//END Else StaTEMENT
    }//END Else Statement
    
    [self performSelector:@selector(hideMBProgress) withObject:nil afterDelay:1.0];
 }

-(void)startAnimation{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    HUD.labelText = @"Loading...";
    [self.view insertSubview:HUD aboveSubview:notificationView];
    HUD.delegate = self;
    [HUD show:YES];
}

-(void)hideMBProgress{
    [HUD hide:YES];
}


#pragma mark -

-(void) navigate:(NSMutableDictionary*)dict{
    [self Pushactivity:dict];
}

-(void)Pushactivity:(NSMutableDictionary *)dictactivity
{
    devServer=[[MainServiceManager alloc]init];
    
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if([SoclivityUtilities hasNetworkConnection]){
        [devServer getDetailedActivityInfoInvocation:[[dictactivity valueForKey:@"user_id"] intValue]    actId:[[dictactivity valueForKey:@"activity_id"] intValue]  latitude:[[dictactivity valueForKey:@"lat"] floatValue] longitude:[[dictactivity valueForKey:@"lng"] floatValue] delegate:self];
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
                                  withResponse:(InfoActivityClass*)responses
                                     withError:(NSError*)error{
    
    
    
    [self performSelectorOnMainThread:@selector(pushActivityController:) withObject:responses waitUntilDone:NO];
    
#if 0
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(synchronousDownloadProfilePhotoBytes:)
                                        object:responses];
    [queue addOperation:operation];
    [operation release];
    
#endif
    
}

-(void)synchronousDownloadProfilePhotoBytes:(InfoActivityClass*)player{
    
    int index=0;
    for(ParticipantClass *pC in player.friendsArray){
        index++;
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pC.photoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            pC.profilePhotoImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            pC.profilePhotoImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
        
        
    }
    index=0;
    for(ParticipantClass *pC in player.friendsOfFriendsArray){
        index++;
        NSLog(@"friendsOfFriendsArray=%d",index);
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pC.photoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            pC.profilePhotoImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            pC.profilePhotoImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
    }
    
    
    index=0;
    for(ParticipantClass *pC in player.pendingRequestArray){
        index++;
        NSLog(@"pendingRequestArray=%d",index);
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pC.photoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            pC.profilePhotoImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            pC.profilePhotoImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
    }
    
    index=0;
    for(ParticipantClass *pC in player.otherParticipantsArray){
        index++;
        NSLog(@"otherParticipantsArray=%d",index);
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pC.photoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            pC.profilePhotoImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            pC.profilePhotoImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
    }
    
    
    
    [self performSelectorOnMainThread:@selector(pushActivityController:) withObject:player waitUntilDone:NO];
    
    
}

-(void)pushActivityController:(InfoActivityClass*)response{
    
   if ([self.lstrnotificationtypeid intValue]==8 || [self.lstrnotificationtypeid intValue]==9 || [self.lstrnotificationtypeid intValue]==10 || [self.lstrnotificationtypeid intValue]==13 || [self.lstrnotificationtypeid intValue]==16)
    {
        SocPlayerClass *myClass=[[SocPlayerClass alloc]init];
        myClass.playerName=response.organizerName;
        myClass.DOS=response.DOS;
        myClass.activityId=response.activityId;
        myClass.latestActivityName=response.activityName;
        myClass.activityType=response.type;
        myClass.profilePhotoUrl=response.ownerProfilePhotoUrl;
        myClass.distance=[response.distance floatValue];
        SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
        socProfileViewController.playerObject=myClass;
        [[self navigationController] pushViewController:socProfileViewController animated:YES];
        [socProfileViewController release];
    }//END if ([self.lstrnotificationtypeid intValue]==16)
    
    else if ([self.lstrnotificationtypeid intValue]==1 || [self.lstrnotificationtypeid intValue]==2 || [self.lstrnotificationtypeid intValue]==3 || [self.lstrnotificationtypeid intValue]==4 || [self.lstrnotificationtypeid intValue]==5 || [self.lstrnotificationtypeid intValue]==6 || [self.lstrnotificationtypeid intValue]==11)
    {
        NSString*nibNameBundle=nil;
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"ActivityEventViewController_iphone5";
        }//END if([SoclivityUtilities deviceType] & iPhone5)
        else{
            nibNameBundle=@"ActivityEventViewController";
        }//END Else Statement
        
        ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
        activityEventViewController.activityInfo=response;
        
        [[self navigationController] pushViewController:activityEventViewController animated:YES];
        [activityEventViewController release];
    }//END Else Statement
    
    else{
        
        NSString*nibNameBundle=nil;
            
        if([SoclivityUtilities deviceType] & iPhone5){
                nibNameBundle=@"ActivityEventViewController_iphone5";
            }//END if([SoclivityUtilities deviceType] & iPhone5)
        else{
                nibNameBundle=@"ActivityEventViewController";
            }//END Else Statement
            
        ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
        activityEventViewController.activityInfo=response;
            
        [[self navigationController] pushViewController:activityEventViewController animated:YES];
        [activityEventViewController release];
    }//END Else Statement
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void)ActivitiesInvocationDidFinish:(GetActivitiesInvocation*)invocation
                        withResponse:(NSArray*)responses
                           withError:(NSError*)error{
    //now time to write in the Sqlite DataBase(Delete and Clean the activities Table)
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    self.responsedata=[[NSMutableData alloc] init];
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation];
        [self GetNotifications];
    }//END if([SoclivityUtilities hasNetworkConnection])
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }//END Else Statement
    
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self BadgeNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (BadgeNotification) name:@"WaitingOnYou_Count" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (navigate:) name:@"NavigationViews" object:nil];
    
    self.view.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
    notificationImageView.hidden=YES;
    socFadedImageView.hidden=YES;
    
    waitingOnYouLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    waitingOnYouLabel.textColor=[UIColor whiteColor];
    waitingOnYouLabel.backgroundColor=[UIColor clearColor];
    waitingOnYouLabel.shadowColor = [UIColor blackColor];
    waitingOnYouLabel.shadowOffset = CGSizeMake(0,-1);
}

/*-(NSMutableArray*) SetUpDummyNotifications{
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
    }//END for (NSDictionary *playDictionary in playDictionariesArray)
    
    return content;
    
}*/

-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
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
