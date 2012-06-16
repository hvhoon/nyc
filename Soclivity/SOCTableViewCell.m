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
        firstTextFont=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
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
        textColor = [SoclivityUtilities returnTextFontColor:5];
    }
    
    [backgroundColor set];
    
    
    textColor=[SoclivityUtilities returnTextFontColor:5];
    CGContextFillRect(context, r);
    [textColor set];
    
    
    [[UIImage imageNamed:@"S04_detailShadow.png"] drawInRect:CGRectMake(0,0,320,10)];
    
    [[UIImage imageNamed:@"S04_smallClock.png"] drawInRect:CGRectMake(45,16,12,12)];
    
    [playActivity.dateAndTime drawInRect:CGRectMake(45+25, 12, 200, 25) withFont:firstTextFont];
    
    
    [[UIImage imageNamed:@"S04_sectionDivider.png"] drawInRect:CGRectMake(25,40,280,1)];
    
    [[UIImage imageNamed:@"S04_smallLocation.png"] drawInRect:CGRectMake(45,51,12,12)];

    for(DetailInfoActivityClass *detailPlay in [playActivity quotations]){
    [detailPlay.location drawInRect:CGRectMake(45+25,47,200,25) withFont:firstTextFont];
        
    [[UIImage imageNamed:@"S04_sectionDivider.png"] drawInRect:CGRectMake(25,75,280,1)];    
     
    [[UIImage imageNamed:@"S04_smallDOS1.png"] drawInRect:CGRectMake(45,93,19,11)];
        
    
    NSString *firstLabel=[NSString stringWithFormat:@"%d friends",detailPlay.DOS_1];
    [firstLabel drawInRect:CGRectMake(45+25,89,60,25) withFont:firstTextFont];
        
    [[UIImage imageNamed:@"S04_smallDOS2.png"] drawInRect:CGRectMake(45+100,93,19,11)];
    NSString *secondLabel=[NSString stringWithFormat:@"%d Friends of friends",detailPlay.DOS_2];
    [secondLabel drawInRect:CGRectMake(45+100+25,89,280,25) withFont:firstTextFont];
    }
    
    //[[UIImage imageNamed:@"S04_sectionDivider.png"] drawInRect:CGRectMake(0,118,320,0.5)];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self.contentView];
    NSLog(@"startpointX=%f",startPoint.x);
	NSLog(@"Tap Detected");

    [super touchesBegan:touches withEvent:event];
}
@end
