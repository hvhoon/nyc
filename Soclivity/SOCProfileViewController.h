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
@class SocPlayerClass;
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
    BOOL numberOfPhotosWithXling;
    BOOL goLoading;
    NSInteger mRemainingRefreshImages;
    NSInteger mCountRefresh;
    NSInteger currentCountIndex;
    NSMutableArray *loadNFriendsAtTimeArray;
    UIActivityIndicatorView *refreshSpinnerLoadMore;
    BOOL mSetLoadMoreFooter;
    NSInteger footerHeight;
    UIView *loadMoreFooterView;
    UILabel *loadMorePhotosLabel;
    BOOL mSetLoadNoMorePhotosFooter;

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
