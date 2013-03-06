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

@protocol ChatActivityViewDelegate <NSObject>

@optional
-(void)showDoneButton:(BOOL)show;
@end


@interface ChatActivityView : UIView<UIActionSheetDelegate,UIBubbleTableViewDataSource,UITextViewDelegate>
@property (nonatomic,retain)id<ChatActivityViewDelegate>delegate;
@property (strong, nonatomic) MessageInputView *inputView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text;
- (void)sendPressed:(UIButton *)sender;
-(void)updateChatScreen;

- (void)finishSend;
- (void)scrollToBottomAnimated:(BOOL)animated;
-(void)postImagePressed:(UIImage*)image;

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification;
- (void)handleWillHideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;

@end
