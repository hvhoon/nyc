//
//  UIBubbleTableViewCell.m
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import "UIBubbleTableViewCell.h"
#import "ActivityChatData.h"
#import <QuartzCore/QuartzCore.h>

@implementation CHDemoView
@synthesize originRect;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        ges.numberOfTapsRequired = 1;
        ges.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:ges];
        
    }
    return self;
}

- (void)singleTapAction:(UITapGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = self.originRect;
        } completion:^(BOOL isFinished){
            [self removeFromSuperview];
        }];
        
        
    }
}
@end


@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;
@property (nonatomic,assign)int tapType;
- (void) setupInternalData;

@end


@implementation UIBubbleTableViewCell
@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;
@synthesize tapType,delegate,section;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
    self.avatarImage = nil;
    [super dealloc];
}


- (void)setDataInternal:(ActivityChatData*)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
        [self addSubview:self.bubbleImage];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
    
    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    
    
    CGFloat y = 0.0f;
    
    if([self.data.view isKindOfClass:[UIImageView class]]){
        y=5.0f;
    }
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
        UIImageView *profileFrameImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_participantPic.png"]];
        
        CGFloat avatarFrameX = (type == BubbleTypeSomeoneElse) ? 15 : self.frame.size.width - 52;
        CGFloat avatarFrameY = self.frame.size.height - 37;
        avatarFrameY=0.0f;
        profileFrameImageView.frame = CGRectMake(avatarFrameX, avatarFrameY, 37, 37);
        [self addSubview:profileFrameImageView];
        [profileFrameImageView release];
        

        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"picbox.png"])] autorelease];
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 19 : self.frame.size.width - 43;
        CGFloat avatarY = self.frame.size.height - 28;
        avatarY=3.50f;
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 28, 28);
        [self addSubview:self.avatarImage];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == BubbleTypeSomeoneElse) x += 55;
        if (type == BubbleTypeMine) x -= 55;
    }
    else{
        x=x-15;
    }
    
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    
    if([self.data.view isKindOfClass:[UIImageView class]]){
        //NSLog(@"Image View");
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired=1;
        [self.customView setUserInteractionEnabled:YES];
        [self.customView addGestureRecognizer:tapGesture];
        [tapGesture release];
        
    }
    else{
        //NSLog(@"Not Image View");
    }

    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];
    
    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"S05.3_chatBubbleGray.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:19];//8
        
    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"S05.3_chatBubbleBlue.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:19];//8
    }
    
    self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
#if 1
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    lpgr.delegate = self;
    [self.customView setUserInteractionEnabled:YES];
    [self.customView addGestureRecognizer:lpgr];
    [lpgr release];
#endif

}
-(void)handleTapGesture:(id)sender{
    
#if 1
    UIView *theSuperview = self; // whatever view contains your image views
    CGPoint touchPointInSuperview = [sender locationInView:theSuperview];
    UIView *touchedView = [theSuperview hitTest:touchPointInSuperview withEvent:nil];
    if([touchedView isKindOfClass:[UIImageView class]])
    {
        [touchedView becomeFirstResponder];
        
    }
    else{
    }
    
    
#endif
    
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect imgFrame = [window convertRect:[touchedView frame] fromView:self];
    UIImageView *touch=(UIImageView*)touchedView;
    CHDemoView *blackView = [[CHDemoView alloc] initWithFrame:imgFrame];
    blackView.backgroundColor = [[UIColor alloc]initWithPatternImage:touch.image];
    blackView.originRect = imgFrame;
    [window addSubview:blackView];
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         blackView.frame = window.frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

//Then in the gesture handler:

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //[gestureRecognizer.view becomeFirstResponder];
    CGPoint touchPointInSuperview = [gestureRecognizer locationInView:self];
    UIView *touchedView = [self hitTest:touchPointInSuperview withEvent:nil];

    
    if([gestureRecognizer.view  isKindOfClass:[UIImageView class]] && self.data.type==BubbleTypeMine)
    {
        tapType=1;

        // hooray, it's one of your image views! do something with it.
        //CGRect bounds = gestureRecognizer.view.bounds;
        [self showMenu:[touchedView frame]];
        
        
    }
    else if([gestureRecognizer.view  isKindOfClass:[UILabel class]] && self.data.type==BubbleTypeMine){
        tapType=2;
        //CGRect bounds = gestureRecognizer.view.bounds;
        [self showMenu:[touchedView frame]];
        
    }
    
    else if([gestureRecognizer.view  isKindOfClass:[UILabel class]] && self.data.type==BubbleTypeSomeoneElse){
        tapType=3;
        //CGRect bounds = gestureRecognizer.view.bounds;
        [self showMenu:[touchedView frame]];
        
    }
    
}



- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    switch (tapType) {
        case 1:
        {
            if (action == @selector(delete:)) {
                return YES;
            }
            
        }
            break;
        case 2:
        {
            if (action == @selector(copy:) ||
                action == @selector(delete:)) {
                return YES;
            }
            
        }
            break;
            
        case 3:
        {
            if (action == @selector(copy:)) {
                return YES;
            }
            
        }
            break;
            
    }
    return NO;
}

- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* copyCode = pasteboard.string;
    NSLog(@"copyCode=%@",copyCode);
    UILabel *label=(UILabel*)self.data.view;
    pasteboard.string =label.text;

    //[self.delegate tellToStopInteraction:YES];
}

- (void)delete:(id)sender {
	
    [self.delegate deleteThisSection:section];
}
- (void)showMenu:(CGRect)frame{
    //[self.delegate tellToStopInteraction:NO];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];


   //[self becomeFirstResponder];
    //[window becomeFirstResponder];
    //[self.delegate becomeFirstResponder];
   // UILabel *label=(UILabel*)self.data.view;
   [delegate showMenu:self.data tapTypeSelect:tapType];
    
    [[UIMenuController sharedMenuController] setTargetRect:frame inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:NO];
    
    //[self.delegate tellToStopInteraction:YES];
    
    //[self canResignFirstResponder];
    //[self resignFirstResponder];
    
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
