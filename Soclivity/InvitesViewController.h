//
//  InvitesViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInvitesView.h"
#import "ContactsListViewController.h"
@protocol InvitesViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end

@interface InvitesViewController : UIViewController<ActivityInvitesViewDelegate,ContactsListViewDelegate>{
    id <InvitesViewDelegate>delegate;
    IBOutlet UIButton*settingsButton;
    IBOutlet UIButton*activityBackButton;
    IBOutlet UILabel *inviteTitleLabel;
    IBOutlet UILabel *openSlotsNoLabel;
    NSInteger num_of_slots;
    NSString *activityName;
    BOOL inviteFriends;
    ActivityInvitesView *activityInvites;
}
@property (nonatomic,retain)id <InvitesViewDelegate>delegate;
@property (nonatomic,retain)UIButton*settingsButton;
@property (nonatomic,retain)UIButton*activityBackButton;
@property (nonatomic,retain)UILabel *inviteTitleLabel;
@property (nonatomic,retain)UILabel *openSlotsNoLabel;
@property (nonatomic,assign)NSInteger num_of_slots;
@property (nonatomic,retain)NSString *activityName;
@property (nonatomic,assign)BOOL inviteFriends;
-(IBAction)profileSliderPressed:(id)sender;
-(IBAction)popBackToActivityScreen:(id)sender;
-(void)OpenSlotsUpdate:(BOOL)increment;
@end
