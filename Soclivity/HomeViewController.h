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

@protocol HomeScreenDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end

@interface HomeViewController : UIViewController<PullableViewDelegate,GetActivitiesInvocationDelegate>{
   
    IBOutlet UIButton *profileBtn;
    IBOutlet UIButton *addBtn;
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
    
}

@property (nonatomic,retain)id <HomeScreenDelegate>delegate;
@property (nonatomic,retain)EventsMapView *socEventMapView;
@property (nonatomic,retain)ActivityListView *activityTableView;
-(IBAction)profileSlidingDrawerTapped:(id)sender;
-(IBAction)AddANewActivity:(id)sender;
-(IBAction)FilterBtnClicked:(id)sender;
-(IBAction)FlipToListOrBackToMap:(id)sender;
-(IBAction)RefreshButtonTapped:(id)sender;
-(IBAction)CurrentLocation:(id)sender;
-(IBAction)DistanceSortingClicked:(id)sender;
-(IBAction)DOSSortingClicked:(id)sender;
-(IBAction)TimeSortingClicked:(id)sender;
@end
