//
//  ActivityInvitesView.h
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
@protocol ActivityInvitesViewDelegate <NSObject>

@optional
- (void)pushContactsInvitesScreen;
-(void)OpenSlotsUpdate:(BOOL)increment;
-(void)inviteSoclivityUser:(int)invitePlayerId;
-(BOOL)CalculateOpenSlots;
-(void)PushUserToProfileScreen:(InviteObjectClass*)player;
-(void)sendInviteOnFacebookPrivateMessage:(int)fbUId;
-(void)searchSoclivityPlayers:(NSString*)searchText;
@end


@interface ActivityInvitesView : UIView<SoclivitySearchBarDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,InviteTableViewCellDelegate,UIAlertViewDelegate,IconDownloaderDelegate>{
    
    CustomSearchbar *searchBarForInvites;
    BOOL searching;
    UITableView*inviteUserTableView;
    NSArray *InviteEntriesArray;
    NSMutableArray *filteredListContent;
    id<ActivityInvitesViewDelegate>delegate;
    NSMutableDictionary *imageDownloadsInProgress;
    InviteObjectClass *statusUpdate;
    NSTimer * _searchTimer;
    MainServiceManager *devServer;
}
@property (nonatomic,retain)CustomSearchbar *searchBarForInvites;
@property (nonatomic,retain)NSArray *InviteEntriesArray;
@property (nonatomic,retain)NSMutableArray *filteredListContent;
@property (nonatomic,retain)id<ActivityInvitesViewDelegate>delegate;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain) InviteObjectClass *statusUpdate;
-(void)inviteUsersFromAddressBook:(id)sender;
-(UIView*)SetupHeaderView;
-(void)closeAnimation;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;
- (id)initWithFrame:(CGRect)frame andInviteListArray:(NSArray*)andInviteListArray;
-(void)activityInviteStatusUpdate;
- (void)searchFromSoclivityDatabase:(NSTimer *)timer;
-(void)searchPlayersLoad:(NSArray*)players;
@end
