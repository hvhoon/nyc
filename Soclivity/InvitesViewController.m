//
//  InvitesViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InvitesViewController.h"
#import "SoclivityUtilities.h"
#import "MainServiceManager.h"
#import "MBProgressHUD.h"
#import "PostActivityRequestInvocation.h"
#import "SOCProfileViewController.h"
#import "SocPlayerClass.h"
#import "InviteObjectClass.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "GetActivityInvitesInvocation.h"
#import "ActivityEventViewController.h"
@interface InvitesViewController(Private) <MBProgressHUDDelegate,PostActivityRequestInvocationDelegate,GetActivityInvitesInvocationDelegate>
@end

@implementation InvitesViewController
@synthesize delegate,settingsButton,activityBackButton,inviteTitleLabel,openSlotsNoLabel,activityName,num_of_slots,inviteFriends,activityInvites,inviteArray,activityId;

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (showInAppNotificationsUsingRocketSocket:) name:@"WaitingonyouNotification" object:nil];

        if(!inviteFriends){
            btnnotify.hidden=NO;
     [self.view bringSubviewToFront:btnnotify];
            [self UpdateBadgeNotification];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (UpdateBadgeNotification) name:@"WaitingOnYou_Count" object:nil];

        }

    [activityInvites closeAnimation];
}


-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WaitingonyouNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WaitingOnYou_Count" object:nil];
    
}


-(void)UpdateBadgeNotification
{
    [SoclivityUtilities returnNotificationButtonWithCountUpdate:btnnotify];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];
    
    

    
    if(inviteFriends){
    btnnotify.hidden=YES;
    settingsButton.hidden=YES;
    activityBackButton.hidden=NO;
    inviteTitleLabel.text=[NSString stringWithFormat:@"%@",activityName];
    
    inviteTitleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    inviteTitleLabel.textColor=[UIColor whiteColor];
    inviteTitleLabel.backgroundColor=[UIColor clearColor];
    inviteTitleLabel.shadowColor = [UIColor blackColor];
    inviteTitleLabel.shadowOffset = CGSizeMake(0,-1);

    openSlotsNoLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    openSlotsNoLabel.textColor=[UIColor whiteColor];
    openSlotsNoLabel.backgroundColor=[UIColor clearColor];
    openSlotsNoLabel.shadowColor=[UIColor blackColor];
    openSlotsNoLabel.shadowOffset=CGSizeMake(0,-1);
    if(num_of_slots!=-1)
    openSlotsNoLabel.text=[NSString stringWithFormat:@"%d Open Slots",num_of_slots];

}
    
    CGRect activityRect;
            if([SoclivityUtilities deviceType] & iPhone5)
    activityRect=CGRectMake(0, 44, 320, 377+88);
            
    else
        activityRect=CGRectMake(0, 44, 320, 357);  //377
    activityInvites=[[ActivityInvitesView alloc]initWithFrame:activityRect andInviteListArray:inviteArray];
    activityInvites.delegate=self;
    [self.view addSubview:activityInvites];
   // Do any additional setup after loading the view from its nib.
}

-(void)showInAppNotificationsUsingRocketSocket:(NSNotification*)object{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:object];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 58) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
}

-(void)backgroundTapToPush:(NotificationClass*)notification{
    
}


-(void)addressBookHelperError{
    
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:nil
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    return;
    
    
}
-(void)addressBookHelperDeniedAcess{
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Denied Access" message:nil
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    return;
    
    
}
-(void)AddressBookSuccessful:(NSString*)response{
    
    NSLog(@"response=%@",response);
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        
        [devServer getActivityPlayerInvitesInvocation:[SOC.loggedInUser.idSoc intValue] actId:activityId inviteeListType:2 abContacts:response delegate:self];
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
        nibNameBundle=@"ContactsListViewController_iphone5";
    }
    else{
        nibNameBundle=@"ContactsListViewController";
    }
    
    
    ContactsListViewController *contactsListViewController=[[ContactsListViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    contactsListViewController.activityName=[NSString stringWithFormat:@"%@",activityName];
    contactsListViewController.contactsListContentArray=responses;
    contactsListViewController.num_of_slots=num_of_slots;
    contactsListViewController.inviteFriends=inviteFriends;
    contactsListViewController.delegate=self;
    contactsListViewController.activityId=activityId;
	[[self navigationController] pushViewController:contactsListViewController animated:YES];
    [contactsListViewController release];
    
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];

}
- (void)pushContactsInvitesScreen{
    
    
    UserContactList *addressBook=[[UserContactList alloc]init];
    addressBook.delegate=self;
    [addressBook loadContacts];
}

-(BOOL)CalculateOpenSlots{
    
    if(num_of_slots==-1 || num_of_slots>0){
        return YES;
    }
    else
      return NO;
}

-(void)inviteSoclivityUser:(int)invitePlayerId{
    
if([SoclivityUtilities hasNetworkConnection]){
                [self startAnimation:0];
    [devServer postActivityRequestInvocation:11  playerId:invitePlayerId actId:activityId delegate:self];
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
    HUD.labelText = @"Inviting";
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)PostActivityRequestInvocationDidFinish:(PostActivityRequestInvocation*)invocation
                                 withResponse:(BOOL)response relationTypeTag:(NSInteger)relationTypeTag
                                    withError:(NSError*)error{
    
    

    
    switch (relationTypeTag) {
        case 11:
        {
            
            if(inviteFriends && response){
                
                HUD.labelText = @"Invited";
                
                [self performSelector:@selector(hideMBProgress) withObject:nil afterDelay:1.0];

            }
            else{
                
                    [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error inviting user" message:nil
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [alert show];
                [alert release];
                return;

            }

            
        }
            break;
            
        default:
            break;
    }
}

-(void)hideMBProgress{
    [HUD hide:YES];
    
    if(num_of_slots!=-1){
    num_of_slots--;
    openSlotsNoLabel.text=[NSString stringWithFormat:@"%d Open Slots",num_of_slots];
    }
    [activityInvites activityInviteStatusUpdate];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)PushUserToProfileScreen:(InviteObjectClass*)player{
    SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
    socProfileViewController.friendId=player.inviteId;
    [[self navigationController] pushViewController:socProfileViewController animated:YES];
    [socProfileViewController release];

}
-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
}
-(IBAction)popBackToActivityScreen:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
