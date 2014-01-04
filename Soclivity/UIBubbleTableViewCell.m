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
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#define IMAGE_BOUNDRY_SPACE 10

@implementation CHDemoView
@synthesize originRect;


@synthesize image = _image;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        [self addSubview:_imageView];

        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        ges.numberOfTapsRequired = 1;
        ges.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:ges];
        
    }
    return self;
}

-(void) setImage:(UIImage *)image
{
    _image = image;
    [_imageView setImage:image];
    [self reLayoutView];
    
}
-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(_image != nil)
        [self reLayoutView];
}

- (void) reLayoutView
{
    float imgWidth = _image.size.width;
    float imgHeight = _image.size.height;
    float viewWidth = self.bounds.size.width - 2*IMAGE_BOUNDRY_SPACE;
    float viewHeight = self.bounds.size.height - 2*IMAGE_BOUNDRY_SPACE;
    
    float widthRatio = imgWidth / viewWidth;
    float heightRatio = imgHeight / viewHeight;
    _scalingFactor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    _imageView.bounds = CGRectMake(0, 0, imgWidth / _scalingFactor, imgHeight/_scalingFactor);
    _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    /*
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset = CGSizeMake(3, 3);
    _imageView.layer.shadowOpacity = 0.6;
    _imageView.layer.shadowRadius = 1.0;
     */
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
@synthesize tapType,delegate;

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
        
        /*
        UIImageView *profileFrameImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_participantPic.png"]];
        
        CGFloat avatarFrameX = (type == BubbleTypeSomeoneElse) ? 15 : self.frame.size.width - 52;
        CGFloat avatarFrameY = self.frame.size.height - 37;
        avatarFrameY=0.0f;
        profileFrameImageView.frame = CGRectMake(avatarFrameX, avatarFrameY, 37, 37);
        [self addSubview:profileFrameImageView];
        [profileFrameImageView release];
        */

        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"picbox.png"])] autorelease];
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 15 : self.frame.size.width - 52;
        CGFloat avatarY = self.frame.size.height - 37;
        avatarY=2.0f;
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 37, 37);
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width/2;
        self.avatarImage.layer.masksToBounds = YES;
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
    
    if([self.data.view isKindOfClass:[UIImageView class]] && self.data.postImage!=nil){
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
    
    // Specifying the insets
    UIEdgeInsets chatBubbleGrayInsets = UIEdgeInsetsMake(32, 22, 10, 10);
    UIEdgeInsets chatBubbleBlueInsets = UIEdgeInsetsMake(32, 10, 10, 22);

    
    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"S05.3_chatBubbleGray.png"] resizableImageWithCapInsets:chatBubbleGrayInsets resizingMode:UIImageResizingModeStretch];
        //self.bubbleImage.image = [[UIImage imageNamed:@"S05.3_chatBubbleGray.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:19];//8
        
    }
    else {
        y=y+5;
        self.bubbleImage.image = [[UIImage imageNamed:@"S05.3_chatBubbleBlue.png"] resizableImageWithCapInsets:chatBubbleBlueInsets resizingMode:UIImageResizingModeStretch];
        //self.bubbleImage.image = [[UIImage imageNamed:@"S05.3_chatBubbleBlue.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:19];//8
    }
    
    self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.customView setUserInteractionEnabled:YES];
    [self.customView addGestureRecognizer:lpgr];
    [lpgr release];

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
    //UIImageView *touch=(UIImageView*)touchedView;
    CHDemoView *blackView = [[CHDemoView alloc] initWithFrame:imgFrame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.originRect = imgFrame;
    [window addSubview:blackView];
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         blackView.frame = window.frame;
                         [blackView setImage:self.data.postImage];

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

    SoclivityManager *SOC=[SoclivityManager SharedInstance];
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

        if([SOC.loggedInUser.idSoc integerValue]==self.data.ownerId)
            tapType=2;
        
        //CGRect bounds = gestureRecognizer.view.bounds;
        [self showMenu:[touchedView frame]];
        
    }
    
    else if([gestureRecognizer.view  isKindOfClass:[UIImageView class]] && self.data.type==BubbleTypeSomeoneElse && [SOC.loggedInUser.idSoc integerValue]==self.data.ownerId)
    {
        tapType=1;
        
        // hooray, it's one of your image views! do something with it.
        //CGRect bounds = gestureRecognizer.view.bounds;
        [self showMenu:[touchedView frame]];
        
        
    }
    
}




- (void)showMenu:(CGRect)frame{
   [delegate showMenu:self.data tapTypeSelect:tapType];
    
    [[UIMenuController sharedMenuController] setTargetRect:frame inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:NO];
    
    
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
