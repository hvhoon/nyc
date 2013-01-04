//
//  WaitingOnYouView.h
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@protocol WaitingOnYouDelegate <NSObject>

@optional
- (void)pushContactsInvitesScreen;
@end

@interface WaitingOnYouView : UIView<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate>{
    
    UITableView*waitingTableView;
    NSMutableArray *_notifications;
    id<WaitingOnYouDelegate>delegate;
    
    NSMutableData *responsedata;
    
    UIActionSheet * loadingActionSheet;
}
@property (nonatomic,retain) NSMutableArray *_notifications;
@property (nonatomic,assign)id<WaitingOnYouDelegate>delegate;
@property (nonatomic, retain)UIImageView *img_vw;

- (id)initWithFrame:(CGRect)frame andNotificationsListArray:(NSArray*)andNotificationsListArray;
@end
