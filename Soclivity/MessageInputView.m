//
//  MessageInputView.m
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import "MessageInputView.h"
#import "SoclivityUtilities.h"
@interface MessageInputView ()

- (void)setup;
- (void)setupTextView;
- (void)setupSendButton;

@end


@implementation MessageInputView

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.userInteractionEnabled = YES;
    
    [self setupTextView];
    [self setupSendButton];
}

- (void)setupTextView
{
    CGFloat width = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 246.0f : 690.0f;
    CGFloat height = [MessageInputView textViewLineHeight] * [MessageInputView maxLines];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.textView.scrollEnabled = YES;
    self.textView.scrollsToTop = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0f];

    self.textView.textColor = [SoclivityUtilities returnTextFontColor:9];
    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDefault;
    [self addSubview:self.textView];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.textView.frame.size.width - 20.0, 34.0f)];
    [self.placeholderLabel setText:@"Entering text here!"];
    [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
    self.placeholderLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    self.placeholderLabel.textColor=[UIColor lightGrayColor];
    
    [self.textView addSubview:self.placeholderLabel];

}

- (void)setupSendButton
{
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    self.sendButton.frame=CGRectMake(self.frame.size.width - 65.0f, 5, 56, 30);
    
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"S05.3_sendActive.png"] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"S05.3_sendInactive.png"] forState:UIControlStateDisabled];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"S05.3_sendActive.png"] forState:UIControlStateHighlighted];

    self.sendButton.enabled = NO;
    [self addSubview:self.sendButton];
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
    if (action == @selector(paste:)){
        return [super canPerformAction:action withSender:sender];

    }
    else{
        return NO;
    }
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}
#pragma mark - Message input view
+ (CGFloat)textViewLineHeight
{
    return 35.0f; // for fontSize 15.0f
}

- (void)paste:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* copyCode = pasteboard.string;
    NSLog(@"copyCode=%@",copyCode);
    
    //[self.delegate tellToStopInteraction:YES];
}

- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* copyCode = pasteboard.string;
    NSLog(@"copyCode=%@",copyCode);
    
    //[self.delegate tellToStopInteraction:YES];
}

+ (CGFloat)maxLines
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 4.0f : 8.0f;
}

+ (CGFloat)maxHeight
{
    return ([MessageInputView maxLines] + 1.0f) * [MessageInputView textViewLineHeight];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
