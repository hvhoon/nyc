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
#import "GetUsersByFirstLastNameInvocation.h"
#import "NotificationClass.h"
#import "DetailedActivityInfoInvocation.h"
@interface InvitesViewController(Private) <MBProgressHUDDelegate,PostActivityRequestInvocationDelegate,GetActivityInvitesInvocationDelegate,GetUsersByFirstLastNameInvocationDelegate,DetailedActivityInfoInvocationDelegate>
@end

@implementation InvitesViewController
@synthesize delegate,settingsButton,activityBackButton,inviteTitleLabel,openSlotsNoLabel,activityName,num_of_slots,inviteFriends,activityInvites,inviteArray,activityId,notIdObject;

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




        if(!inviteFriends){
            btnnotify.hidden=NO;
        [self.view bringSubviewToFront:btnnotify];
            [self UpdateBadgeNotification];
            

        }

    [activityInvites closeAnimation];
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
    
    inviteTitleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    inviteTitleLabel.textColor=[UIColor whiteColor];
    inviteTitleLabel.backgroundColor=[UIColor clearColor];
    inviteTitleLabel.shadowColor = [UIColor blackColor];
    inviteTitleLabel.shadowOffset = CGSizeMake(0,-1);


    
    if(inviteFriends){
    btnnotify.hidden=YES;
    settingsButton.hidden=YES;
    activityBackButton.hidden=NO;
    inviteTitleLabel.text=[NSString stringWithFormat:@"%@",activityName];
    

    openSlotsNoLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    openSlotsNoLabel.textColor=[UIColor whiteColor];
    openSlotsNoLabel.backgroundColor=[UIColor clearColor];
    openSlotsNoLabel.shadowColor=[UIColor blackColor];
    openSlotsNoLabel.shadowOffset=CGSizeMake(0,-1);
    if(num_of_slots!=-1)
    openSlotsNoLabel.text=[NSString stringWithFormat:@"%d Open Slots",num_of_slots];

    CGRect activityRect;
        if([SoclivityUtilities deviceType] & iPhone5)
             activityRect=CGRectMake(0, 44, 320, 377+88);
        else
             activityRect=CGRectMake(0, 44, 320, 357);  //377
        
        activityInvites=[[ActivityInvitesView alloc]initWithFrame:activityRect andInviteListArray:inviteArray isActivityUserList:YES];
    activityInvites.delegate=self;
    [self.view addSubview:activityInvites];
}
    else{
        
        inviteTitleLabel.text=@"Invites";
        if([SoclivityUtilities hasNetworkConnection]){
            
            [self startAnimation:3];
            [devServer getActivityPlayerInvitesInvocation:[SOC.loggedInUser.idSoc intValue] actId:0 inviteeListType:3 abContacts:@"" delegate:self];
        }
        
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            [alert release];
            return;
        }

    }
   // Do any additional setup after loading the view from its nib.
}

-(void)didReceiveBackgroundNotification:(NSNotification*)object{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:object];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 58) andNotif:notifObject];
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
                             withResponse:(NSArray*)responses type:(NSInteger)type
                                withError:(NSError*)error{
    switch (type) {
        case 2:
        {
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
            break;
            
        case 3:
        {
            [HUD hide:YES];
            CGRect activityRect;
            if([SoclivityUtilities deviceType] & iPhone5)
                activityRect=CGRectMake(0, 44, 320, 377+88);
            
            else
                activityRect=CGRectMake(0, 44, 320, 357);  //377
            activityInvites=[[ActivityInvitesView alloc]initWithFrame:activityRect andInviteListArray:responses isActivityUserList:NO];
            activityInvites.delegate=self;
            [self.view addSubview:activityInvites];
            [self.view bringSubviewToFront:btnnotify];

        }
            break;
    }
    

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

-(void)sendInviteOnFacebookPrivateMessage:(int)fbUId{
 
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:0];
        [devServer postActivityRequestInvocation:12 playerId:fbUId actId:activityId delegate:self];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }

}

-(void)askUserToJoinSoclivityOnFacebook:(NSInteger)facebookId{
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:0];
        [devServer postActivityRequestInvocation:16 playerId:facebookId actId:0 delegate:self];
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
        case 1:
        case 0:
        {
            HUD.labelText = @"Inviting...";
            
        }
            break;
            
        case 2:
        {
            HUD.labelText = @"Searching...";
            
        }
            break;
            
        case 3:
        {
            HUD.labelText = @"Loading...";
            
        }
            break;


            
        default:
            break;
    }
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)searchSoclivityPlayers:(NSString*)searchText{
    if([SoclivityUtilities hasNetworkConnection]){
        
            if(inviteFriends)
        [devServer searchUsersByNameInvocation:[SOC.loggedInUser.idSoc intValue] searchText:searchText actId:activityId searchType:1 delegate:self];
            else{
                [devServer searchUsersByNameInvocation:[SOC.loggedInUser.idSoc intValue] searchText:searchText actId:0 searchType:2 delegate:self];
                
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

-(void)SearchUsersInvocationDidFinish:(GetUsersByFirstLastNameInvocation*)invocation
                         withResponse:(NSArray*)responses type:(NSInteger)type
                            withError:(NSError*)error{

        [activityInvites searchPlayersLoad:responses];
        

}

-(void)PostActivityRequestInvocationDidFinish:(PostActivityRequestInvocation*)invocation
                                 withResponse:(BOOL)response relationTypeTag:(NSInteger)relationTypeTag
                                    withError:(NSError*)error{
    
    

    
    switch (relationTypeTag) {
        case 11:
        case 12:
        case 16:
        {
            
            if(response){
                
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
    
    if(inviteFriends && num_of_slots!=-1){
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
