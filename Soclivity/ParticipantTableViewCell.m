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
@synthesize nameText,profileImage;
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
    
    
    UIColor *textColor =[SoclivityUtilities returnTextFontColor:1];
    if(self.selected)
    {
        backgroundColor = background;
        textColor = [SoclivityUtilities returnTextFontColor:1];
    }
    
    [backgroundColor set];
    
    
    CGContextFillRect(context, r);
    [textColor set];
    
    
    [[UIImage imageNamed:@"S05_participantPic.png"] drawInRect:CGRectMake(38,7,51,48)];

    CGRect profileImageP = CGRectMake(40,10, 42, 41);
    [profileImage drawInRect:profileImageP];
    
    
    CGRect nameLabelRectP = CGRectMake(100, 20, 180, 15);
    [nameText drawInRect:nameLabelRectP withFont:firstTextFont];
    
    //[[UIImage imageNamed:@"S05_detailsLine.png"] drawInRect:CGRectMake(40,58,272,2)];


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
