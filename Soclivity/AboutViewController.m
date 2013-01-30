//
//  AboutViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "SoclivityUtilities.h"
#import "JMC.h"

@implementation AboutViewController
@synthesize delegate, buildText;
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
    
    // Color background
    self.view.backgroundColor = [SoclivityUtilities returnBackgroundColor:0];
    
    // Build text
    buildText.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    buildText.textColor = [SoclivityUtilities returnTextFontColor:5];

    // Submit an issue
    submitBug.titleLabel.text = @"Report an Issue";
    submitBug.titleLabel.textColor = [SoclivityUtilities returnTextFontColor:5];
    submitBug.titleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:17];
    
    // Badge logic
    [self UpdateBadgeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (UpdateBadgeNotification) name:@"WaitingOnYou_Count" object:nil];
    
    
    
}
-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
}

- (void)viewDidUnload
{
    [self setBuildText:nil];
    [self setBuildText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)UpdateBadgeNotification
{
    self.btnnotify.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
    
    int count=[[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue];
    
    if (count==0)
    {
        self.btnnotify.alpha=0;
    }//END if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Wait
    
    else
    {
        if ([[NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue]] length]<2)
        {
            [self.btnnotify setBackgroundImage:[UIImage imageNamed:@"notifyDigit1.png"] forState:UIControlStateNormal];
            self.btnnotify.frame = CGRectMake(self.btnnotify.frame.origin.x,self.btnnotify.frame.origin.y,27,27);
            
        }//END if ([[NSString stringWithFormat:@"%i",[[[
        
        else{
            [self.btnnotify setBackgroundImage:[UIImage imageNamed:@"notifyDigit2.png"] forState:UIControlStateNormal];
            self.btnnotify.frame = CGRectMake(self.btnnotify.frame.origin.x,self.btnnotify.frame.origin.y,33,28);
        }//END Else Statement
        
        self.btnnotify.alpha=1;
        [self.btnnotify setTitle:[NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue]] forState:UIControlStateNormal];
        [self.btnnotify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }//END Else Statement
}

-(IBAction)submitBugPressed:(id)sender {
    [self presentModalViewController:[[JMC sharedInstance] feedbackViewController] animated:YES];
}


- (void)dealloc {
    [buildText release];
    [super dealloc];
}
@end
