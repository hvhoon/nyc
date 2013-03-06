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

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;

- (void) setupInternalData;

@end


@implementation UIBubbleTableViewCell
@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;


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
    CGFloat y = 0;
    
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
