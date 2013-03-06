//
//  MessageInputView.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <UIKit/UIKit.h>


@interface MessageInputView : UIImageView
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *sendButton;


#pragma mark - Message input view
+ (CGFloat)textViewLineHeight;
+ (CGFloat)maxLines;
+ (CGFloat)maxHeight;

@end
