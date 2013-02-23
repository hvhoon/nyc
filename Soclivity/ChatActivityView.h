//
//  ChatActivityView.h
//  Soclivity
//
//  Created by Kanav Gupta on 23/02/13.
//
//

#import <UIKit/UIKit.h>

@protocol ChatActivityViewDelegate <NSObject>

@optional
-(void)removeParticipantFromEvent:(NSInteger)playerId;
@end


@interface ChatActivityView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UIView *chatBackgroundView;
    UITableView *chatTableView;

}
-(void)setUpBackgroundView;
-(void)SetupChatTableView;
-(void)updateChatScreen:(NSMutableArray*)updatedChatArray;
@property(nonatomic,retain)UITableView *chatTableView;
@property (nonatomic,retain)id<ChatActivityViewDelegate>delegate;
@end
