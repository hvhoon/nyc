//
//  LoginViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "ResetPasswordViewController.h"
#import "SoclivityUtilities.h"

#define kUsernameMissing 0
#define kPasswordMissing 1

@implementation LoginViewController
@synthesize emailAddress,password,backgroundState;
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
- (void)drawRect:(CGRect)rect
{
    // Customized fonts
    emailAddress.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    password.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
}


#pragma mark - View lifecycle
-(IBAction)signUpButtonClicked:(id)sender{
    
    NSLog(@"Sign-up botton clicked");
    
    // Form field validation
    if(![SoclivityUtilities validEmail:emailAddress.text]){
        
        // Setup an alert for the missing email address
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email Address"
                                                        message:@"Please enter a valid email address to login."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kUsernameMissing;
        [alert show];
        [alert release];
        return;
    }
    else if([password.text isEqualToString:@""]){
        
        // Setup an alert for missing password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Password"
                                                        message:@"Nice try, but we really need your password to log you in."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kPasswordMissing;
        [alert show];
        [alert release];
        return;

    }
    else
    {
        // Send the login request
        NSLog(@"Attempting to login...");
    }
    
}
-(IBAction)resetPassword:(id)sender{
    
    ResetPasswordViewController *resetPasswordViewController=[[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    
    UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:resetPasswordViewController];
	
    
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
    [resetPasswordViewController release];
    [addNavigationController release];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    UIImage *bgImage=nil;
    switch (backgroundState) {
        case 0:
        {
            bgImage=[UIImage imageNamed:@"green_play.png"];
        }
            break;
        case 1:
        {
            bgImage=[UIImage imageNamed:@"orange_eat.png"];
            
        }
            break;
        case 2:
        {
            bgImage=[UIImage imageNamed:@"purple_see.png"];
            
        }
            break;
        case 3:
        {
            bgImage=[UIImage imageNamed:@"red_create.png"];
            
        }
            break;
        case 4:
        {
            bgImage=[UIImage imageNamed:@"aqua_learn.png"];
            
        }
            break;
            
            
    }
    backgroundView.image=bgImage; 
    [self.view insertSubview:backgroundView atIndex:0];
    [emailAddress becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField ==emailAddress ) {
        [password becomeFirstResponder];
		
    } 
	else if(textField==password){
		//[password resignFirstResponder];
		[self signUpButtonClicked:nil];
		
	}
	
	
    return NO;
}
-(IBAction)BackButtonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView resignFirstResponder];
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kUsernameMissing:
                [emailAddress becomeFirstResponder];
                break;
            case kPasswordMissing:
                [password becomeFirstResponder];
                break;
            default:
                break;
        }
    }
    else
        NSLog(@"Clicked Cancel Button");
}

@end
