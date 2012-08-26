//
//  InviteUserTableViewCell.m
//  Soclivity
//
//  Created by Kanav Gupta on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InviteUserTableViewCell.h"
#import "SoclivityUtilities.h"
#import "InviteObjectClass.h"
@implementation InviteUserTableViewCell
@synthesize delegate,cellIndexPath,noSeperatorLine,userInviteProduct;
static UIFont *firstTextFont = nil;
static UIFont *secondTextFont = nil;
static UIFont *boldText = nil;



+ (void)initialize
{
	if(self == [InviteUserTableViewCell class]){
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
    [userInviteProduct.profileImage drawInRect:profileImageP];
    
    CGRect userNameLabelRectP = CGRectMake(100, 15, 180, 15);
    [userInviteProduct.userName drawInRect:userNameLabelRectP withFont:firstTextFont];
    
    
    
    
    switch (userInviteProduct.typeOfRelation) {
        case 0:
        {
            
            CGSize  size = [userInviteProduct.userName sizeWithFont:firstTextFont];
            NSLog(@"width=%f",size.width);
            
            CGRect DOSImageRect = CGRectMake(100+5+size.width, 17.5, 21, 12);


            if(userInviteProduct.DOS==1){
                [[UIImage imageNamed:@"dos1.png"] drawInRect:DOSImageRect];
            }
            else{
                [[UIImage imageNamed:@"dos2.png"] drawInRect:DOSImageRect];
            }

            if(userInviteProduct.status){
                
                inviteRect=CGRectMake(280, 17.5, 21, 16);
                [[UIImage imageNamed:@"S05.4_added.png"] drawInRect:inviteRect];
            }
            else{
                inviteRect=CGRectMake(280, 17.5, 22, 21);
                [[UIImage imageNamed:@"S05.4_addParticipant.png"] drawInRect:CGRectMake(280, 17.5, 22, 21)];
                
            }

        }
            break;
        case 1:
        {
            if(userInviteProduct.status){
                
                inviteRect=CGRectMake(280, 17.5, 21, 16);
                [[UIImage imageNamed:@"S05.4_added.png"] drawInRect:inviteRect];
            }
            else{
                inviteRect=CGRectMake(280, 17.5, 22, 21);
                [[UIImage imageNamed:@"S05.4_addParticipant.png"] drawInRect:CGRectMake(280, 17.5, 22, 21)];
                
            }
            
        }
            break;
            
        case 2:
        {
            if(userInviteProduct.status){
                
                inviteRect=CGRectMake(280, 17.5, 21, 16);
                [[UIImage imageNamed:@"S05.4_added.png"] drawInRect:inviteRect];
            }
            else{
                inviteRect=CGRectMake(270, 17.5, 40, 23);
                [[UIImage imageNamed:@"S05.4_invite.png"] drawInRect:inviteRect];
                
            }

        }
            break;
            
            
        case 3:
        {
            
            CGSize  size = [userInviteProduct.userName sizeWithFont:firstTextFont];
            NSLog(@"width=%f",size.width);
            
            CGRect DOSImageRect = CGRectMake(100+5+size.width, 17.5, 21, 12);
            
            
            if(userInviteProduct.DOS==1){
                [[UIImage imageNamed:@"dos1.png"] drawInRect:DOSImageRect];
            }
            else{
                [[UIImage imageNamed:@"dos2.png"] drawInRect:DOSImageRect];
            }
            
            if(userInviteProduct.status){
                
                inviteRect=CGRectMake(280, 17.5, 21, 16);
                [[UIImage imageNamed:@"S05.4_added.png"] drawInRect:inviteRect];
            }
            else{
                inviteRect=CGRectMake(280, 17.5, 22, 21);
                [[UIImage imageNamed:@"S05.4_addParticipant.png"] drawInRect:CGRectMake(280, 17.5, 22, 21)];
                
            }
            
        }
            break;
            
            
        case 4:
        {
            if(userInviteProduct.status){
                
                inviteRect=CGRectMake(280, 17.5, 21, 16);
                [[UIImage imageNamed:@"S05.4_added.png"] drawInRect:inviteRect];
            }
            else{
                inviteRect=CGRectMake(270, 17.5, 40, 23);
                [[UIImage imageNamed:@"S05.4_invite.png"] drawInRect:inviteRect];
                
            }
            
        }
            break;



    }
    
    if(!noSeperatorLine)
        [[UIImage imageNamed:@"S05_detailsLine.png"] drawInRect:CGRectMake(26,49,272,1)];
    
    
    // Graphics in the details table cell
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self.contentView];
    NSLog(@"startpointX=%f",startPoint.x);
	NSLog(@"Tap Detected");
    
    if(CGRectContainsPoint(inviteRect,startPoint)){
        
        [delegate inviteStatusUpdate:cellIndexPath];
    }

    
    [super touchesBegan:touches withEvent:event];
}

@end