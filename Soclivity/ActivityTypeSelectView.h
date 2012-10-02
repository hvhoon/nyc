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
@end

@interface ActivityTypeSelectView : UIView {
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
}
@property (nonatomic,retain)id <ActivitySelectDelegate>delegate;
@property (nonatomic,retain)GetPlayersClass *playerObj;
@property (nonatomic,assign)BOOL isRegisteration;
-(IBAction)ActivitySelectClicked:(UIButton*)sender;
-(void)MakeSureAtLeastOneActivitySelected;
-(void)startAnimation;
-(void)stopAnimation;
-(void)updateActivityTypes;
@end
