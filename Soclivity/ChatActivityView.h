//
//  ChatActivityView.h
//  Soclivity
//
//  Created by Kanav Gupta on 23/02/13.
//
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIBubbleTableViewDataSource.h"
#import "MessageSoundEffect.h"

@class MessageInputView;
@class ActivityChatData;
@protocol ChatActivityViewDelegate <NSObject>

@optional
-(void)showDoneButton:(BOOL)show;
-(void)postAtTextMessageOnTheServer:(NSString*)message;
-(void)showMenu:(ActivityChatData*)type tapTypeSelect:(NSInteger)tapTypeSelect;
@end


@interface ChatActivityView : UIView<UIActionSheetDelegate,UIBubbleTableViewDataSource,UITextViewDelegate>{
    ChatTableView *bubbleTable;
    UIView *loadPrevMessagesView;
    BOOL isKeyboardInView;
    CGFloat keyboardY;
}
@property (nonatomic,retain)id<ChatActivityViewDelegate>delegate;
@property (strong, nonatomic) MessageInputView *inputView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (nonatomic,retain) NSMutableArray *holdHistoryArray;
@property (nonatomic,retain)UIView*chatBackgroundView;
@property (nonatomic,retain) NSMutableArray *bubbleData;
@property(nonatomic,retain)ChatTableView *bubbleTable;

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text;
- (void)sendPressed:(UIButton *)sender;
-(void)updateChatScreen:(NSMutableArray*)chatArray;
- (void)finishSend;
- (void)scrollToBottomAnimated:(BOOL)animated;
-(void)postImagePressed:(ActivityChatData*)chatObject type:(NSInteger)type;
-(void)messageSentOrRecieved:(ActivityChatData*)chat type:(NSInteger)type;
#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification;
- (void)handleWillHideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;
-(void)updateDeltaChatWithNewData:(NSMutableArray*)responses;
-(void)postsNewUpdateOnChatScreen:(NSMutableArray*)responses;

@end
