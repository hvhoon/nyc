//
//  MessageInputView.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <UIKit/UIKit.h>


@interface MessageInputView : UIImageView<UITextViewDelegate>
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *backdrop;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong,nonatomic) UILabel *placeholderLabel;

#pragma mark - Message input view
+ (CGFloat)textViewLineHeight;
+ (CGFloat)maxLines;
+ (CGFloat)maxHeight;

@end
