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
@synthesize delegate,socEventMapView,activityTableView;
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
    gradient=0.94;
    CGFloat xOffset = 0;
    
#if 1   
    NSLog(@"offset=%f",xOffset);
    pullDownView = [[StyledPullableView alloc] initWithFrame:CGRectMake(xOffset, 0, 320, 460)];
    pullDownView.openedCenter = CGPointMake(160 + xOffset,130);
    pullDownView.closedCenter = CGPointMake(160 + xOffset, -172);//-200
    pullDownView.center = pullDownView.closedCenter;
    
    
    //kanav handle layout
    
    pullDownView.handleView.frame = CGRectMake(5, 402, 58, 58);
    pullDownView.delegate = self;
    
    
    
#endif 

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
    
    [self.view insertSubview:pullDownView aboveSubview:topNavBarView];
    
    [self.view insertSubview:pullDownView aboveSubview:socEventMapView];
    [self.view insertSubview:pullDownView aboveSubview:activityTableView];

    
//    [self.view addSubview:pullDownView];
//    [pullDownView release];

    
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
    
    // Do any additional setup after loading the view from its nib.
}
-(void)timeToScrollDown{
    SettingsViewController *settingsViewController=[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
	[[self navigationController] pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
}
#if 0 
-(void)navSingleTap{
   
    NSLog(@"navSingleTap");
        if(!searchBarActivated){
            [self ShowSearchBar];
            searchBarActivated=YES;
        }
        else{
            searchBarActivated=NO;
            [self HideSearchBar];
        }

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
#endif    

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
#pragma mark PullDownView

-(void)doTheTurn:(Boolean)open{
    
    if(open){
        self.view.alpha = 1.0;
        [UIView animateWithDuration: 0.5
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             //handleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             self.view.alpha = 0.4;
                             self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        
    }
    else{
        self.view.alpha = 0.4;
        [UIView animateWithDuration: 0.5
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             //handleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             self.view.alpha = 1.0;
                             self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

-(void)alphaLess{
    gradient=gradient-0.003;
    self.view.alpha =gradient;
}
-(void)alphaMore{
    gradient=gradient+0.003;
    self.view.alpha = gradient;
}

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened {
    if (opened) {
        NSLog(@"Now I'm open!");
        
    } else {
        NSLog(@"Now I'm closed, pull me up again!");
    }
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
