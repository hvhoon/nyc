//
//  ResetPasswordViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordViewController.h"

@implementation ResetPasswordViewController

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
    newPassword.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    confirmPassword.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [newPassword becomeFirstResponder];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"S01.2_cross.png"] forState:UIControlStateNormal];
	button.bounds = CGRectMake(0,0,button.imageView.image.size.width, 29);
	[button addTarget:self action:@selector(CrossClicked:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [barButtonItem release];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"S01.2_tick.png"] forState:UIControlStateNormal];
	button.bounds = CGRectMake(0,0,button.imageView.image.size.width, 29);
	[button addTarget:self action:@selector(TickClicked:) forControlEvents:UIControlEventTouchUpInside];
	barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
	self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];

    UIImageView*passwordReset=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S01.2_passwordreset.png"]];
    self.navigationItem.titleView=passwordReset;
    [passwordReset release]; 

    // Do any additional setup after loading the view from its nib.
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
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //[textField resignFirstResponder];
    if(textField ==newPassword) {
        [confirmPassword becomeFirstResponder];
		
    } 
	else if(textField==confirmPassword){
		//[confirmPassword resignFirstResponder];
		[self.navigationController dismissModalViewControllerAnimated:YES];
		
	}
	
	
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
