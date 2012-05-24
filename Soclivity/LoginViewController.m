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
#import "GetPlayersClass.h"
#import "MainServiceManager.h"
#import "GetLoginInvocation.h"
#import "ForgotPasswordInvocation.h"
#import "AlertPrompt.h"
#import "SFHFKeychainUtils.h"
#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "UpComingEventsViewController.h"
#define kUsernameMissing 0
#define kPasswordMissing 1
#define kALertPrompt 2
#define kLoginSuccess 3
#define kLoginFail 4
#define kPasswordResetEmail 5
@interface LoginViewController(private)<GetLoginInvocationDelegate,ForgotPasswordInvocationDelegate>

@end

@implementation LoginViewController
@synthesize progressGear;
@synthesize rightArrowButton;
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
                                                        message:@"Nice try, but you really need a password to login."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kPasswordMissing;
        [alert show];
        [alert release];
        return;

    }
    else
    {
        // Start the animation
        [progressGear startAnimating];
        [rightArrowButton setHidden:YES];
        
        // Send the login request
        NSLog(@"Attempting to login...");
        [devServer getLoginInvocation:self.emailAddress.text Password:self.password.text  delegate:self];
        
        
        
    }
}
-(void)LoginInvocationDidFinish:(GetLoginInvocation*)invocation
                   withResponse:(NSArray*)responses
                      withError:(NSError*)error{
    
    // Stop animation
    [progressGear stopAnimating];
    [rightArrowButton setHidden:NO];
    
    NSLog(@"Successful Login");
    NSLog(@"RegistrationDetailInvocationDidFinish called");
    GetPlayersClass *obj=[responses objectAtIndex:0];
    NSLog(@"SOC ID=%d",[obj.idSoc intValue]);
    NSLog(@"obj.password_status=%@",obj.password_status);
    
    if(obj.status && [obj.password_status isEqualToString:@"null"]){
        
        if([ SFHFKeychainUtils storeUsername:@"password" andPassword: password.text forServiceName:@"Soclivity" updateExisting:YES error:nil])
            NSLog(@"Password Encrypted");
        
        if([ SFHFKeychainUtils storeUsername:@"emailAddress" andPassword: emailAddress.text forServiceName:@"Soclivity" updateExisting:YES error:nil])
            NSLog(@"EmailAddress Encrypted");

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Successful"
                                                        message:@"Welcome to Soclivity!"
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kLoginSuccess;
        [alert show];
        [alert release];
        return;

    }
    
else if(obj.status && [obj.password_status isEqualToString:@"temp"]){
        
        
        ResetPasswordViewController *resetPasswordViewController=[[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
        resetPasswordViewController.backgroundState=backgroundState;
        resetPasswordViewController.idSoc=[obj.idSoc intValue];
        resetPasswordViewController.oldPassword=password.text;
        UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:resetPasswordViewController];
        
        
        [self.navigationController presentModalViewController:addNavigationController animated:YES];
        [resetPasswordViewController release];
        [addNavigationController release];
        return;
    }
    else{
        // Clear your password
        password.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                    message:@"Incorrect email or password."
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kLoginFail;
        [alert show];
        [alert release];
        return;

    }
    
}

-(IBAction)resetPassword:(id)sender{
    
    prompt = [AlertPrompt alloc];
    prompt.tag=kALertPrompt;
    prompt = [prompt initWithTitle:@"Forgot Password?"
                 message:@"To reset your password, please enter your email address.\n\n\n"
                          delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Reset"];
    [prompt show];
    [prompt release];
    
    
    

}
-(void)ForgotPasswordInvocationDelegate:(ForgotPasswordInvocation*)invocation
                           withResponse:(NSArray*)responses
                              withError:(NSError*)error{
    
    
    GetPlayersClass *obj=[responses objectAtIndex:0];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:obj.statusMessage
                                                    message:nil
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
    [alert release];
    return;


    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    devServer=[[MainServiceManager alloc]init];
    
    emailAddress.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    password.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    
    progressGear.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

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

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField ==emailAddress ) {
        [password becomeFirstResponder];
		
    } 
	else if(textField==password){
		[self signUpButtonClicked:nil];
		
	}
	
	
    return NO;
}
-(IBAction)BackButtonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [self setProgressGear:nil];
    [self setRightArrowButton:nil];
    [self setRightArrowButton:nil];
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
    
    //[alertView resignFirstResponder];
    
    if(alertView.tag==kALertPrompt){
        if (buttonIndex == 0) {
            [emailAddress becomeFirstResponder];
        }
        else{
            //Reset Pressed
            [emailAddress becomeFirstResponder];
            NSString *email=[prompt enteredText];
            if([SoclivityUtilities validEmail:email]){
                [devServer postForgotPasswordInvocation:email delegate:self];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                                message:@"Promise not to send you spam!"
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                alert.tag=kPasswordResetEmail;
                [alert show];
                [alert release];
                return;

            }
        }
    }
    else{
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kUsernameMissing:
                [emailAddress becomeFirstResponder];
                break;
            case kPasswordMissing:
                [password becomeFirstResponder];
                break;
            case kLoginSuccess:
            {
                HomeViewController *homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                
                DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navController];
                
                
                SettingsViewController *leftController = [[SettingsViewController alloc] init];
                rootController.leftViewController = leftController;
                
                UpComingEventsViewController *rightController = [[UpComingEventsViewController alloc] init];
                rootController.rightViewController = rightController;
                
                
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.menuController=rootController;
                [self.navigationController pushViewController:rootController animated:YES];
                //[leftController release];
                //[rightController release];
                //[rootController release];
                //[navController release];

            }
                break;
            case kLoginFail:
                [password becomeFirstResponder];
                break;
            case kPasswordResetEmail:
                [self resetPassword:nil];
                break;

            default:
                break;
        }
    }
    else
        NSLog(@"Clicked Cancel Button");
    }
}

- (void)dealloc {
    [progressGear release];
    [super dealloc];
}
@end
