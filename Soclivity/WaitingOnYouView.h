//
//  WaitingOnYouView.h
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "IconDownloader.h"
#import "MBProgressHUD.h"
#import "PostActivityRequestInvocation.h"

@class MBProgressHUD;
@class MainServiceManager;
@class SoclivityManager;
@protocol WaitingOnYouDelegate <NSObject>

@optional
- (void)pushContactsInvitesScreen;
@end

@interface WaitingOnYouView : UIView<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,IconDownloaderDelegate,MBProgressHUDDelegate,PostActivityRequestInvocationDelegate>{
    
    UITableView*waitingTableView;
    NSMutableArray *_notifications;
    NSMutableData *responsedata;
    UIActionSheet * loadingActionSheet;
    NSMutableDictionary *imageDownloadsInProgress;
    
    MBProgressHUD *HUD;
    MainServiceManager *devServer;
    id<WaitingOnYouDelegate>delegate;
     SoclivityManager *SOC;
}
@property (nonatomic,retain) NSMutableArray *_notifications;
@property (nonatomic,assign)id<WaitingOnYouDelegate>delegate;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSString *lstrnotificationid;
@property (nonatomic,retain) NSMutableArray *arr_notificationids;

- (id)initWithFrame:(CGRect)frame andNotificationsListArray:(NSArray*)andNotificationsListArray;

-(void)startAnimation;
-(void)hideMBProgress;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
