//
//  UpComingCompletedEventsViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpComingCompletedEventsViewController.h"


@implementation UpComingCompletedEventsViewController
@synthesize delegate;
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
    activititesLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    activititesLabel.textColor=[UIColor whiteColor];
    activititesLabel.backgroundColor=[UIColor clearColor];
    activititesLabel.shadowColor = [UIColor blackColor];
    activititesLabel.shadowOffset = CGSizeMake(0,-1);

        // Do any additional setup after loading the view from its nib.
}

-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
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
