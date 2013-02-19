//
//  NotificationClass+Parse.m
//  Soclivity
//
//  Created by Kanav Gupta on 17/02/13.
//
//

#import "NotificationClass+Parse.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "JSON.h"
@implementation NotificationClass (Parse)
+(NSArray*)GetNotificationsForTheUser:(NSDictionary*)ACTDict{
	if (!ACTDict) {
		return Nil;
	}

    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    SOC.loggedInUser.badgeCount=[[ACTDict objectForKey:@"badge"]integerValue];
    

    
    NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
    NSArray *notificationsArray=[ACTDict objectForKey:@"notifications"];

    for(id notification in notificationsArray){
        
        
        
        NotificationClass *play = [[NotificationClass alloc] init];
        NSNumber * n = [notification objectForKey:@"id"];
        play.notificationId= [n intValue];
        play.userId = [notification objectForKey:@"user_id"];
        play.notificationType = [notification objectForKey:@"notification_type"];
        play.notificationString = [notification objectForKey:@"notification"];
        play.latitude = [notification objectForKey:@"lat"];
        play.longitude = [notification objectForKey:@"lng"];
        play.timeOfNotification=[notification objectForKey:@"created_at"];
        NSNumber * received = [notification objectForKey:@"is_received"];
        play.isRead= [received boolValue];
        NSNumber * activityId = [notification objectForKey:@"activity_id"];
        play.activityId= [activityId intValue];
        NSNumber *referredTo = [notification objectForKey:@"reffered_to"];
        play.referredId= [referredTo intValue];
        
        play.photoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[notification objectForKey:@"photo_url"]];
        
        [entries addObject:play];
        
    }
    
    

    return entries;

}
@end
