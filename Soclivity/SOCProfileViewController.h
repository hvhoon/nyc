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
#import "NotifyAnimationView.h"
@class SocPlayerClass;
@class SoclivityManager;
@class NotificationClass;
@interface SOCProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,InviteTableViewCellDelegate,IconDownloaderDelegate,NotifyAnimationViewDelegate,UIViewControllerRestoration>{
    
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
    NSInteger friendId;
    NotificationClass *notIdObject;
    BOOL isInAppNotif;
    IBOutlet UIImageView *topBarImageView;
    IBOutlet UIButton *backButton;

}
@property (nonatomic,retain)SocPlayerClass *playerObject;
@property (nonatomic,retain)NotificationClass *notIdObject;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain)NSMutableArray *loadNFriendsAtTimeArray;
@property (nonatomic,assign)NSInteger friendId;
@property (nonatomic,retain)NSArray *commonFriendsArray;
-(IBAction)profileBackButtonClicked:(id)sender;
-(UIView*)SetupHeaderView:(CGFloat)ht;
-(void)tapViewAll:(UITapGestureRecognizer*)sender;
- (NSInteger)tableViewHeight;
-(void)addLoadingMoreFooter:(NSInteger)loadMoreFooterHeight;
-(void)viewDetailActivity:(id)sender;
@end
