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
static UIFont *boldText = nil;
+ (void)initialize
{
	if(self == [SOCTableViewCell class]){
        firstTextFont=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
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
    
    UIColor *backgroundColor = [SoclivityUtilities returnTextFontColor:7];
    UIColor *textColor =[SoclivityUtilities returnTextFontColor:5];
    
    // Set the background color
    [backgroundColor set];
    
    // Fill the rectangle with the color above
    CGContextFillRect(context, r);
    
    // Next color to use to draw
    [textColor set];
    
    [@"WHEN:" drawInRect:CGRectMake(45,10,55,25) withFont:boldText];
    
    [playActivity.dateAndTime drawInRect:CGRectMake(45+50, 10, 200, 25) withFont:firstTextFont];
    [@"WHERE:" drawInRect:CGRectMake(45,35,55,25) withFont:boldText];
    for(DetailInfoActivityClass *detailPlay in [playActivity quotations]){
    [detailPlay.location drawInRect:CGRectMake(45+55,35,200,25) withFont:firstTextFont];
    
    NSString *firstLabel=[NSString stringWithFormat:@"You have %d friends going",detailPlay.DOS_1];
    NSString *secondLabel=[NSString stringWithFormat:@"You may know  %d more people going",detailPlay.DOS_2];
    [firstLabel drawInRect:CGRectMake(45,60,200,25) withFont:firstTextFont];
    [secondLabel drawInRect:CGRectMake(45,85,280,25) withFont:firstTextFont];
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
