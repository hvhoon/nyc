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
@interface ProfileViewController(Private) <MBProgressHUDDelegate,RegistrationDetailDelegate>
@end

@implementation ProfileViewController
@synthesize delegate,activityTypesView,isFirstTime,btnnotify;
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
    [SoclivityUtilities returnNotificationButtonWithCountUpdate:self.btnnotify];
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
    self.btnnotify.hidden=FALSE;

    activityTypesView.delegate=self;
    
    if(isFirstTime){
        getStartedButton.hidden=YES;
        profileButton.hidden=YES;
        updateActivityLabel.text=@"Pick stuff you like to do...";
        activityTypesView.isRegisteration=TRUE;
        self.btnnotify.hidden=TRUE;
    }
    else{
        
        [self BadgeNotification];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (BadgeNotification) name:@"WaitingOnYou_Count" object:nil];

        activityTypesView.isRegisteration=FALSE;
        getStartedButton.hidden=YES;
        profileButton.hidden=NO;
        updateActivityLabel.text=@"Update Activity Types";
        [activityTypesView updateActivityTypes];
    }//END Else Statement

    // Do any additional setup after loading the view from its nib.
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
        [devServer registrationDetailInvocation:self isFBuser:NO isActivityUpdate:YES];
        
        
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
        [devServer registrationDetailInvocation:self isFBuser:YES isActivityUpdate:NO];
        
        
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
    
    
    if(andUpdateType){
    NSLog(@"Activity Types Updated");        
    }
    else{
        
    
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
        
    }
    return;
    
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
    SlidingDrawerViewController *slideViewController = [[SlidingDrawerViewController alloc] initWithNibName:@"SlideViewController" bundle:nil];
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
