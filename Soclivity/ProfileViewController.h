//
//  ProfileViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityTypeSelectView.h"
@class MainServiceManager;
@class MBProgressHUD;
@class SoclivityManager;
@protocol ProfileScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface ProfileViewController : UIViewController<ActivitySelectDelegate>{
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
    IBOutlet UIButton *tickButton;
}
@property (nonatomic,retain)id <ProfileScreenViewDelegate>delegate;
@property (nonatomic,retain)ActivityTypeSelectView *activityTypesView;
@property (nonatomic,assign) BOOL isFirstTime;
-(IBAction)profileSliderPressed:(id)sender;
-(IBAction)getStartedAction:(id)sender;
- (void)startAnimation:(NSInteger)type;
-(IBAction)doneButtonClicked:(id)sender;
@end
