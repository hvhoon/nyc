//
//  SOCProfileViewController.h
//  Soclivity
//
//  Created by Kanav on 10/1/12.
//
//

#import <UIKit/UIKit.h>
#import "InviteUserTableViewCell.h"
#import "IconDownloader.h"
#import "MainServiceManager.h"
@class SocPlayerClass;
@class SoclivityManager;
@interface SOCProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,InviteTableViewCellDelegate,IconDownloaderDelegate>{
    
    IBOutlet UILabel*profileNameLabel;
    IBOutlet UIImageView *profileImageview;
    IBOutlet UIImageView *dosConnectionImageview;
    IBOutlet UILabel *profileUserNameLabel;
    IBOutlet UILabel *profileTextLinkLabel;
    SocPlayerClass *playerObject;
    IBOutlet UIImageView*bottomBarImageView;
    UITableView *commonFriendsTableView;
    NSArray *commonFriendsArray;
    NSMutableDictionary *imageDownloadsInProgress;
    BOOL numberOfFriendsWithPlayer;
    BOOL goLoading;
    NSInteger mRemainingFriendsCount;
    NSInteger mCountFriends;
    NSInteger currentCountIndex;
    NSMutableArray *loadNFriendsAtTimeArray;
    UIActivityIndicatorView *friendSpinnerLoadMore;
    BOOL mSetLoadMoreFooter;
    NSInteger footerHeight;
    UIView *loadMoreFooterView;
    UILabel *loadMoreFriendsLabel;
    BOOL mSetLoadNoMoreFriendsFooter;
    MainServiceManager *devServer;
    SoclivityManager *SOC;


}
@property (nonatomic,retain)SocPlayerClass *playerObject;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain)NSArray *commonFriendsArray;
@property (nonatomic,retain)NSMutableArray *loadNFriendsAtTimeArray;
-(IBAction)profileBackButtonClicked:(id)sender;
-(UIView*)SetupHeaderView;
-(IBAction)tapViewAll:(UITapGestureRecognizer*)sender;
- (NSInteger)tableViewHeight;
-(void)addLoadingMoreFooter:(NSInteger)loadMoreFooterHeight;
-(void)viewDetailActivity:(id)sender;
@end
