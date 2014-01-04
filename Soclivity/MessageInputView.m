//
//  MessageInputView.m
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import "MessageInputView.h"
#import "SoclivityUtilities.h"

#define INPUT_HEIGHT 40.0f
#define INPUT_WIDTH 270.0f

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
    self.backdrop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, INPUT_WIDTH, INPUT_HEIGHT)];
    self.backdrop.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backdrop];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 4.0f, INPUT_WIDTH-10.0, INPUT_HEIGHT-8.0)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled = YES;
    self.textView.scrollsToTop = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.showsHorizontalScrollIndicator = NO;
    
    self.textView.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14.0f];

    self.textView.textColor = [SoclivityUtilities returnTextFontColor:9];
    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDefault;
    [self.backdrop addSubview:self.textView];

}

- (void)setupSendButton
{
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.sendButton.frame=CGRectMake(INPUT_WIDTH, 0, 50, INPUT_HEIGHT);
    self.sendButton.backgroundColor = [UIColor whiteColor];
    
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.sendButton setTitleColor:[SoclivityUtilities returnTextFontColor:10] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[SoclivityUtilities returnTextFontColor:10] forState:UIControlStateHighlighted];
    [self.sendButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.sendButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    
    self.sendButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:17];
    

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
    return INPUT_HEIGHT; // for fontSize 15.0f
}

- (void)paste:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* copyCode = pasteboard.string;
    NSLog(@"copyCode=%@",copyCode);
    
}

- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* copyCode = pasteboard.string;
    NSLog(@"copyCode=%@",copyCode);
    
}

+ (CGFloat)maxLines
{
    //return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 4.0f : 8.0f;
    return 1;
}

+ (CGFloat)maxHeight
{
    //return ([MessageInputView maxLines] + 1.0f) * [MessageInputView textViewLineHeight];
    return [MessageInputView textViewLineHeight];
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
