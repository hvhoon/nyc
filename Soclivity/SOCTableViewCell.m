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
        textColor = [SoclivityUtilities returnTextFontColor:5];
    }
    
    [backgroundColor set];
    [background release];
    
    textColor=[SoclivityUtilities returnTextFontColor:5];
    CGContextFillRect(context, r);
    [textColor set];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 1)];
    v.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_lightdivider.png"]];
    [self addSubview:v];	
    [v release];
       
    
    [@"WHEN:" drawInRect:CGRectMake(45,10,55,25) withFont:boldText];
    [quotation.dateAndTime drawInRect:CGRectMake(45+50, 10, 200, 25) withFont:firstTextFont];
    
    [@"WHERE:" drawInRect:CGRectMake(45,35,55,25) withFont:boldText];
    [quotation.location drawInRect:CGRectMake(45+55,35,200,25) withFont:firstTextFont];

    NSString *firstLabel=[NSString stringWithFormat:@"You have %d friends going",quotation.DOS_1];
    NSString *secondLabel=[NSString stringWithFormat:@"You may know  %d more people going",quotation.DOS_2];
    [firstLabel drawInRect:CGRectMake(45,60,200,25) withFont:firstTextFont];
    [secondLabel drawInRect:CGRectMake(45,85,280,25) withFont:firstTextFont];
    
//    v = [[UIView alloc] initWithFrame:CGRectMake(0, 119, 320, 1)];
//    v.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_darkdivider.png"]];
//    [self addSubview:v];	
//    [v release];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self.contentView];
	NSLog(@"Tap Detected");

    [super touchesBegan:touches withEvent:event];
}
@end
