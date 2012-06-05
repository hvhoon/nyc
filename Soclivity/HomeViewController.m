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
#import "UserContactList.h"
@implementation HomeViewController
@synthesize homeSearchBar,delegate,socEventMapView,activityTableView;
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
    self.view.backgroundColor=[UIColor blackColor];
    [self.navigationController.navigationBar setHidden:YES];
    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    navSingleTap.numberOfTapsRequired = 1;
    [topNavBarView setUserInteractionEnabled:YES];
    [topNavBarView addGestureRecognizer:navSingleTap];
    [navSingleTap release];


    [self.view insertSubview:profileBtn aboveSubview:topNavBarView];

    [self.view insertSubview:profileBtn aboveSubview:socEventMapView];
    [self.view insertSubview:profileBtn aboveSubview:activityTableView];
    
    [activityTableView setHidden:YES];
    [activityTableView LoadTable];
    listFlipBtn.hidden=YES;
    sortDistanceBtn.hidden=YES;
    sortDOSBtn.hidden=YES;
    sortByTimeBtn.hidden=YES;
    refreshBtn.hidden=NO;
    currentLocationBtn.hidden=NO;
    UserContactList *addressBook=[[UserContactList alloc]init];
    [addressBook GetAddressBook];
    self.homeSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 44.0, self.view.bounds.size.width, 44.0)] autorelease];
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
    
    // Do any additional setup after loading the view from its nib.
}
-(void)timeToScrollDown{
    SettingsViewController *settingsViewController=[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
	[[self navigationController] pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
}

-(void)navSingleTap{
#if 0    
    NSLog(@"navSingleTap");
        if(!searchBarActivated){
            [self ShowSearchBar];
            searchBarActivated=YES;
        }
        else{
            searchBarActivated=NO;
            [self HideSearchBar];
        }
#endif    
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
    self.homeSearchBar.frame=CGRectMake(0, 44, 320, 44.0f);
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Sliding Drawer Action


-(IBAction)profileSlidingDrawerTapped:(id)sender{
    [delegate showLeft:sender];
}
#pragma mark -
#pragma mark AddANewActivity Action

-(IBAction)AddANewActivity:(id)sender{
    
}

-(IBAction)FilterBtnClicked:(id)sender{
    
}
#if 0
-(IBAction)FlipToListOrBackToMap:(id)sender{
    
    double delayInSeconds = 0.0;
    
    if(!footerActivated){
        footerActivated=TRUE;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView transitionWithView:staticView duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void) 
         {
             [UIView transitionWithView:staticButtonView duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void) 
              {
              } 
                             completion:^(BOOL finished){
                                 listFlipBtn.hidden=NO;
                                 mapflipBtn.hidden=YES;
                                 refreshBtn.hidden=YES;
                                 currentLocationBtn.hidden=YES;
                                 sortDistanceBtn.hidden=NO;
                                 sortDOSBtn.hidden=NO;
                                 sortByTimeBtn.hidden=NO;

                             }] ;
         } 
                        completion:^(BOOL finished){
                            [activityTableView setHidden:NO];
                            [socEventMapView setHidden:YES];
                        }] ;
    });
        
    }
    else {
        footerActivated=FALSE;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView transitionWithView:staticView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(void) 
             {
                 [UIView transitionWithView:staticButtonView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(void) 
                  {
                  } 
                                 completion:^(BOOL finished){
                                     listFlipBtn.hidden=YES;
                                     mapflipBtn.hidden=NO;
                                     sortDistanceBtn.hidden=YES;
                                     sortDOSBtn.hidden=YES;
                                     sortByTimeBtn.hidden=YES;
                                     refreshBtn.hidden=NO;
                                     currentLocationBtn.hidden=NO;

                                     
                                 }] ;
             } 
                            completion:^(BOOL finished){
                                [activityTableView setHidden:YES];
                                [socEventMapView setHidden:NO];
                            }] ;
        });

    }

}
#else
-(IBAction)FlipToListOrBackToMap:(id)sender{
    
    if(!footerActivated){
        footerActivated=TRUE;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:staticView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    
    [activityTableView setHidden:NO];
    [socEventMapView setHidden:YES];
    [UIView commitAnimations];
    
    
    context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:staticButtonView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    
    listFlipBtn.hidden=NO;
    mapflipBtn.hidden=YES;
    refreshBtn.hidden=YES;
    currentLocationBtn.hidden=YES;

    sortDistanceBtn.hidden=NO;
    sortDOSBtn.hidden=NO;
    sortByTimeBtn.hidden=NO;
    
    [UIView commitAnimations];
    }
    else{
        footerActivated=FALSE;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:staticView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        [activityTableView setHidden:YES];
        [socEventMapView setHidden:NO];
        [UIView commitAnimations];
        
        
        context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:staticButtonView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        listFlipBtn.hidden=YES;
        mapflipBtn.hidden=NO;
        refreshBtn.hidden=NO;
        currentLocationBtn.hidden=NO;

        sortDistanceBtn.hidden=YES;
        sortDOSBtn.hidden=YES;
        sortByTimeBtn.hidden=YES;

        
        [UIView commitAnimations];
    }
    
}
#endif

#pragma mark -
#pragma mark UISearchBarDelegate


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
    
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.homeSearchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Refresh Btn Tapped

-(IBAction)RefreshButtonTapped:(id)sender{
    
}
#pragma mark -
#pragma mark CurrentLocation Btn Tapped

-(IBAction)CurrentLocation:(id)sender{
    [socEventMapView gotoLocation];
}

#pragma mark -
#pragma mark DistanceSortingBtn Clicked


-(IBAction)DistanceSortingClicked:(id)sender{
    
}
#pragma mark -
#pragma mark DOSSortingBtn Clicked

-(IBAction)DOSSortingClicked:(id)sender{
    
}
#pragma mark -
#pragma mark TimeSorting Clicked

-(IBAction)TimeSortingClicked:(id)sender{
    
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
