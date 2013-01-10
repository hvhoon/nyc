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

@class MBProgressHUD;
@protocol WaitingOnYouDelegate <NSObject>

@optional
- (void)pushContactsInvitesScreen;
@end

@interface WaitingOnYouView : UIView<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,IconDownloaderDelegate,MBProgressHUDDelegate>{
    
    UITableView*waitingTableView;
    NSMutableArray *_notifications;
    id<WaitingOnYouDelegate>delegate;
    
    NSMutableData *responsedata;
    UIActionSheet * loadingActionSheet;
    
     MBProgressHUD *HUD;
    
    NSMutableDictionary *imageDownloadsInProgress;
}
@property (nonatomic,retain) NSMutableArray *_notifications;
@property (nonatomic,assign)id<WaitingOnYouDelegate>delegate;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (id)initWithFrame:(CGRect)frame andNotificationsListArray:(NSArray*)andNotificationsListArray;

-(void)startAnimation;
-(void)hideMBProgress;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
