//
//  GetNotificationsInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 17/02/13.
//
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"

@class GetNotificationsInvocation;

@protocol GetNotificationsInvocationDelegate

-(void)notificationsToShowDidFinish:(GetNotificationsInvocation*)invocation
                             withResponse:(NSArray*)responses
                                withError:(NSError*)error;
@optional
-(void)successRemoveNotification:(NSString*)msg;

@end



@interface GetNotificationsInvocation : ProjectAsyncInvocation
@property(nonatomic,assign)NSInteger notificationType;
@property(nonatomic,assign)NSInteger notificationId;
@end
