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
    self.image = [[UIImage imageNamed:@"input-bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)];
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    
    [self setupTextView];
    [self setupSendButton];
}

- (void)setupTextView
{
    CGFloat width = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 246.0f : 690.0f;
    CGFloat height = [MessageInputView textViewLineHeight] * [MessageInputView maxLines];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(6.0f, 3.0f, width, height)];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(13.0f, 0.0f, 14.0f, 7.0f);
    self.textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 13.0f, 0.0f);
    self.textView.scrollEnabled = YES;
    self.textView.scrollsToTop = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.font = [UIFont fontWithName:@"Helvetica-Condensed" size:16.0f];

    self.textView.textColor = [SoclivityUtilities returnTextFontColor:4];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDefault;
    [self addSubview:self.textView];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.0, self.textView.frame.size.width - 20.0, 34.0f)];
    [self.placeholderLabel setText:@"Entering text here!"];
    [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
    self.placeholderLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    self.placeholderLabel.textColor=[UIColor lightGrayColor];
    
    [self.textView addSubview:self.placeholderLabel];

	
    UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x - 1.0f,
                                                                                0.0f,
                                                                                self.textView.frame.size.width + 2.0f,
                                                                                self.frame.size.height)];
    inputFieldBack.image = [[UIImage imageNamed:@"input-field2"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f)];
    inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:inputFieldBack];
}

- (void)setupSendButton
{
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    self.sendButton.frame=CGRectMake(self.frame.size.width - 65.0f, 5, 56, 30);
    
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"S05.3_sendActive.png"] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"S05.3_sendInactive.png"] forState:UIControlStateDisabled];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"S05.3_sendActive.png"] forState:UIControlStateHighlighted];
#if 0
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    UIImage *sendBack = [[UIImage imageNamed:@"send"] resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [[UIImage imageNamed:@"send-highlighted"] resizableImageWithCapInsets:insets];

    self.sendButton.frame = CGRectMake(self.frame.size.width - 65.0f, 8.0f, 59.0f, 26.0f);

    NSString *title = NSLocalizedString(@"Send", nil);
    [self.sendButton setTitle:title forState:UIControlStateNormal];
    [self.sendButton setTitle:title forState:UIControlStateHighlighted];
    [self.sendButton setTitle:title forState:UIControlStateDisabled];
    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
    [self.sendButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
    [self.sendButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
    self.sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
#endif
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
