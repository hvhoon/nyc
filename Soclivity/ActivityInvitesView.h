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

@protocol ActivityInvitesViewDelegate <NSObject>

@optional
- (void)pushContactsInvitesScreen;
@end


@interface ActivityInvitesView : UIView<CustomSearchBarDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,InviteTableViewCellDelegate,UIAlertViewDelegate>{
    
    CustomSearchbar *searchBarForInvites;
    BOOL searching;
    UITableView*inviteUserTableView;
    NSArray *InviteEntriesArray;
    NSMutableArray *filteredListContent;
    id<ActivityInvitesViewDelegate>delegate;
}
@property (nonatomic,retain)CustomSearchbar *searchBarForInvites;
@property (nonatomic,retain)NSArray *InviteEntriesArray;
@property (nonatomic,retain)NSMutableArray *filteredListContent;
@property (nonatomic,retain)id<ActivityInvitesViewDelegate>delegate;
-(void)inviteUsersFromAddressBook:(id)sender;
-(UIView*)SetupHeaderView;
-(void)loadTableView;
@end
