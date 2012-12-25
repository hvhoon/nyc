//
//  NotificationClass.m
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import "NotificationClass.h"

@implementation NotificationClass
@synthesize notificationString,type,profileImage,date,count;



-(void)dealloc{
    [super dealloc];
    [notificationString release];
    [date release];
    [profileImage release];
    [count release];
}

@end
