//
//  SOCTableViewCell.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "SOCTableViewCell.h"
#import "SoclivityUtilities.h"
#import "DetailInfoActivityClass.h"
@implementation SOCTableViewCell
@synthesize delegate;
@synthesize playActivity;
static UIFont *firstTextFont = nil;
static UIFont *secondTextFont = nil;
static UIFont *boldText = nil;
+ (void)initialize
{
	if(self == [SOCTableViewCell class]){
        firstTextFont=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
        secondTextFont=[UIFont fontWithName:@"Helvetica-Condensed" size:11];
        boldText=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        
    }
}


- (void)dealloc
{
    [super dealloc];
    [playActivity release];
}

- (void)drawContentView:(CGRect)r
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *background;
    UIColor *backgroundColor;
    background = [SoclivityUtilities returnTextFontColor:7];
    backgroundColor = background;
    
    
    UIColor *textColor =[UIColor blackColor];
    if(self.selected)
    {
        backgroundColor = background;
        textColor = [SoclivityUtilities returnTextFontColor:6];
    }
    
    [backgroundColor set];
    
    
    textColor=[SoclivityUtilities returnTextFontColor:6];
    CGContextFillRect(context, r);
    [textColor set];
    
    // Graphics in the details table cell
    [[UIImage imageNamed:@"S04_sectionDivider.png"] drawInRect:CGRectMake(0,0,320,1)];
    
    [[UIImage imageNamed:@"S04_detailShadow.png"] drawInRect:CGRectMake(0,0,320,10)];
    
    // First divider
    [[UIImage imageNamed:@"S04_detailDivider.png"] drawInRect:CGRectMake(22,38,283,1)];
    
    // Time info.
    [[UIImage imageNamed:@"S04_smallClock.png"] drawInRect:CGRectMake(50,15,12,12)];
    [playActivity.dateAndTime drawInRect:CGRectMake(50+25, 12, 200, 14) withFont:firstTextFont];
    
    // Distance info.
    [[UIImage imageNamed:@"S04_smallLocation.png"] drawInRect:CGRectMake(50,51,12,12)];
    NSString* distanceInfo = [NSString stringWithFormat:@"%@ miles away", playActivity.distance];
    [distanceInfo drawInRect:CGRectMake(50+25,48,200,14) withFont:firstTextFont];
    
    // Second divider
    [[UIImage imageNamed:@"S04_sectionDivider.png"] drawInRect:CGRectMake(22,75,283,1)];
    
    for(DetailInfoActivityClass *detailPlay in [playActivity quotations]){
     
        [[UIImage imageNamed:@"S04_smallDOS1.png"] drawInRect:CGRectMake(50-3,88,19,11)];
        
        NSString *firstLabel=[NSString stringWithFormat:@"%d Friends",detailPlay.DOS_1];
        [firstLabel drawInRect:CGRectMake(50+25,85,60,14) withFont:firstTextFont];
        
        [[UIImage imageNamed:@"S04_smallDOS2.png"] drawInRect:CGRectMake(50+95,88,19,11)];
        NSString *secondLabel=[NSString stringWithFormat:@"%d Friends of friends",detailPlay.DOS_2];
        [secondLabel drawInRect:CGRectMake(50+95+25+3,85,280,25) withFont:firstTextFont];
        
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self.contentView];
    NSLog(@"startpointX=%f",startPoint.x);
	NSLog(@"Tap Detected");

    [super touchesBegan:touches withEvent:event];
}
@end
