//
//  ProfileViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityTypeSelectView.h"
#import "NotifyAnimationView.h"
@class MainServiceManager;
@class MBProgressHUD;
@class SoclivityManager;
@class NotificationClass;
@protocol ProfileScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface ProfileViewController : UIViewController<ActivitySelectDelegate,NotifyAnimationViewDelegate,UIViewControllerRestoration>{
    id <ProfileScreenViewDelegate>delegate;
    IBOutlet ActivityTypeSelectView *activityTypesView;
    IBOutlet UILabel *updateActivityLabel;
    IBOutlet UIButton *profileButton;
    IBOutlet UIImageView *bottomBarImageView;
    IBOutlet UIButton *getStartedButton;
    BOOL isFirstTime;
    MainServiceManager *devServer;
    MBProgressHUD *HUD;
    SoclivityManager *SOC;
    IBOutlet UIButton*btnnotify;
    NotificationClass *notIdObject;
    IBOutlet UIImageView *topBarImageView;
    IBOutlet UIButton *homeButton;
}
@property (nonatomic,retain)id <ProfileScreenViewDelegate>delegate;
@property (nonatomic,retain)ActivityTypeSelectView *activityTypesView;
@property (nonatomic,assign) BOOL isFirstTime;
@property(nonatomic,retain)NotificationClass *notIdObject;
-(IBAction)profileSliderPressed:(id)sender;
-(IBAction)getStartedAction:(id)sender;
- (void)startAnimation:(NSInteger)type;
-(IBAction)autoSlideToHome:(id)sender;
@end
