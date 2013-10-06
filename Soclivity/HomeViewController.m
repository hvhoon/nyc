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
#import "ActivityEventViewController.h"
#import "MainServiceManager.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "SoclivitySqliteClass.h"
#import "LocationCustomManager.h"
#import "FilterPreferenceClass.h"
#import "MBProgressHUD.h"
#import "ParticipantClass.h"
#import "UpComingCompletedEventsViewController.h"
#import "SOCProfileViewController.h"
#import "CreateActivityViewController.h"
#import "NotificationClass.h"
#import "NotificationsViewController.h"
@interface HomeViewController(Private) <MBProgressHUDDelegate,NewActivityViewDelegate>
@end

@implementation HomeViewController
@synthesize delegate,socEventMapView,activityTableView,notIdObject;
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

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoteNotificationReceivedWhileRunning" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WaitingOnYou_Count" object:nil];
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
    [addButton setBackgroundImage:[UIImage imageNamed:@"addevent.png"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"addevent.png"] forState:UIControlStateHighlighted];
    
    
    [self.navigationController.navigationBar setHidden:YES];
    [self UpdateBadgeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatInAppNotification:) name:@"ChatNotification" object:Nil];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (UpdateBadgeNotification) name:@"WaitingOnYou_Count" object:nil];

    
    NSLog(@"viewWillAppear called in HomeViewController");
    if(SOC.localCacheUpdate){
        SOC.localCacheUpdate=FALSE;
        [activityTableView startPopulatingListView];
         [socEventMapView setUpMapAnnotations];

    }
    else if(SOC.editOrNewActivity){
        SOC.editOrNewActivity=FALSE;
        [self StartGettingActivities];
    }
}

-(void)chatInAppNotification:(NSNotification*)note{
    NotificationClass *notifObject=[SoclivityUtilities getNotificationChatPost:note];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 60) andNotif:notifObject];
    notif.delegate=self;
    [pullDownView.notificationView setUserInteractionEnabled:YES];
    
    if(bookmarkState){
        [pullDownView.notificationView setFrame:CGRectMake(0, 40, 320, 60)];
    }
    else{
        [pullDownView.notificationView setFrame:CGRectMake(0, 400, 320, 60)];
    }
    [pullDownView.notificationView addSubview:notif];

    
    
}


-(void)UpdateBadgeNotification{
    
    [SoclivityUtilities returnNotificationButtonWithCountUpdate:notifCountButton];
    
}


-(void)updateDropdownAndPlays{
        [pullDownView updateActivityTypes];
        [activityTableView sortingFilterRefresh];
        [activityTableView stopDropdownChange];
}
-(void)pushSlidingViewController{
    
    [SOC getUserObjectInAutoSignInMode];
    [delegate updateUserNameAndPhotoData];
    [pullDownView updateActivityTypes];
    
    if(SOC.currentLocation.coordinate.latitude!=0.0f && SOC.currentLocation.coordinate.longitude!=0.0f){
        [self StartGettingActivities];
    }
    else{
        [self getUpdatedLocationWithActivities];
        
    }

}

-(void)sessionLogout{
    [delegate sessionAutoLogout];
}

// Add this method
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#if 0
- (UIStatusBarStyle)preferredStatusBarStyle{return UIStatusBarStyleLightContent;}
#endif
- (void)viewDidLoad
{
    [super viewDidLoad];
    
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        {
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
        else
        {
            // iOS 6
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }
    
    
   // [self setNeedsStatusBarAppearanceUpdate];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        topBarImageView.frame=CGRectMake(0, 0, 320, 64);
        topBarImageView.image=[UIImage imageNamed:@"topbarIOS7.png"];
        soclivityLogoImageView.frame=CGRectMake(105, 25, 111, 29);
        addButton.frame=CGRectMake(275, 20, 40, 40);
        
        UIButton *searchButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        searchButton.frame = CGRectMake(0, 20, 40.0, 40.0);
        [searchButton setImage:[UIImage imageNamed:@"S04_search.png"] forState:UIControlStateNormal];

        if([SoclivityUtilities deviceType] & iPhone5){
            
            profileSliderButton.frame=CGRectMake(5, 420+88+20, 40, 40);
            staticView.frame=CGRectMake(0, 64, 320, 464);
            bottomBarImageView.frame=CGRectMake(0, 568-40, 320, 40);
            sortDistanceBtn.frame=CGRectMake(88,449+88, 23, 24);
            sortDOSBtn.frame=CGRectMake(148,449+88, 32, 21);
            sortByTimeBtn.frame=CGRectMake(208,449+88, 24, 24);
            staticButtonView.frame=CGRectMake(275,440+88, 40, 40);
            currentLocationBtn.frame=CGRectMake(118,449+88, 24, 24);
            refreshBtn.frame=CGRectMake(178,449+88, 23, 23);
            notifCountButton.frame=CGRectMake(35, 516, 32, 21);
        }
        else{
            profileSliderButton.frame=CGRectMake(5, 420+20, 40, 40);
            staticView.frame=CGRectMake(0, 64, 320, 464-88);
            bottomBarImageView.frame=CGRectMake(0, 568-40-88, 320, 40);
            sortDistanceBtn.frame=CGRectMake(88,449, 23, 24);
            sortDOSBtn.frame=CGRectMake(148,449, 32, 21);
            sortByTimeBtn.frame=CGRectMake(208,449, 24, 24);
            staticButtonView.frame=CGRectMake(275, 440, 40, 40);
            currentLocationBtn.frame=CGRectMake(118,449, 24, 24);
            refreshBtn.frame=CGRectMake(178,449, 23, 23);
            notifCountButton.frame=CGRectMake(35, 428, 32, 21);
        }

        [self.view addSubview:searchButton];
    }
    else{
        topBarImageView.autoresizesSubviews = YES;
        topBarImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        topBarImageView.frame=CGRectMake(0, 0, 320, 44);
        soclivityLogoImageView.frame=CGRectMake(105, 5, 111, 29);
        addButton.frame=CGRectMake(275, 0, 40, 40);
        
        UIButton *searchButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        searchButton.frame = CGRectMake(0, 0, 40.0, 40.0);
        [searchButton setImage:[UIImage imageNamed:@"S04_search.png"] forState:UIControlStateNormal];
        
        if([SoclivityUtilities deviceType] & iPhone5){
            
            profileSliderButton.frame=CGRectMake(5, 420+88, 40, 40);
            staticView.frame=CGRectMake(0, 44, 320, 464);
            bottomBarImageView.frame=CGRectMake(0, 548-40, 320, 40);
            sortDistanceBtn.frame=CGRectMake(88,429+88, 23, 24);
            sortDOSBtn.frame=CGRectMake(148,429+88, 32, 21);
            sortByTimeBtn.frame=CGRectMake(208,429+88, 24, 24);
            staticButtonView.frame=CGRectMake(275,420+88, 40, 40);
            currentLocationBtn.frame=CGRectMake(118,429+88, 24, 24);
            refreshBtn.frame=CGRectMake(178,429+88, 23, 23);
            activityTableView.frame=CGRectMake(0,0, 320, 376+88);
            socEventMapView.frame=CGRectMake(0,0, 320, 376+88);
            
        }
        else{
            profileSliderButton.frame=CGRectMake(5, 400+20, 40, 40);
            staticView.frame=CGRectMake(0, 44, 320, 464-88);
            bottomBarImageView.frame=CGRectMake(0, 548-40-88, 320, 40);
            sortDistanceBtn.frame=CGRectMake(88,429, 23, 24);
            sortDOSBtn.frame=CGRectMake(148,429, 32, 21);
            sortByTimeBtn.frame=CGRectMake(208,429, 24, 24);
            staticButtonView.frame=CGRectMake(275, 420, 40, 40);
            currentLocationBtn.frame=CGRectMake(118,429, 24, 24);
            refreshBtn.frame=CGRectMake(178,429, 23, 23);
            activityTableView.frame=CGRectMake(0,0, 320, 376);
            socEventMapView.frame=CGRectMake(0,0, 320, 376);
        }
        mapflipBtn.frame=CGRectMake(0,0, 40, 40);
        listFlipBtn.frame=CGRectMake(0,0, 40, 40);
        [self.view addSubview:searchButton];

    }

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_6_0)){
    self.restorationIdentifier = @"HomeViewController";
    self.restorationClass = [self class];
        }
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];
    
    // Using TestFlight Checkpoint
    [TestFlight passCheckpoint:@"Loading the Home Screen"];
    
    gradient=1.0;
    CGFloat xOffset = 0;
    animationDuration = 0.1;
  
    NSLog(@"offset=%f",xOffset);
    pullDownView = [[StyledPullableView alloc] initWithFrame:CGRectMake(xOffset, 0, 640, 460)];
    pullDownView.openedCenter = CGPointMake(320 + xOffset,190);//130
    pullDownView.closedCenter = CGPointMake(320 + xOffset, -172);//-200
    pullDownView.center = pullDownView.closedCenter;
    
    pullDownView.handleView.frame = CGRectMake(0, 402, 58, 58);
    pullDownView.delegate = self;
    
    CGFloat height=[UIScreen mainScreen].bounds.size.height;
    NSLog(@"height=%f",height);
    
    if([SoclivityUtilities deviceType] & iPhone5)
        overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 360, 320, 188)];
    
    else
         overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 360, 320, 100)];
        
    overLayView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:overLayView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    
    [overLayView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];

    [overLayView setHidden:YES];                            

    self.view.backgroundColor=[UIColor blackColor];
    [self.navigationController.navigationBar setHidden:YES];
    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    navSingleTap.numberOfTapsRequired = 1;
    [topNavBarView setUserInteractionEnabled:YES];
    [topNavBarView addGestureRecognizer:navSingleTap];
    [navSingleTap release];

    activityTableView.delegate=self;
    socEventMapView.delegate=self;
    [self.view insertSubview:profileBtn aboveSubview:topNavBarView];

    [self.view insertSubview:profileBtn aboveSubview:socEventMapView];
    [self.view insertSubview:profileBtn aboveSubview:activityTableView];
    
    [self.view insertSubview:pullDownView aboveSubview:topNavBarView];
    
    [self.view insertSubview:pullDownView aboveSubview:socEventMapView];
    [self.view insertSubview:pullDownView aboveSubview:activityTableView];
    
    [activityTableView setHidden:NO];
    [socEventMapView setHidden:YES];
    [activityTableView LoadTable];


    listFlipBtn.hidden=YES;
    mapflipBtn.hidden=NO;
    sortDistanceBtn.hidden=NO;
    sortDOSBtn.hidden=NO;
    sortByTimeBtn.hidden=NO;
    refreshBtn.hidden=YES;
    currentLocationBtn.hidden=YES;
    
    
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"FacebookLogin"]){
        
        //        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //        if(![[appDelegate facebook] extendAccessTokenIfNeeded]){
//        AutoSessionClass *session=[[AutoSessionClass alloc]init];
//        [session isFacebookTokenValid];
//        session.delegate=self;
        //        }
        //        else{
        //            [self pushSlidingViewController];
        //        }
        
        
        //[self UpdateBadgeNotification];
        
        
        [self pushSlidingViewController];// Awesome the problem is in this method
        
        
        
        SOC.loggedInUser.badgeCount=[[UIApplication sharedApplication]applicationIconBadgeNumber];
        NSLog(@"SOC.loggedInUser.badgeCount=%d",SOC.loggedInUser.badgeCount);

    }
    else{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FacebookLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SOC userProfileDataUpdate];
        if(SOC.currentLocation.coordinate.latitude!=0.0f && SOC.currentLocation.coordinate.longitude!=0.0f){
            [self StartGettingActivities];
        }
        else{
            [self getUpdatedLocationWithActivities];
            
        }
        
    }

    
    

    
    // Do any additional setup after loading the view from its nib.
}

-(void)searchTapHandle:(id)sender{
    
}

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"HomeViewController_iphone5";
    }
    else{
        nibNameBundle=@"HomeViewController";
    }
    
    UIViewController * myViewController =
    [[HomeViewController alloc]
     initWithNibName:nibNameBundle
     bundle:nil];
    
    return myViewController;
}
- (void)backgroundTapToPush:(NotificationClass*)notification{
    
    NSLog(@"Home Selected");

    [pullDownView.notificationView setUserInteractionEnabled:NO];
    
    notIdObject=[notification retain];

    
        switch ([notIdObject.notificationType integerValue]) {
            case 7:
            case 8:
            case 9:
            case 10:
            case 13:
            case 16:
    
    {
        SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
        socProfileViewController.friendId=notIdObject.referredId;
        [[self navigationController] pushViewController:socProfileViewController animated:YES];
        [socProfileViewController release];
        
    }
    
    break;
                
    default:
        {
                if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
                GetPlayersClass *obj=SOC.loggedInUser;
                
                if([SoclivityUtilities hasNetworkConnection]){
                    pushInAppNotif=TRUE;
                    [devServer getDetailedActivityInfoInvocation:[obj.idSoc intValue]  actId:notification.activityId  latitude:[notification.latitude floatValue] longitude:[notification.longitude floatValue] delegate:self];
                    
                }
                else{
                    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    [alert show];
                    [alert release];
                    return;
                    
                    
                }

        }
                break;
        }
    
}




#pragma mark DetailedActivityInfoInvocationDelegate Method
-(void)DetailedActivityInfoInvocationDidFinish:(DetailedActivityInfoInvocation*)invocation
                                  withResponse:(InfoActivityClass*)response
                                     withError:(NSError*)error{
    
    
    if(pushInAppNotif){
        pushInAppNotif=FALSE;
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    
    
    
    
    switch ([notIdObject.notificationType integerValue]) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 11:
        case 17:
        default:
            
            
        {
            NSString*nibNameBundle=nil;
            
            if([SoclivityUtilities deviceType] & iPhone5){
                nibNameBundle=@"ActivityEventViewController_iphone5";
            }
            else{
                nibNameBundle=@"ActivityEventViewController";
            }
            
            ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
            activityEventViewController.activityInfo=response;
            
            if([notIdObject.notificationType integerValue]==17)
                activityEventViewController.footerActivated=YES;
            
            [[self navigationController] pushViewController:activityEventViewController animated:YES];
            [activityEventViewController release];
            
        }
            break;
            
            
        }
    
}else{
    
    [self performSelectorOnMainThread:@selector(pushActivityController:) withObject:response waitUntilDone:NO];

}

}

- (void)didReceiveBackgroundNotification:(NSNotification*) note{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:note];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0,0, 320, 60) andNotif:notifObject];
    notif.delegate=self;

    [pullDownView.notificationView setUserInteractionEnabled:YES];
    
    if(bookmarkState){
        [pullDownView.notificationView setFrame:CGRectMake(0, 40, 320, 60)];
    }
    else{
        [pullDownView.notificationView setFrame:CGRectMake(0, 400, 320, 60)];
    }
    [pullDownView.notificationView addSubview:notif];
}

-(void)notificationViewHide{
    [pullDownView.notificationView setUserInteractionEnabled:NO];
}

-(void)getUpdatedLocationWithActivities{
    
    LocationCustomManager *SocLocation=[[LocationCustomManager alloc]init];
    SocLocation.delegate=self;
    SocLocation.theTag=kLatLongAndActivities;
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
#pragma mark Create New Activity methods

-(void)newActivityButtonPressed{
    
    [addButton setBackgroundImage:[UIImage imageNamed:@"addeventPressed.png"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"addeventPressed.png"] forState:UIControlStateHighlighted];
    
    [TestFlight passCheckpoint:@"Create New Activity"];

    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"CreateActivityViewController_iphone5";
    }
    else{
        nibNameBundle=@"CreateActivityViewController";
    }
    
    
    CreateActivityViewController *avEditController = [[CreateActivityViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    avEditController.delegate=self;
    avEditController.newActivity=YES;
    UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:avEditController];
	
    
	[self.navigationController presentViewController:addNavigationController animated:YES completion:Nil];
    
    


}

-(void)cancelCreateActivityEventScreen{
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
-(void)pushToNewActivity:(InfoActivityClass *)activity{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    
    SOC.editOrNewActivity=TRUE;
    
    NSString*nibNameBundle=nil;
    
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"ActivityEventViewController_iphone5";
    }
    else{
        nibNameBundle=@"ActivityEventViewController";
    }
    
    
    ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    
    activityEventViewController.activityInfo=activity;
	[[self navigationController] pushViewController:activityEventViewController animated:YES];
    [activityEventViewController release];
    
}

#pragma mark -
#pragma mark Sliding Drawer Action


-(IBAction)profileSlidingDrawerTapped:(id)sender{
    [delegate showLeft:sender];
    [TestFlight passCheckpoint:@"View Settings"];
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
                                 refreshBtn.hidden=NO;
                                 currentLocationBtn.hidden=NO;
                                 sortDistanceBtn.hidden=YES;
                                 sortDOSBtn.hidden=YES;
                                 sortByTimeBtn.hidden=YES;

                             }] ;
         } 
                        completion:^(BOOL finished){
                            [activityTableView setHidden:YES];
                            [socEventMapView setHidden:NO];
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
                                     sortDistanceBtn.hidden=NO;
                                     sortDOSBtn.hidden=NO;
                                     sortByTimeBtn.hidden=NO;
                                     refreshBtn.hidden=YES;
                                     currentLocationBtn.hidden=YES;

                                     
                                 }] ;
             } 
                            completion:^(BOOL finished){
                                [activityTableView setHidden:NO];
                                [socEventMapView setHidden:YES];
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
    
    [activityTableView setHidden:YES];
    [socEventMapView setHidden:NO];
        //kanav location test
    //[socEventMapView.mapView setShowsUserLocation:NO];
    [UIView commitAnimations];
    
    
    context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:staticButtonView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    
    listFlipBtn.hidden=NO;
    mapflipBtn.hidden=YES;
    refreshBtn.hidden=NO;
    currentLocationBtn.hidden=NO;

    sortDistanceBtn.hidden=YES;
    sortDOSBtn.hidden=YES;
    sortByTimeBtn.hidden=YES;
    
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
        
        [activityTableView setHidden:NO];
        [socEventMapView setHidden:YES];
        [UIView commitAnimations];
        //kanav location test

        //[socEventMapView.mapView setShowsUserLocation:YES];
        
        context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:staticButtonView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        listFlipBtn.hidden=YES;
        mapflipBtn.hidden=NO;
        refreshBtn.hidden=YES;
        currentLocationBtn.hidden=YES;

        sortDistanceBtn.hidden=NO;
        sortDOSBtn.hidden=NO;
        sortByTimeBtn.hidden=NO;
        [UIView commitAnimations];
    }
    
}
#endif

#pragma mark -
#pragma mark PullDownView

-(void)doTheTurn:(Boolean)open{
    
    if(open){
        socEventMapView.alpha = gradient;
        activityTableView.alpha = gradient;
        [UIView animateWithDuration:animationDuration
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             socEventMapView.alpha = 0.5;
                             activityTableView.alpha = 0.5;
                             gradient=0.5;

                         }
                         completion:^(BOOL finished){
                            // [[UIApplication sharedApplication] setStatusBarHidden:YES];

                         }];
        
        
    }
    else{
        socEventMapView.alpha =gradient;
        activityTableView.alpha = gradient;

        [UIView animateWithDuration: animationDuration
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             socEventMapView.alpha = 1.0;
                             activityTableView.alpha = 1.0;
                             gradient=1.0;
                         }
                         completion:^(BOOL finished){
                            // [[UIApplication sharedApplication] setStatusBarHidden:NO];

                         }];
    }
}

-(void)alphaLess{
   gradient=gradient-0.011;
    if(gradient<=0.5){
        gradient=0.5;
    }
    socEventMapView.alpha =gradient;
    activityTableView.alpha =gradient;
 }
-(void)alphaMore{
    gradient=gradient+0.011;
    if(gradient>=1.0){
        gradient=1.0;
    }
    socEventMapView.alpha = gradient;
    activityTableView.alpha =gradient;
 }

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened {
    if (opened) {
        NSLog(@"Now I'm open!");
        bookmarkState=TRUE;
        [TestFlight passCheckpoint:@"View Filter Pane"];
        
    } else {
        NSLog(@"Now I'm closed, pull me up again!");
        bookmarkState=FALSE;
        
        //time to update filters
        [activityTableView doFilteringByActivities];
        [socEventMapView doFilteringByActivities];
    }
}
-(void)AddHideAnOverlay:(Boolean)open{
    
    
    if(open){
        overLayView.hidden=NO;
         NSLog(@"show!");
    }
    else{
        overLayView.hidden=YES;
        NSLog(@"Hide!");
    }
}
#pragma mark -
#pragma mark HandleTap Overlay Method

- (void)handleTap:(UITapGestureRecognizer *)sender {
    NSLog(@"UITapGestureRecognizer");
    if(SOC.AllowTapAndDrag){
        
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [pullDownView setOpened:NO animated:YES];
         NSLog(@"Pull Down");
    }
    }
    else{
        [(UILabel*)[pullDownView viewWithTag:38] setText:SOC.filterObject.pickADateString];
    }
}
#pragma mark -
#pragma mark Refresh Btn Tapped

-(IBAction)RefreshButtonTapped:(id)sender{
    [self getUpdatedLocationWithActivities];
}

-(void)currentGeoUpdate{
    [socEventMapView gotoLocation];
}
#pragma mark -
#pragma mark CurrentLocation Btn Tapped

-(IBAction)CurrentLocation:(id)sender{
    
    LocationCustomManager *SocLocation=[[LocationCustomManager alloc]init];
    SocLocation.delegate=self;
    SocLocation.theTag=kOnlyLatLong;
}

#pragma mark -
#pragma mark DistanceSortingBtn Clicked


-(IBAction)DistanceSortingClicked:(id)sender{
    [activityTableView SortByDistance];
}
#pragma mark -
#pragma mark DOSSortingBtn Clicked

-(IBAction)DOSSortingClicked:(id)sender{
    [activityTableView sortByDegree];
}
#pragma mark -
#pragma mark TimeSorting Clicked

-(IBAction)TimeSortingClicked:(id)sender{
    [activityTableView SortByTime];
}
#pragma mark -
#pragma mark New Activity Push Method

-(void)PushToDetailActivityView:(InfoActivityClass*)detailedInfo andFlipType:(NSInteger)andFlipType{
    
    flipKeyViewTag=andFlipType;
    
   if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    
    if([SoclivityUtilities hasNetworkConnection]){
        
     [devServer getDetailedActivityInfoInvocation:[SOC.loggedInUser.idSoc intValue]    actId:detailedInfo.activityId  latitude:SOC.currentLocation.coordinate.latitude longitude:SOC.currentLocation.coordinate.longitude delegate:self];
    }
    else{
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil 
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
}
#define REFRESH_HEADER_HEIGHT 52.0f
-(void)StartGettingActivities{
    if(!doublePushStop){
    activityTableView.tableView.contentOffset = CGPointMake(0, -REFRESH_HEADER_HEIGHT);
    [activityTableView pullToRefreshMannually];
    }

     if([SoclivityUtilities hasNetworkConnection]){
         
        // [self loadingActivityMonitor];
         [devServer getActivitiesInvocation:[SOC.loggedInUser.idSoc intValue] latitude:SOC.currentLocation.coordinate.latitude longitude:SOC.currentLocation.coordinate.longitude delegate:self];
     }
     else{
         
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil 
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             [alert show];
             [alert release];
             return;
             
         
     }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];

    NSString  *currentTime=[dateFormatter stringFromDate:[NSDate date]];
    
    [[NSUserDefaults standardUserDefaults] setValue:currentTime forKey:@"SOCLastTimeUpdate"];

    //[devServer getActivitiesInvocation:[SOC.loggedInUser.idSoc intValue] latitude:SOC.currentLocation.coordinate.latitude longitude:SOC.currentLocation.coordinate.longitude timeSpanFilter:@"today" updatedAt:@"today" delegate:self];
//    NSString *timeStamp=[[NSUserDefaults standardUserDefaults] valueForKey:@"SOCTimeStamp"];
//    if(timeStamp==nil)
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
//    NSString  *currentTime=[dateFormatter stringFromDate:[NSDate date]];
//    
//    [[NSUserDefaults standardUserDefaults] setValue:currentTime forKey:@"SOCTimeStamp"];

}

#pragma mark -
#pragma mark GetActivitiesInvocationDelegate Method

-(void)ActivitiesInvocationDidFinish:(GetActivitiesInvocation*)invocation
                        withResponse:(NSArray*)responses
                           withError:(NSError*)error{
    //now time to write in the Sqlite DataBase(Delete and Clean the activities Table)
    
    //[self hudWasHidden:HUD];
//    [HUD hide:YES];
    
    doublePushStop=FALSE;
    [SoclivitySqliteClass InsertNewActivities:responses];
    [activityTableView startPopulatingListView];
    socEventMapView.centerLocation=TRUE;
    [socEventMapView setUpMapAnnotations];
}

-(void)currentLocation:(CLLocationCoordinate2D)theCoord{
        [self StartGettingActivities];
     
}

#pragma mark -
#pragma mark DetailedActivityInfoInvocationDelegate Method
#if 0
-(void)DetailedActivityInfoInvocationDidFinish:(DetailedActivityInfoInvocation*)invocation
                                  withResponse:(InfoActivityClass*)responses
                                     withError:(NSError*)error{
    
    
    
    [self performSelectorOnMainThread:@selector(pushActivityController:) withObject:responses waitUntilDone:NO];

#if 0
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(synchronousDownloadProfilePhotoBytes:) 
                                        object:responses];
    [queue addOperation:operation];
    [operation release];

#endif
    
}
#endif
-(void)synchronousDownloadProfilePhotoBytes:(InfoActivityClass*)player{
 
    int index=0;
    for(ParticipantClass *pC in player.friendsArray){
        index++;
            NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pC.photoUrl]];
            UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
             if(image.size.height != image.size.width)
              pC.profilePhotoImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            pC.profilePhotoImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];

        
    }
    index=0;
    for(ParticipantClass *pC in player.friendsOfFriendsArray){
        index++;
        NSLog(@"friendsOfFriendsArray=%d",index);
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pC.photoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            pC.profilePhotoImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            pC.profilePhotoImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
        }
    
    
    index=0;
    for(ParticipantClass *pC in player.pendingRequestArray){
        index++;
        NSLog(@"pendingRequestArray=%d",index);
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pC.photoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            pC.profilePhotoImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            pC.profilePhotoImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
    }
    
    index=0;
    for(ParticipantClass *pC in player.otherParticipantsArray){
        index++;
        NSLog(@"otherParticipantsArray=%d",index);
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pC.photoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            pC.profilePhotoImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            pC.profilePhotoImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
    }


    
    [self performSelectorOnMainThread:@selector(pushActivityController:) withObject:player waitUntilDone:NO];


}
-(void)pushActivityController:(InfoActivityClass*)response{
    
        NSString*nibNameBundle=nil;
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"ActivityEventViewController_iphone5";
        }
        else{
            nibNameBundle=@"ActivityEventViewController";
        }
    
        ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:[NSBundle mainBundle]];
        activityEventViewController.activityInfo=response;
        
        [[self navigationController] pushViewController:activityEventViewController animated:YES];
        [activityEventViewController release];
        
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        switch (flipKeyViewTag) {
            case 1:
            {
                [activityTableView BytesDownloadedTimeToHideTheSpinner];
                
            }
                break;
                
            case 2:
            {
                [socEventMapView spinnerCloseAndIfoDisclosureButtonUnhide];
                
            }
                break;
        }
}

-(void)PushToProfileView:(InfoActivityClass*)detailedInfo{
    
    if([SOC.loggedInUser.idSoc intValue]==detailedInfo.organizerId){
        NSString*nibNameBundle=nil;
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"UpComingCompletedEventsViewController_iphone5";
        }
        else{
            nibNameBundle=@"UpComingCompletedEventsViewController";
        }
        
        UpComingCompletedEventsViewController *upComingCompletedEventsViewController=[[UpComingCompletedEventsViewController alloc] initWithNibName:nibNameBundle bundle:nil];
        upComingCompletedEventsViewController.isNotSettings=TRUE;
        [[self navigationController] pushViewController:upComingCompletedEventsViewController animated:YES];
        [upComingCompletedEventsViewController release];
        
    }
    else{
        SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
        socProfileViewController.friendId=detailedInfo.organizerId;
        [[self navigationController] pushViewController:socProfileViewController animated:YES];
        [socProfileViewController release];
    }
}
-(void)loadingActivityMonitor{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    HUD.labelText = @"Loading...";
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
    HUD = nil;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)RefreshFromTheListView{
    doublePushStop=TRUE;
    [self getUpdatedLocationWithActivities];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}
@end
