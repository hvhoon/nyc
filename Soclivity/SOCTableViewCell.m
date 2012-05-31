//
//  SOCTableViewCell.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "SOCTableViewCell.h"
#import "SoclivityUtilities.h"
@implementation SOCTableViewCell
@synthesize delegate;
@synthesize quotation;
static UIFont *firstTextFont = nil;
+ (void)initialize
{
	if(self == [SOCTableViewCell class]){
        firstTextFont=[UIFont fontWithName:@"Helvetica-Condensed" size:18];
        
    }
}


- (void)dealloc
{
    [super dealloc];
    [quotation release];
}

- (void)drawContentView:(CGRect)r
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *background;
    UIColor *backgroundColor;
    background = [UIColor whiteColor];
    backgroundColor = background;
    
    
    UIColor *textColor =[UIColor blackColor];
    if(self.selected)
    {
        backgroundColor = background;
        textColor = [SoclivityUtilities returnTextFontColor:1];
    }
    
    [backgroundColor set];
    [background release];
    
    textColor=[SoclivityUtilities returnTextFontColor:1];
    CGContextFillRect(context, r);
    [textColor set];
       
    [@"WHEN:" drawInRect:CGRectMake(25, 15,55, 25) withFont:firstTextFont];
    [quotation.dateAndTime drawInRect:CGRectMake(25+65, 15, 200, 25) withFont:firstTextFont];
    
    [@"WHERE:" drawInRect:CGRectMake(25, 55, 55, 25) withFont:firstTextFont];
    
    [quotation.location drawInRect:CGRectMake(25+75, 55, 200, 25) withFont:firstTextFont];

    [@"WHO:" drawInRect:CGRectMake(25, 85,55, 25) withFont:firstTextFont];
    NSString *firstLabel=[NSString stringWithFormat:@"You have %d friends going",quotation.DOS_1];
    NSString *secondLabel=[NSString stringWithFormat:@"You may know  %d more people going",quotation.DOS_2];
    [firstLabel drawInRect:CGRectMake(85, 85,200, 25) withFont:firstTextFont];
    
    [secondLabel drawInRect:CGRectMake(25, 110,280, 25) withFont:firstTextFont];


}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self.contentView];
	NSLog(@"Tap Detected");

    [super touchesBegan:touches withEvent:event];
}
@end
