//
//  NotificationClass+Parse.h
//  Soclivity
//
//  Created by Kanav Gupta on 17/02/13.
//
//

#import <Foundation/Foundation.h>
#import "NotificationClass.h"

@interface NotificationClass (Parse)

+(NSArray*)GetNotificationsForTheUser:(NSDictionary*)ACTDict;
@end
