//
//  ResetPasswordViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "MainServiceManager.h"
#import "ResetPasswordInvocation.h"
#define kPasswordNot 1
#define kEmptyFields 2

@interface ResetPasswordViewController(private)<ResetPasswordInvocationDelegate>

@end

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
    
//    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
//    navSingleTap.numberOfTapsRequired = 1;
//    [[self.navigationController.navigationBar.subviews objectAtIndex:0] setUserInteractionEnabled:YES];
//    [[self.navigationController.navigationBar.subviews objectAtIndex:0] addGestureRecognizer:navSingleTap];
//    [navSingleTap release];

    // Do any additional setup after loading the view from its nib.
}


-(void)navSingleTap{
    NSLog(@"navSingleTap");
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
    
    NSLog(@"emailAddress=%@",newPassword.text);
    NSLog(@"password=%@",confirmPassword.text);
    
    if(!newPassword.text.length && !confirmPassword.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Fields"
                                                        message:@"Need a newPassword  to reset."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kEmptyFields;
        [alert show];
        [alert release];
        return;
        
    }

    
    
        if([newPassword.text isEqualToString:confirmPassword.text]){
            
        }
        else{
            newPassword.text=@"";
            confirmPassword.text=@"";
            
            UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Passwords do not match"
                                                                    message:@"Try again......slowly."
                                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            
            passwordAlert.tag=kPasswordNot;
            [passwordAlert show];
            [passwordAlert release];
            return;

        }
    
    [devServer postResetAndConfirmNewPasswordInvocation:newPassword.text cPassword:confirmPassword.text  delegate:self];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)ResetPasswordInvocationDidFinish:(ResetPasswordInvocation*)invocation
                           withResponse:(NSArray*)responses
                              withError:(NSError*)error{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView resignFirstResponder];
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kPasswordNot:
            {
                [newPassword becomeFirstResponder];
            }
                break;
            case kEmptyFields:
            {
                [newPassword becomeFirstResponder];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField ==newPassword) {
        [confirmPassword becomeFirstResponder];
		
    } 
	else if(textField==confirmPassword){
		[self.navigationController dismissModalViewControllerAnimated:YES];
		
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
            default:
                break;
        }
    }
    else
        NSLog(@"Clicked Cancel Button");
}


@end
