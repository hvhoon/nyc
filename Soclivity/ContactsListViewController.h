//
//  ContactsListViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSearchbar.h"
#import "InviteUserTableViewCell.h"
#import "IconDownloader.h"
@class MainServiceManager;
@class MBProgressHUD;
@protocol ContactsListViewDelegate <NSObject>

@optional
-(void)OpenSlotsUpdate:(BOOL)increment;
-(BOOL)CalculateOpenSlots;
@end

@interface ContactsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CustomSearchBarDelegate,InviteTableViewCellDelegate,IconDownloaderDelegate>{
    
    IBOutlet UIButton*activityBackButton;
    IBOutlet UILabel *inviteTitleLabel;
    IBOutlet UILabel *openSlotsNoLabel;
    NSInteger num_of_slots;
    NSString *activityName;
    CustomSearchbar *searchBarForContacts;
    IBOutlet UITableView *contactListTableView;
    BOOL searching;
    NSMutableArray *filteredListContent;
    NSArray *contactsListContentArray;
    id<ContactsListViewDelegate>delegate;
    BOOL inviteFriends;
    NSMutableDictionary *imageDownloadsInProgress;
    MainServiceManager *devServer;
    MBProgressHUD *HUD;
    InviteObjectClass *statusUpdate;
    NSInteger activityId;

}
@property (nonatomic,assign)    NSInteger activityId;
@property (nonatomic,retain)UIButton*activityBackButton;
@property (nonatomic,retain)UILabel *inviteTitleLabel;
@property (nonatomic,retain)UILabel *openSlotsNoLabel;
@property (nonatomic,assign)NSInteger num_of_slots;
@property (nonatomic,retain)NSString *activityName;
@property (nonatomic,retain)id<ContactsListViewDelegate>delegate;
@property (nonatomic,retain) CustomSearchbar *searchBarForContacts;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,assign)BOOL inviteFriends;
@property (nonatomic,retain)NSMutableArray *filteredListContent;
@property (nonatomic,retain)NSArray*contactsListContentArray;
-(NSArray*)setUpDummyContactList;
-(IBAction)popBackToActivityInviteScreen:(id)sender;
-(void)startAnimation:(int)type;
-(void)hideMBProgress;

@end
