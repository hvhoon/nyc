//
//  ActivityTypeSelectView.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetPlayersClass;
@class MBProgressHUD;
@class SoclivityManager;
@class FilterPreferenceClass;
@protocol ActivitySelectDelegate <NSObject>

@optional
-(void)RegisterUserForTheFirstTime;
-(void)showgetStartedBtnOrNot:(BOOL)show;
-(void)updateActivityTypes:(int)show;
@end

@interface ActivityTypeSelectView : UIView<UIAlertViewDelegate> {
    id <ActivitySelectDelegate>delegate;
    IBOutlet UIImageView *playImageView;
    IBOutlet UIImageView *eatImageView;
    IBOutlet UIImageView *seeImageView;
    IBOutlet UIImageView *createImageView;
    IBOutlet UIImageView *learnImageView;
    GetPlayersClass *playerObj;
    MBProgressHUD *HUD;
    BOOL isRegisteration;
    SoclivityManager *SOC;
    FilterPreferenceClass*idObj;
    BOOL playUpdate;
    BOOL eatUpdate;
    BOOL createUpdate;
    BOOL seeUpdate;
    BOOL learnUpdate;
    int checkType;

}
@property (nonatomic,retain)id <ActivitySelectDelegate>delegate;
@property (nonatomic,retain)GetPlayersClass *playerObj;
@property (nonatomic,assign)BOOL isRegisteration;
-(IBAction)ActivitySelectClicked:(UIButton*)sender;
-(BOOL)MakeSureAtLeastOneActivitySelected;
-(void)startAnimation;
-(void)stopAnimation;
-(void)updateActivityTypes;
-(void)updateUncheckActivity;
@end
