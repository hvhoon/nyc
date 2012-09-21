//
//  ProfileViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityTypeSelectView;
@protocol ProfileScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface ProfileViewController : UIViewController{
    id <ProfileScreenViewDelegate>delegate;
    IBOutlet ActivityTypeSelectView *activityTypesView;
    IBOutlet UILabel *updateActivityLabel;
}
@property (nonatomic,retain)id <ProfileScreenViewDelegate>delegate;
@property (nonatomic,retain)ActivityTypeSelectView *activityTypesView;
-(IBAction)profileSliderPressed:(id)sender;
@end
