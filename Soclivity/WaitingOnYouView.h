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
@class NotificationClass;
@class MainServiceManager;
@class SoclivityManager;
@protocol WaitingOnYouDelegate <NSObject>

@optional
-(void)pushUserToDetailedNavigation:(NotificationClass*)notify;
-(void)userWantsToDeleteTheNofication:(NSInteger)notificationId;
-(void)userGoingNotification:(NSInteger)tag;
-(void)userNotGoingNotification:(NSInteger)tag;
-(void)acceptNotification:(NSInteger)tag player:(NSInteger)player;
-(void)declineNotification:(NSInteger)tag player:(NSInteger)player;
@end

@interface WaitingOnYouView : UIView<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,IconDownloaderDelegate,MBProgressHUDDelegate>{
    
    UITableView*waitingTableView;
    NSMutableArray *notificationsArray;
    NSMutableDictionary *imageDownloadsInProgress;
    MBProgressHUD *HUD;
    MainServiceManager *devServer;
    id<WaitingOnYouDelegate>delegate;
    SoclivityManager *SOC;
    NSInteger removeIndex;
    UIView*noNotificationBackgroundView;
    
}
@property (nonatomic,retain) NSMutableArray *notificationsArray;
@property (nonatomic,assign)id<WaitingOnYouDelegate>delegate;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSString *lstrnotificationid;
@property (nonatomic,retain) UITableView*waitingTableView;

- (id)initWithFrame:(CGRect)frame andNotificationsListArray:(NSArray*)andNotificationsListArray;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)notificationRemoved;
-(void)requestComplete;
-(void)updateButtonAndAnimation;
-(void)setUpBackgroundView;
-(void)toReloadTableWithNotifications:(NSMutableArray*)listArray;
@end
