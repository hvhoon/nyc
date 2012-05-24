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

@protocol ActivitySelectDelegate <NSObject>

@optional
-(void)pushHomeMapViewController;
@end

@interface ActivityTypeSelectView : UIView {
    id <ActivitySelectDelegate>delegate;
    IBOutlet UIImageView *playImageView;
    IBOutlet UIImageView *eatImageView;
    IBOutlet UIImageView *seeImageView;
    IBOutlet UIImageView *createImageView;
    IBOutlet UIImageView *learnImageView;
    BOOL play;
    BOOL eat;
    BOOL see;
    BOOL create;
    BOOL learn;
    GetPlayersClass *playerObj;
    MBProgressHUD *HUD;
    BOOL facebookTag;
    


    
}
@property (nonatomic,retain)id <ActivitySelectDelegate>delegate;
@property (nonatomic,retain)GetPlayersClass *playerObj;
@property (retain, nonatomic) IBOutlet UIButton *getStarted;
@property (retain, nonatomic) IBOutlet UIButton *getStarted;
@property (nonatomic,assign)BOOL facebookTag;
-(IBAction)playActivityClicked:(id)sender;
-(IBAction)eatActivityClicked:(id)sender;
-(IBAction)seeActivityClicked:(id)sender;
-(IBAction)createActivityClicked:(id)sender;
-(IBAction)learnActivityClicked:(id)sender;
-(void)MakeSureAtLeastOneActivitySelected;
-(void)startAnimation;
-(void)stopAnimation;

@end
