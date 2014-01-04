//
//  ActivityChatData.m
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import "ActivityChatData.h"
#import "SoclivityUtilities.h"
@implementation ActivityChatData
#pragma mark - Properties

@synthesize date = _date;
@synthesize name=_name;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize showAvatars = _showAvatars;
@synthesize activityId;
@synthesize playerId;
@synthesize avatarUrl;
@synthesize chatId;
@synthesize postImageUrl;
@synthesize postImage;
@synthesize ownerId;
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    [_name release];
    _name=nil;
    self.avatar = nil;
    [avatarUrl release];
    [postImageUrl release];
    [postImage release];
    [super dealloc];
}

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {15, 15, 7.5, 23};//5//11
const UIEdgeInsets textInsetsSomeone = {10, 17.5, 12.5, 15};


+ (id)dataWithText:(NSString *)text date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type 
{
    return [[[ActivityChatData alloc] initWithText:text date:date name:name type:type] autorelease];
}

- (id)initWithText:(NSString *)text date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type 
{

    UIFont *font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
    if (type == BubbleTypeMine)
        label.textColor=[UIColor whiteColor];
    else
        label.textColor=[SoclivityUtilities returnTextFontColor:9];
    
    [label autorelease];
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date name:name type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {20, 15, 10, 21};//11//16
const UIEdgeInsets imageInsetsSomeone = {15, 21, 15, 15};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type 
{
    return [[[ActivityChatData alloc] initWithImage:image date:date name:name type:type] autorelease];
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 93, 93)];
    imageView.image = image;
    [imageView autorelease];
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date name:name type:type insets:insets];
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
    return [[[ActivityChatData alloc] initWithView:view date:date name:name type:type insets:insets] autorelease];
}

- (id)initWithView:(UIView *)view date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
    self = [super init];
    if (self)
    {
        _view = [view retain];
        _name=[name retain];
        _date = [date retain];
        _type = type;
        _insets = insets;
    }
    return self;
}



@end
