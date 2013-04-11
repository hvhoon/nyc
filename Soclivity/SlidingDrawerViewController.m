//
//  SlidingDrawerViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlidingDrawerViewController.h"
#import "WelcomeScreenViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "NotificationsViewController.h"
#import "AppDelegate.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "UpComingCompletedEventsViewController.h"
#import "SoclivityUtilities.h"
#import "InvitesViewController.h"
#import "AboutViewController.h"
@implementation SlidingDrawerViewController
@synthesize datasource = _datasource,isFBlogged;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        //creating _searchDatasource for later use!
        _searchDatasource = [NSMutableArray new];
        NSString *nibNameBundle=nil;

        NSMutableArray *datasource = [NSMutableArray array];

        
        NSMutableDictionary *sectionOne = [NSMutableDictionary dictionary];
        [sectionOne setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *profileViewControllerDictionary = [NSMutableDictionary dictionary];
        
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        
        SOC.loggedInUser.fullName=[SoclivityUtilities getFirstAndLastName:SOC.loggedInUser.first_name lastName:SOC.loggedInUser.last_name];

        [profileViewControllerDictionary setObject:SOC.loggedInUser.fullName forKey:kSlideViewControllerViewControllerTitleKey];
        
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"ProfileViewController_iphone5";
        }
        else{
            nibNameBundle=@"ProfileViewController";
        }

        [profileViewControllerDictionary setObject:nibNameBundle forKey:kSlideViewControllerViewControllerNibNameKey];
        
        [profileViewControllerDictionary setObject:@"TRUE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];

        
        NSNumber *profileTag=[NSNumber numberWithInt:1];
        [profileViewControllerDictionary setObject:profileTag forKey:kSlideViewControllerViewControllerTagKey];

        [profileViewControllerDictionary setObject:[ProfileViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        
        SOC.loggedInUser.profileImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:SOC.loggedInUser.profileImageUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:SOC.loggedInUser.profileImageData ] autorelease];
        if(image.size.height != image.size.width)
            image = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 50 || image.size.width > 50)
            image = [SoclivityUtilities compressImage:image size:CGSizeMake(50,50)];
    
        if(SOC.loggedInUser.profileImageData.length!=0)
        [profileViewControllerDictionary setObject:image forKey:kSlideViewControllerViewControllerIconKey];
        
        
        [sectionOne setObject:[NSArray arrayWithObject:profileViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionOne];
        
        
        NSMutableDictionary *sectionTwo = [NSMutableDictionary dictionary];
        [sectionTwo setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *notificationsViewControllerDictionary = [NSMutableDictionary dictionary];
        [notificationsViewControllerDictionary setObject:@"Notifications" forKey:kSlideViewControllerViewControllerTitleKey];
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"NotificationsViewController_iphone5";
        }
        else{
            nibNameBundle=@"NotificationsViewController";
        }

        [notificationsViewControllerDictionary setObject:nibNameBundle forKey:kSlideViewControllerViewControllerNibNameKey];
        
        [notificationsViewControllerDictionary setObject:@"TRUE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];
        
        
        NSNumber *notificationTag=[NSNumber numberWithInt:2];
        [notificationsViewControllerDictionary setObject:notificationTag forKey:kSlideViewControllerViewControllerTagKey];
        
        [notificationsViewControllerDictionary setObject:[NotificationsViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [notificationsViewControllerDictionary setObject:[UIImage imageNamed:@"S7_waiting_icon.png"] forKey:kSlideViewControllerViewControllerIconKey];
        
        
        [sectionTwo setObject:[NSArray arrayWithObject:notificationsViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionTwo];

        
        
        NSMutableDictionary *sectionThree = [NSMutableDictionary dictionary];
        [sectionThree setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *homeViewControllerDictionary = [NSMutableDictionary dictionary];
        [homeViewControllerDictionary setObject:@"Activities Around Me" forKey:kSlideViewControllerViewControllerTitleKey];
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"HomeViewController_iphone5";
        }
        else{
            nibNameBundle=@"HomeViewController";
        }

        [homeViewControllerDictionary setObject:nibNameBundle forKey:kSlideViewControllerViewControllerNibNameKey];
        
        NSNumber *activityTag=[NSNumber numberWithInt:3];
        [homeViewControllerDictionary setObject:activityTag forKey:kSlideViewControllerViewControllerTagKey];
        
        [homeViewControllerDictionary setObject:@"TRUE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];
        
        
        [homeViewControllerDictionary setObject:[HomeViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [homeViewControllerDictionary setObject:[UIImage imageNamed:@"S7_activity_icon.png"] forKey:kSlideViewControllerViewControllerIconKey];
        
        
        [sectionThree setObject:[NSArray arrayWithObject:homeViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionThree];
        
       
        
        
        
        
        
        NSMutableDictionary *sectionFour = [NSMutableDictionary dictionary];
        [sectionFour setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *upcomingCompletedEventsViewControllerDictionary = [NSMutableDictionary dictionary];
        [upcomingCompletedEventsViewControllerDictionary setObject:@"My Activities" forKey:kSlideViewControllerViewControllerTitleKey];
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"UpComingCompletedEventsViewController_iphone5";
        }
        else{
            nibNameBundle=@"UpComingCompletedEventsViewController";
        }

        [upcomingCompletedEventsViewControllerDictionary setObject:nibNameBundle forKey:kSlideViewControllerViewControllerNibNameKey];
        
        NSNumber *upcomingCompletedEventsTag=[NSNumber numberWithInt:4];
        [upcomingCompletedEventsViewControllerDictionary setObject:upcomingCompletedEventsTag forKey:kSlideViewControllerViewControllerTagKey];
        
        [upcomingCompletedEventsViewControllerDictionary setObject:@"TRUE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];

        [upcomingCompletedEventsViewControllerDictionary setObject:[UpComingCompletedEventsViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [upcomingCompletedEventsViewControllerDictionary setObject:[UIImage imageNamed:@"S7_your_activities.png"] forKey:kSlideViewControllerViewControllerIconKey];
        
        
        [sectionFour setObject:[NSArray arrayWithObject:upcomingCompletedEventsViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionFour];
        
        
        
        NSMutableDictionary *sectionFive = [NSMutableDictionary dictionary];
        [sectionFive setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *invitesViewControllerDictionary = [NSMutableDictionary dictionary];
        [invitesViewControllerDictionary setObject:@"Invite People" forKey:kSlideViewControllerViewControllerTitleKey];
        
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"InvitesViewController_iphone5";
        }
        else{
            nibNameBundle=@"InvitesViewController";
        }

        [invitesViewControllerDictionary setObject:nibNameBundle forKey:kSlideViewControllerViewControllerNibNameKey];
        
        NSNumber *invitesTag=[NSNumber numberWithInt:5];
        [invitesViewControllerDictionary setObject:invitesTag forKey:kSlideViewControllerViewControllerTagKey];
        
        [invitesViewControllerDictionary setObject:@"TRUE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];

        [invitesViewControllerDictionary setObject:[InvitesViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [invitesViewControllerDictionary setObject:[UIImage imageNamed:@"S7_invite_icon.png"] forKey:kSlideViewControllerViewControllerIconKey];
        
        
        [sectionFive setObject:[NSArray arrayWithObject:invitesViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionFive];
        
    
        NSMutableDictionary *sectionSix = [NSMutableDictionary dictionary];
        [sectionSix setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *blankNotifyControllerDictionary = [NSMutableDictionary dictionary];
        [blankNotifyControllerDictionary setObject:@" " forKey:kSlideViewControllerViewControllerTitleKey];
        
        NSNumber *blankNotifyTag=[NSNumber numberWithInt:6];
        [blankNotifyControllerDictionary setObject:blankNotifyTag forKey:kSlideViewControllerViewControllerTagKey];
        
        [blankNotifyControllerDictionary setObject:@"FALSE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];
        
        [sectionSix setObject:[NSArray arrayWithObject:blankNotifyControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionSix];

        // Button to the about page
        NSMutableDictionary *sectionTen = [NSMutableDictionary dictionary];
        [sectionTen setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *AboutViewControllerDictionary = [NSMutableDictionary dictionary];
        [AboutViewControllerDictionary setObject:@"Need Help?" forKey:kSlideViewControllerViewControllerTitleKey];
        
        if([SoclivityUtilities deviceType] & iPhone5)
            nibNameBundle=@"AboutViewController_iphone5";
        else
            nibNameBundle=@"AboutViewController";
        
        [AboutViewControllerDictionary setObject:nibNameBundle forKey:kSlideViewControllerViewControllerNibNameKey];
        NSNumber *AboutTag=[NSNumber numberWithInt:10];
        [AboutViewControllerDictionary setObject:AboutTag forKey:kSlideViewControllerViewControllerTagKey];
        [AboutViewControllerDictionary setObject:@"TRUE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];
        [AboutViewControllerDictionary setObject:[AboutViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [AboutViewControllerDictionary setObject:[UIImage imageNamed:@"S07_infoIcon.png"] forKey:kSlideViewControllerViewControllerIconKey];
        [sectionTen setObject:[NSArray arrayWithObject:AboutViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        [datasource addObject:sectionTen];
        
        
        NSMutableDictionary *sectionSeven = [NSMutableDictionary dictionary];
        [sectionSeven setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *calendarSyncControllerDictionary = [NSMutableDictionary dictionary];
        [calendarSyncControllerDictionary setObject:@"Calendar Sync" forKey:kSlideViewControllerViewControllerTitleKey];
        
        NSNumber *calendarSyncTag=[NSNumber numberWithInt:7];
        [calendarSyncControllerDictionary setObject:calendarSyncTag forKey:kSlideViewControllerViewControllerTagKey];
        
        [calendarSyncControllerDictionary setObject:@"FALSE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];

        
        [calendarSyncControllerDictionary setObject:[UIImage imageNamed:@"S7_calendar_icon.png"] forKey:kSlideViewControllerViewControllerIconKey];
        
        
        [sectionSeven setObject:[NSArray arrayWithObject:calendarSyncControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionSeven];
        
        
#if 0
        NSMutableDictionary *sectionEight = [NSMutableDictionary dictionary];
        [sectionEight setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *linkToFacebookControllerDictionary = [NSMutableDictionary dictionary];
        [linkToFacebookControllerDictionary setObject:@"Link to  facebook" forKey:kSlideViewControllerViewControllerTitleKey];
        
        NSNumber *facebookLinkTag=[NSNumber numberWithInt:8];
        [linkToFacebookControllerDictionary setObject:facebookLinkTag forKey:kSlideViewControllerViewControllerTagKey];
        
        [linkToFacebookControllerDictionary setObject:@"FALSE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];
        
        
        [linkToFacebookControllerDictionary setObject:[UIImage imageNamed:@"S7_fb_icon.png"] forKey:kSlideViewControllerViewControllerIconKey];
        
        
        [sectionEight setObject:[NSArray arrayWithObject:linkToFacebookControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionEight];
#endif
        
        // Email switch
        /*
        NSMutableDictionary *sectionEight = [NSMutableDictionary dictionary];
        [sectionEight setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *emailNotifyControllerDictionary = [NSMutableDictionary dictionary];
        [emailNotifyControllerDictionary setObject:@"Email Notifications" forKey:kSlideViewControllerViewControllerTitleKey];
        
        NSNumber *emailNotifyTag=[NSNumber numberWithInt:8];
        [emailNotifyControllerDictionary setObject:emailNotifyTag forKey:kSlideViewControllerViewControllerTagKey];
        
        [emailNotifyControllerDictionary setObject:@"FALSE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];
        
        
        [emailNotifyControllerDictionary setObject:[UIImage imageNamed:@"S7_email_icon.png"] forKey:kSlideViewControllerViewControllerIconKey];
        
        
        [sectionEight setObject:[NSArray arrayWithObject:emailNotifyControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionEight];
         */
         
        NSMutableDictionary *sectionNine = [NSMutableDictionary dictionary];
        [sectionNine setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *settingsViewControllerDictionary = [NSMutableDictionary  dictionary];
        [settingsViewControllerDictionary setObject:@"Signout" forKey:kSlideViewControllerViewControllerTitleKey];
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"WelcomeScreenViewControllerIphone5";
        }
        else{
            nibNameBundle=@"WelcomeScreenViewController";
        }

        [settingsViewControllerDictionary setObject:nibNameBundle forKey:kSlideViewControllerViewControllerNibNameKey];

        [settingsViewControllerDictionary setObject:[WelcomeScreenViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        
        NSNumber *signOutTag=[NSNumber numberWithInt:9];
        [settingsViewControllerDictionary setObject:signOutTag forKey:kSlideViewControllerViewControllerTagKey];
        [settingsViewControllerDictionary setObject:@"TRUE" forKey:kSlideViewControllerViewControllerTapAndDrawerKey];
        [settingsViewControllerDictionary setObject:[UIImage imageNamed:@"S7_powerIcon.png"]  forKey:kSlideViewControllerViewControllerIconKey];

        [sectionNine setObject:[NSArray arrayWithObject:settingsViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionNine];
        
        
        _datasource = [datasource retain];
        
    }
    
    return self;
}
- (void)dealloc {
    
    [_datasource release];
    [_searchDatasource release];
    
    [super dealloc];
    
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (UIViewController *)initialViewController {
    
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"HomeViewController_iphone5";
    }
    else{
        nibNameBundle=@"HomeViewController";
    }

    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    return [homeViewController autorelease];
    
}

- (NSIndexPath *)initialSelectedIndexPath {
    
    return [NSIndexPath indexPathForRow:0 inSection:0];
    
}

- (void)configureViewController:(UIViewController *)viewController userInfo:(id)userInfo {
    
    if ([viewController isKindOfClass:[WelcomeScreenViewController class]]) {
        if(isFBlogged){
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            
            [self FBlogout];
        }

    }
    
}
- (void)FBlogout {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout];
}

- (void)configureSearchDatasourceWithString:(NSString *)string {
    
    NSArray *searchableControllers = [[[self datasource] objectAtIndex:1] objectForKey:kSlideViewControllerSectionViewControllersKey];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slideViewControllerViewControllerTitle CONTAINS[cd] %@", string];
    [_searchDatasource setArray:[searchableControllers filteredArrayUsingPredicate:predicate]];
    
}

- (NSArray *)searchDatasource  {
    
    return _searchDatasource;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
