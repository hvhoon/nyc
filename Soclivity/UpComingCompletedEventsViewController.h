//
//  UpComingCompletedEventsViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListView.h"
@class MainServiceManager;
@class SoclivityManager;
@protocol UpcomingCompletedEvnetsViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface UpComingCompletedEventsViewController : UIViewController<ActivityListViewDelegate>{
    id <UpcomingCompletedEvnetsViewDelegate>delegate;
    IBOutlet UILabel *activititesLabel;
    IBOutlet UIButton *organizedButton;
    IBOutlet UIButton *goingButton;
    IBOutlet UIButton *completedButton;
    IBOutlet ActivityListView *activityListView;
    MainServiceManager *devServer;
    SoclivityManager *SOC;
    BOOL isNotSettings;
    IBOutlet UIButton *profileButton;
    IBOutlet UIButton *backActivityButton;
}
@property (nonatomic,retain)id <UpcomingCompletedEvnetsViewDelegate>delegate;
@property (nonatomic,retain) ActivityListView *activityListView;
@property(nonatomic,assign)BOOL isNotSettings;
-(IBAction)profileSliderPressed:(id)sender;
-(IBAction)organizedButtonPressed:(id)sender;
-(IBAction)goingButtonPressed:(id)sender;
-(IBAction)completedButtonPressed:(id)sender;
-(IBAction)backButtonPressed:(id)sender;

@end
