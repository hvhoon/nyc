//
//  SettingsViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "HomeViewController.h"
#import "UpComingCompletedEventsViewController.h"
#import "DDMenuController.h"
#import "WelcomeScreenViewController.h"

@implementation SettingsViewController
@synthesize isFBlogged;
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
    
    UIButton *logoutButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutButton.frame=CGRectMake(10,50,160,32);
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutFromTheApp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];

    
    // Do any additional setup after loading the view from its nib.
}
-(void)logoutFromTheApp{
    if(isFBlogged){
        [self FBlogout];
    }
    
    WelcomeScreenViewController *welcomeScreenViewController=[[WelcomeScreenViewController alloc] initWithNibName:@"WelcomeScreenViewController" bundle:nil];
	[[self navigationController] pushViewController:welcomeScreenViewController animated:YES];
    [welcomeScreenViewController release];

}
    
- (void)FBlogout {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout];
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
