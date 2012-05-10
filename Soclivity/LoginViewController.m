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
