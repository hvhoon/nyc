//
//  InvitesViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InvitesViewController.h"
#import "SoclivityUtilities.h"
@implementation InvitesViewController
@synthesize delegate,settingsButton,activityBackButton,inviteTitleLabel,openSlotsNoLabel,activityName,num_of_slots,inviteFriends;
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
    
    [activityInvites closeAnimation];
    

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    openSlotsNoLabel.text=[NSString stringWithFormat:@"%d Open Slots",num_of_slots];

}
    activityInvites=[[ActivityInvitesView alloc]initWithFrame:CGRectMake(0, 43, 320, 377)];
    activityInvites.delegate=self;
    [self.view addSubview:activityInvites];
    
   // Do any additional setup after loading the view from its nib.
}
- (void)pushContactsInvitesScreen{
 
    ContactsListViewController *contactsListViewController=[[ContactsListViewController alloc] initWithNibName:@"ContactsListViewController" bundle:nil];
    contactsListViewController.activityName=[NSString stringWithFormat:@"%@",activityName];
    contactsListViewController.num_of_slots=num_of_slots;
    contactsListViewController.inviteFriends=inviteFriends;
    contactsListViewController.delegate=self;
	[[self navigationController] pushViewController:contactsListViewController animated:YES];
    [contactsListViewController release];
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void)OpenSlotsUpdate:(BOOL)increment{
    
    if(inviteFriends){
    if(increment){
        num_of_slots++;   
    }
    else{
        num_of_slots--;
    }
        openSlotsNoLabel.text=[NSString stringWithFormat:@"%d Open Slots",num_of_slots];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
