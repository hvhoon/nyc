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
#define kEmptyFields 1
#define kNoEmail 2
#define kPasswordNot 3

@interface LoginViewController(private)<GetLoginInvocationDelegate,ForgotPasswordInvocationDelegate>

@end

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

#pragma mark - View lifecycle
-(IBAction)signUpButtonClicked:(id)sender{
    
    
    NSLog(@"emailAddress=%@",emailAddress.text);
    NSLog(@"password=%@",password.text);
    
    if(!emailAddress.text.length && !password.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Fields"
                                                        message:@"Need a email and password to login."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kEmptyFields;
        [alert show];
        [alert release];
        return;
        
    }
    
    // Make sure the field is no empty
    if(![emailAddress.text isEqualToString:@""]){
        
        // Make sure it contains an '@' and '.'
        NSString *searchForMe = @"@";
        NSRange rangeCheckAtTheRate = [emailAddress.text rangeOfString : searchForMe];
        
        NSString *searchFor = @".";
        NSRange rangeCheckFullStop = [emailAddress.text rangeOfString : searchFor];
        
        if (rangeCheckAtTheRate.location != NSNotFound && rangeCheckFullStop.location !=NSNotFound){
            
            // Ensure it has enough characters
            NSString * charToCount = @"@";
            NSArray * array = [emailAddress.text componentsSeparatedByString:charToCount];
            NSInteger numberOfChar=[array count];
            
            if(numberOfChar==2)
                validEmail = YES;
        }
    }
    else
        validEmail = NO;

        
    NSInteger length;
    length = [password.text length];
    if (length<6)
        validPassword = NO;
    else
        validPassword = YES;
        
        
    
    // Alert if the email is not valid
    if(!validEmail){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                        message:nil
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNoEmail;
        [alert show];
        [alert release];
        return;
    }
    
    // Alert is the password is not valid
    if(!validPassword){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Security Alert!"
                                                        message:@"Your password should have at least 6 characters."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kPasswordNot;
        [alert show];
        [alert release];
        return;
    }
    
    
   // [devServer getLoginInvocation:self.emailAddress.text Password:self.password.text  delegate:self];
}
-(void)LoginInvocationDidFinish:(GetLoginInvocation*)invocation
                   withResponse:(NSArray*)responses
                      withError:(NSError*)error{
    NSLog(@"Successful Login");
}
#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView resignFirstResponder];
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kNoEmail:
            {
                [emailAddress becomeFirstResponder];
            }
                
                break;
            case kPasswordNot:
            {
                [password becomeFirstResponder];
            }
                break;
            case kEmptyFields:
            {
                [emailAddress becomeFirstResponder];
            }
                break;
            default:
                break;
        }
    }
    else{
        NSLog(@"Clicked Cancel Button");
    }
}
-(IBAction)resetPassword:(id)sender{
    
    //[devServer postForgotPasswordInvocation:emailAddress.text delegate:self];
    
    ResetPasswordViewController *resetPasswordViewController=[[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    
    UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:resetPasswordViewController];
	
    
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
    [resetPasswordViewController release];
    [addNavigationController release];


}
-(void)ForgotPasswordInvocationDelegate:(ForgotPasswordInvocation*)invocation
                           withResponse:(NSArray*)responses
                              withError:(NSError*)error{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    devServer=[[MainServiceManager alloc]init];
    
    emailAddress.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    password.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)dealloc{
    [super dealloc];
}
@end
