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
    NSString *testString=SOC.loggedInUser.unread_notification;
    NSString *finalIds=nil;
    
    if(testString != nil && [testString class] != [NSNull class] && ![testString isEqualToString:@""]){
        NSArray *commaSeperated=[testString componentsSeparatedByString:@","];
        if([commaSeperated count]==1){
            finalIds=[commaSeperated objectAtIndex:0];
        }
        else{
            finalIds=[commaSeperated objectAtIndex:0];
            for(int i=1;i<[commaSeperated count];i++){
                finalIds=[NSString stringWithFormat:@"%@,%@",finalIds,[commaSeperated objectAtIndex:i]];
            }
        }

    }else{
        
        finalIds=@"";
    }
    NSString*a=nil;
    
    switch (notificationType) {
        case kGetNotifications:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/mynotifications.json?logged_in_user_id=%d&ids=%@",[SOC.loggedInUser.idSoc intValue],finalIds];

            
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
