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
@interface ContactsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CustomSearchBarDelegate,InviteTableViewCellDelegate>{
    
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

}
@property (nonatomic,retain)UIButton*activityBackButton;
@property (nonatomic,retain)UILabel *inviteTitleLabel;
@property (nonatomic,retain)UILabel *openSlotsNoLabel;
@property (nonatomic,assign)NSInteger num_of_slots;
@property (nonatomic,retain)NSString *activityName;
@property (nonatomic,retain) CustomSearchbar *searchBarForContacts;
-(IBAction)popBackToActivityInviteScreen:(id)sender;
@property (nonatomic,retain)NSMutableArray *filteredListContent;
@property (nonatomic,retain)NSArray*contactsListContentArray;
-(NSArray*)setUpDummyContactList;
@end