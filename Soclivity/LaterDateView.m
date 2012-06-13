//
//  LaterDateView.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LaterDateView.h"

@implementation LaterDateView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed: @"LaterDateView" owner:self options: nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];

    }
    return self;
}
-(IBAction)backTapped:(id)sender{
    [delegate pushTransformWithAnimation];
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
