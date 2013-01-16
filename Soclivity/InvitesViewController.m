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
@synthesize delegate,settingsButton,activityBackButton,inviteTitleLabel,openSlotsNoLabel,activityName,num_of_slots,inviteFriends,activityInvites,inviteArray,activityId,btnnotify;

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
    
     self.btnnotify.alpha=1;
     [self.view bringSubviewToFront:self.btnnotify];
    
    [activityInvites closeAnimation];
}

-(void)UpdateBadgeNotification
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
            
        }//END if ([[NSString stringWithFormat:@"%i",[[[
        
        else{
            [self.btnnotify setBackgroundImage:[UIImage imageNamed:@"notifyDigit2.png"] forState:UIControlStateNormal];
            self.btnnotify.frame = CGRectMake(self.btnnotify.frame.origin.x,self.btnnotify.frame.origin.y,33,28);
        }//END Else Statement
        
        self.btnnotify.alpha=1;
        [self.btnnotify setTitle:[NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue]] forState:UIControlStateNormal];
        [self.btnnotify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }//END Else Statement
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];
    
    [self UpdateBadgeNotification];
    
    
    for (UIViewController *vw_contrller in self.navigationController.viewControllers) {
            for (UIView *view in vw_contrller.view.subviews)
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    if (view.tag==1111)
                    {
                        view.alpha=0;
                    }//END if (view.tag==1111)
                }
            }//END for (UIView *view in prevController.view.subviews)
    }//END if ([vw_contrller isKindOfClass:[ActivityEventViewController class]])
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (UpdateBadgeNotification) name:@"WaitingOnYou_Count" object:nil];
    
    if(inviteFriends){
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
    SocPlayerClass *myClass=[[SocPlayerClass alloc]init];
    myClass.playerName=player.userName;
    myClass.DOS=player.DOS;
    myClass.activityId=activityId;
    myClass.latestActivityName=activityName;
    myClass.activityType=1;
    myClass.profilePhotoUrl=player.profilePhotoUrl;
    myClass.distance=0.99;
    SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
    socProfileViewController.playerObject=myClass;
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
