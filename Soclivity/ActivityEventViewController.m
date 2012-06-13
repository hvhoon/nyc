//
//  ActivityEventViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityEventViewController.h"
#import "EventDetailView.h"
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
    
    [self.navigationController.navigationBar setHidden:NO];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *backArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	[backArrow setImage:[UIImage imageNamed:@"S5-back-arrow.png"] forState:UIControlStateNormal];
	backArrow.bounds = CGRectMake(0,0,backArrow.imageView.image.size.width, backArrow.imageView.image.size.height);
	[backArrow addTarget:self action:@selector(backArrowPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backArrow];
    
    
    UIButton *addEvent = [UIButton buttonWithType:UIButtonTypeCustom];
	[addEvent setImage:[UIImage imageNamed:@"S04_addevent.png"] forState:UIControlStateNormal];
	addEvent.bounds = CGRectMake(0,0,addEvent.imageView.image.size.width, addEvent.imageView.image.size.height);
	[addEvent addTarget:self action:@selector(addEventPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addEvent];

    
    self.navigationItem.titleView=nil; 	
	UILabel *label=[SoclivityUtilities TitleLabelAndFontOnNavigationBar];
    NSString *titleString=[NSString stringWithFormat:@"%@",activityInfo.activityName];
	label.text = NSLocalizedString(titleString, @"");
	[label sizeToFit];
	self.navigationItem.titleView = label;


    eventView = [[EventDetailView alloc]initWithFrame:CGRectMake(0,44.0,320,416) info:activityInfo];
    [self.view addSubview:eventView];

    // Do any additional setup after loading the view from its nib.
}
-(void)backArrowPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addEventPressed:(id)sender{
    NSLog(@"addEventPressed");
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
