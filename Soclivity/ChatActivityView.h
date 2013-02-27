//
//  ChatActivityView.h
//  Soclivity
//
//  Created by Kanav Gupta on 23/02/13.
//
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Message.h"
@class Message;
@protocol ChatActivityViewDelegate <NSObject>

@optional
-(void)removeParticipantFromEvent:(NSInteger)playerId;
@end


@interface ChatActivityView : UIView<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate>{
    UIView *chatBackgroundView;
    UITableView *chatTableView;

}
-(void)setUpBackgroundView;
-(void)SetupChatTableView;
-(void)updateChatScreen:(NSMutableArray*)updatedChatArray;
- (void)enableSendButton;
- (void)disableSendButton;
- (void)resetSendButton;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)resizeViewWithOptions:(NSDictionary *)options;
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)sendMessage;
- (void)clearChatInput;
- (NSUInteger)addMessage:(Message *)message;
- (NSUInteger)removeMessageAtIndex:(NSUInteger)index;
-(void)userPostedAnImage:(Message*)post;

@property(nonatomic,retain)UITableView *chatTableView;
@property (nonatomic, assign) SystemSoundID receiveMessageSound;
@property (nonatomic,retain)id<ChatActivityViewDelegate>delegate;
@property (nonatomic, retain) UIImageView *chatBar;
@property (nonatomic, retain) UITextView *chatInput;
@property (nonatomic, assign) CGFloat previousContentHeight;
@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, copy) NSMutableArray *cellMap;
@end
