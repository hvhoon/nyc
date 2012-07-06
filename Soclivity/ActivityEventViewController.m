//
//  ActivityEventViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityEventViewController.h"
#import "SoclivityUtilities.h"
#import "InfoActivityClass.h"
@implementation ActivityEventViewController
@synthesize activityInfo;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear in slide View Controller Called");
    
    [self.navigationController.navigationBar setHidden:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    leaveActivityButton.hidden=YES;
    chatButton.hidden=YES;
    eventView.delegate=self;
    [eventView loadViewWithActivityDetails:activityInfo];
     eventView.DOS2_ArrowButton.hidden=YES;
     eventView.locationButton.hidden=YES;

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)addEventActivityPressed:(id)sender{
    
    chatButton.hidden=NO;
    leaveActivityButton.hidden=NO;
    addEventButton.hidden=YES;
    bottomBarImageView.hidden=YES;
    eventView.DOS2_ArrowButton.hidden=NO;
    eventView.locationButton.hidden=NO;
    
}

-(IBAction)leaveEventActivityPressed:(id)sender{
    eventView.locationButton.hidden=YES;
    chatButton.hidden=YES;
    eventView.DOS2_ArrowButton.hidden=YES;
    leaveActivityButton.hidden=YES;
    addEventButton.hidden=NO;
    bottomBarImageView.hidden=NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [super dealloc];
    [eventView release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
