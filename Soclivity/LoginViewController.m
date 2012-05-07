//
//  LoginViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "ResetPasswordViewController.h"
@implementation LoginViewController
@synthesize emailAddress,password,checkboxBtn;
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
    
}
-(IBAction)resetPassword:(id)sender{
    
    ResetPasswordViewController *resetPasswordViewController=[[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    
    UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:resetPasswordViewController];
	
    
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
    [resetPasswordViewController release];
    [addNavigationController release];


}
-(IBAction)checkBoxClicked:(id)sender{
    checkBoxStatus=!checkBoxStatus;
    if(checkBoxStatus){
        [checkboxBtn setImage:[UIImage imageNamed:@"S01.1_tick.png"] forState:UIControlStateNormal];
    }
    else{
        [checkboxBtn setImage:nil forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    checkBoxStatus=FALSE;
    [checkboxBtn setImage:nil forState:UIControlStateNormal];
    
    [emailAddress becomeFirstResponder];

    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	
    //[textField resignFirstResponder];
    return NO;
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
