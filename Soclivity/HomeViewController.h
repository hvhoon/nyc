//
//  HomeViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsMapView.h"
#import "ActivityListView.h"
#import "StyledPullableView.h"
#import "GetActivitiesInvocation.h"
#import "LocationCustomManager.h"
#import "DetailedActivityInfoInvocation.h"
#import "NotifyAnimationView.h"

@class MainServiceManager;
@class SoclivityManager;
@class MBProgressHUD;
@class NotificationClass;
@protocol HomeScreenDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end

@interface HomeViewController : UIViewController<PullableViewDelegate,GetActivitiesInvocationDelegate,ActivityListViewDelegate,EventsMapViewDelegate,CoreLocationDelegate,DetailedActivityInfoInvocationDelegate,NotifyAnimationViewDelegate>{
   
    IBOutlet UIButton *profileBtn;
    IBOutlet UIView *topNavBarView;
    id <HomeScreenDelegate>delegate;
    IBOutlet EventsMapView *socEventMapView;
    IBOutlet ActivityListView *activityTableView;
    IBOutlet UIView *staticView;
    IBOutlet UIView *staticButtonView;
    BOOL footerActivated;
    BOOL searchBarActivated;
    IBOutlet UIButton *mapflipBtn;
    IBOutlet UIButton *listFlipBtn;
    IBOutlet UIButton*sortDistanceBtn;
    IBOutlet UIButton*sortDOSBtn;    
    IBOutlet UIButton*sortByTimeBtn;
    IBOutlet UIButton*refreshBtn;    
    IBOutlet UIButton*currentLocationBtn;
    StyledPullableView *pullDownView;
    float gradient;
    UIView *overLayView;
    float animationDuration;
    MainServiceManager *devServer;
    SoclivityManager *SOC;
    MBProgressHUD *HUD;
    int flipKeyViewTag;
    IBOutlet UIButton *notifCountButton;
    NotificationClass* notIdObject;
    BOOL pushInAppNotif;
    IBOutlet UIButton *addButton;
    BOOL bookmarkState;
}

@property (nonatomic,retain)id <HomeScreenDelegate>delegate;
@property (nonatomic,retain)EventsMapView *socEventMapView;
@property (nonatomic,retain)ActivityListView *activityTableView;
@property (nonatomic,retain)NotificationClass* notIdObject;

-(IBAction)profileSlidingDrawerTapped:(id)sender;
-(IBAction)FlipToListOrBackToMap:(id)sender;
-(IBAction)RefreshButtonTapped:(id)sender;
-(IBAction)CurrentLocation:(id)sender;
-(IBAction)DistanceSortingClicked:(id)sender;
-(IBAction)DOSSortingClicked:(id)sender;
-(IBAction)TimeSortingClicked:(id)sender;
-(void)StartGettingActivities;
-(void)getUpdatedLocationWithActivities;
-(void)loadingActivityMonitor;
-(void)synchronousDownloadProfilePhotoBytes:(InfoActivityClass*)player;

@end
