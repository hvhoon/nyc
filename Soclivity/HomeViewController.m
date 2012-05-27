//
//  HomeViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "SoclivityUtilities.h"
#import "SettingsViewController.h"
@implementation HomeViewController
@synthesize homeSearchBar;
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
    self.homeSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0)] autorelease];
	self.homeSearchBar.delegate = self;
	self.homeSearchBar.showsCancelButton = NO;
	self.homeSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.homeSearchBar.placeholder=@"Search for 'Tennis'";
	
    //[[[mySearchBar subviews] objectAtIndex:0] setAlpha:0.0];
    //we can still add a tint color so as the search bar buttons match our new background
	self.homeSearchBar.tintColor = [SoclivityUtilities returnTextFontColor:1];
	
	UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.homeSearchBar.frame.size.height-1,self.homeSearchBar.frame.size.width, 1)];
    [bottomBorder setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"Background_Search.png"]]];
    [bottomBorder setOpaque:YES];
    [bottomBorder setTag:123];
    [self.homeSearchBar addSubview:bottomBorder];
    [bottomBorder release];
    //self.homeSearchBar.hidden=YES;
    // note: here you can also change its "tintColor" property to a different UIColor
    [self.view addSubview:self.homeSearchBar];
    
    self.homeSearchBar.frame=CGRectMake(0, -44, 320, 44.0f);
    
#if 0    
    UIButton *scrollUpDownButton=[UIButton buttonWithType:UIButtonTypeCustom];
    scrollUpDownButton.frame=CGRectMake(276,122,29,30);
    [scrollUpDownButton setBackgroundImage:[UIImage imageNamed:@"S02_downarrow.png"] forState:UIControlStateNormal];
    [scrollUpDownButton addTarget:self action:@selector(timeToScrollDown) forControlEvents:UIControlEventTouchUpInside];
    scrollUpDownButton.tag=236;
    [self.view addSubview:scrollUpDownButton];
#endif
    // Do any additional setup after loading the view from its nib.
}
-(void)timeToScrollDown{
    SettingsViewController *settingsViewController=[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
	[[self navigationController] pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
}
-(void)HideSearchBar{
    NSLog(@"CheckingTap");
    CGRect searchTopFrame = self.homeSearchBar.frame;
    searchTopFrame.origin.y = -searchTopFrame.size.height;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.homeSearchBar.frame=CGRectMake(0, -44, 320, 44.0f);
    [UIView commitAnimations];
}
      
-(void)ShowSearchBar{
    
    
    CGRect searchTopFrame = self.homeSearchBar.frame;
    searchTopFrame.origin.y = +searchTopFrame.size.height;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    //[UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.homeSearchBar.frame=CGRectMake(0, 0, 320, 44.0f);
    [UIView commitAnimations];
}
        
#pragma mark -
#pragma mark UISearchBarDelegate


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
    
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.homeSearchBar resignFirstResponder];
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
