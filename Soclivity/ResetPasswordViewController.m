//
//  ResetPasswordViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SoclivityUtilities.h"
#import "MainServiceManager.h"
#import "ResetPasswordInvocation.h"
#import "GetPlayersClass.h"
#define kNewPasswordNot 0
#define kPasswordResetEmail 1
#define kResetFail 2
@interface ResetPasswordViewController(private)<ResetPasswordInvocationDelegate>

@end

@implementation ResetPasswordViewController
@synthesize idSoc,oldPassword,backgroundState;
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
    newPassword.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    confirmPassword.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];

    devServer=[[MainServiceManager alloc]init];
    [newPassword becomeFirstResponder];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"S02_cross_emb.png"] forState:UIControlStateNormal];
	button.bounds = CGRectMake(0,0,19,18);
	[button addTarget:self action:@selector(CrossClicked:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [barButtonItem release];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"S02_tick_emb.png"] forState:UIControlStateNormal];
	button.bounds = CGRectMake(0,0,19,18);
	[button addTarget:self action:@selector(TickClicked:) forControlEvents:UIControlEventTouchUpInside];
	barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
	self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];

    UIImageView*passwordReset=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S01.2_passwordreset.png"]];
    self.navigationItem.titleView=passwordReset;
    [passwordReset release];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)CrossClicked:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)TickClicked:(id)sender{
    
    // Check to see if the password is even valid
    if(![SoclivityUtilities validPassword:newPassword.text]){
        
        // If the password is invalid, please clear both fields
        newPassword.text = @"";
        confirmPassword.text = @"";
        
        // Setup an alert for the invalid password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Security Alert!"
                                                        message:@"Your password should have at least 6 characters."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNewPasswordNot;
        [alert show];
        [alert release];
        return;

    }
    // Check to see the passwords match
    else if(![confirmPassword.text isEqualToString:newPassword.text]){
        
        // if the passwords don't match, first clear the fields
        newPassword.text = @"";
        confirmPassword.text = @"";
        
        // Setup an alert for passwords that don't match
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords do not match"
                                                                message:@"Please try again!"
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNewPasswordNot;
        [alert show];
        [alert release];
        return;
    }

    
    else{
       
        [devServer postResetAndConfirmNewPasswordInvocation:newPassword.text cPassword:confirmPassword.text andUserId:idSoc  tempPassword:oldPassword delegate:self];
    
    }
}

-(void)ResetPasswordInvocationDidFinish:(ResetPasswordInvocation*)invocation
                           withResponse:(NSString*)responses
                              withError:(NSError*)error{
    
    
    
    //GetPlayersClass *obj=[responses objectAtIndex:0];
    //NSLog(@"obj.password_status=%@",obj.statusMessage);
    
    if([responses isEqualToString:@"failed"]){
        newPassword.text=@"";
        confirmPassword.text=@"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed."
                                                        message:@"Something is wrong,please confirm your password again"
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kResetFail;
        [alert show];
        [alert release];
        return;

}
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful Reset"
                                                        message:@"Welcome to Soclivity!"
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kPasswordResetEmail;
        [alert show];
        [alert release];
        return;
        
        
    }
}    


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField ==newPassword) {
        [confirmPassword becomeFirstResponder];
		
    } 
	else if(textField==confirmPassword){
		[self TickClicked:nil];
		
	}
	
	
    return NO;
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
            case kNewPasswordNot:
                [newPassword becomeFirstResponder];
                break;
                
            case kPasswordResetEmail:
             [self.navigationController dismissModalViewControllerAnimated:YES];
                break;
                
            case kResetFail:
                [newPassword becomeFirstResponder];
                break;
            default:
                break;
        }
    }
    else
        NSLog(@"Clicked Cancel Button");
}


@end
