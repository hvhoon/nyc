//
//  ParticipantTableViewCell.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticipantTableViewCell.h"
#import "SoclivityUtilities.h"
@implementation ParticipantTableViewCell
@synthesize nameText,profileImage,noSeperatorLine;
static UIFont *firstTextFont = nil;
static UIFont *secondTextFont = nil;
static UIFont *boldText = nil;


+ (void)initialize
{
	if(self == [ParticipantTableViewCell class]){
        firstTextFont=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
        secondTextFont=[UIFont fontWithName:@"Helvetica-Condensed" size:11];
        boldText=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        
    }
}

- (void)dealloc
{
    [super dealloc];
}
- (void)drawContentView:(CGRect)r
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *background;
    UIColor *backgroundColor;
    background = [UIColor whiteColor];
    backgroundColor = background;
    
    
    UIColor *textColor =[SoclivityUtilities returnTextFontColor:5];
    if(self.selected)
    {
        backgroundColor = background;
        textColor = [SoclivityUtilities returnTextFontColor:5];
    }
    
    [backgroundColor set];
    
    
    CGContextFillRect(context, r);
    [textColor set];
    
    
    [[UIImage imageNamed:@"S05_participantPic.png"] drawInRect:CGRectMake(42,6,37,37)];

    CGRect profileImageP = CGRectMake(46,9.5, 28, 28);
    [profileImage drawInRect:profileImageP];
    
    
    CGRect nameLabelRectP = CGRectMake(100, 15, 180, 15);
    [nameText drawInRect:nameLabelRectP withFont:firstTextFont];
    
    
    if(!noSeperatorLine)
    [[UIImage imageNamed:@"S05_detailsLine.png"] drawInRect:CGRectMake(26,49,272,1)];


    // Graphics in the details table cell
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self.contentView];
    NSLog(@"startpointX=%f",startPoint.x);
	NSLog(@"Tap Detected");
    
    [super touchesBegan:touches withEvent:event];
}
@end
