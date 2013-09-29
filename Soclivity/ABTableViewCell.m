//
//  ABTableViewCell.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"
#define _IPHONE_7_0     7
@interface ABTableViewCellView : UIView
@end

@implementation ABTableViewCellView

#if __IPHONE_OS_VERSION_MIN_REQUIRED < _IPHONE_7_0
- (void)drawRect:(CGRect)r
{
	[(ABTableViewCell *)[self superview] drawContentView:r];
}
#else

- (void)drawRect:(CGRect)r {
    UIView *view = self;
    while (view && ![view isKindOfClass:[ABTableViewCell class]]) view = view.superview;
    [(ABTableViewCell *)view drawContentView:r];
}
#endif

@end



@implementation ABTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        contentView = [[ABTableViewCellView alloc] initWithFrame:CGRectZero];
        contentView.opaque = YES;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView release];
		
		
        
    }
    return self;
}
- (void)dealloc
{
	[super dealloc];
}

- (void)setFrame:(CGRect)f
{
	[super setFrame:f];
	CGRect b = [self bounds];
	[contentView setFrame:b];
}

- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r
{
	// subclasses should implement this
}

@end


