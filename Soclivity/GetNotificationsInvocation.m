//
//  GetNotificationsInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 17/02/13.
//
//

#import "GetNotificationsInvocation.h"
#import "NotificationClass+Parse.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
@implementation GetNotificationsInvocation
@synthesize notificationType,notificationId;
-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    NSString*a=nil;
    
    switch (notificationType) {
        case kGetNotifications:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/mynotifications.json?logged_in_user_id=%d",[SOC.loggedInUser.idSoc intValue]];

            
        }
            break;
            
        case kRemoveNotification:
        {
            a=[NSString stringWithFormat:@"dev.soclivity.com/deletenotification.json?logged_in_user_id=%d&notification_id=%d",[SOC.loggedInUser.idSoc intValue],notificationId];
        }
            break;
    }
    

    
    [self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    NSArray* response=nil;
    switch (notificationType)
    {
        case kGetNotifications:
        {
            response=[NotificationClass GetNotificationsForTheUser:resultsd];
            [self.delegate notificationsToShowDidFinish:self withResponse:response withError:Nil];
            
        }
            break;
            
        case kRemoveNotification:
        {
            
            NSString *message=[resultsd objectForKey:@"messages"];
            NSLog(@"messages=%@",message);
            [self.delegate successRemoveNotification:message];
        }
        default:
            break;
    }
    

	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate notificationsToShowDidFinish:self
                                         withResponse:nil
                                            withError:[NSError errorWithDomain:@"UserId"
                                                                          code:[[self response] statusCode]
                                                                      userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get activities for a user. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
