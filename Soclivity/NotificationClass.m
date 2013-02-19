//
//  NotificationClass.m
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import "NotificationClass.h"

@implementation NotificationClass
@synthesize notificationString,type,profileImage,date,count,notificationId,userId;
@synthesize activityId,expirationDate,photoUrl,latitude,longitude,notificationType,isRead;
@synthesize rowHeight,timeOfNotification,referredId;

-(void)dealloc{
    [super dealloc];
    [notificationString release];
    [date release];
    [profileImage release];
    [count release];
    [userId release];
    [expirationDate release];
    [photoUrl release];
    [latitude release];
    [longitude release];
    [notificationType release];
    [timeOfNotification release];
}

@end
