//
//  Message.m
//  Soclivity
//
//  Created by Kanav Gupta on 23/02/13.
//
//

#import "Message.h"

@implementation Message
@synthesize text,isImage,textDate,formattedDate,isMine;

-(void)dealloc{
    [super dealloc];
    [text release];
    [textDate release];
    [formattedDate release];
}
@end
