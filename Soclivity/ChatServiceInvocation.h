//
//  ChatServiceInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 08/03/13.
//
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"

@class ChatServiceInvocation;
@class ActivityChatData;
@protocol ChatServiceInvocationDelegate

-(void)chatPostToDidFinish:(ChatServiceInvocation*)invocation
                       withResponse:(NSArray*)responses
                          withError:(NSError*)error;
@optional
-(void)userPostedAText:(ActivityChatData*)msg;
-(void)userPostedAnImage:(ActivityChatData*)imagePost;
-(void)chatDeleted:(NSString*)message;
@end


@interface ChatServiceInvocation : ProjectAsyncInvocation
@property(nonatomic,assign)NSInteger playerId;
@property(nonatomic,assign)NSInteger activityId;
@property(nonatomic,retain)NSString*textMessage;
@property(nonatomic,assign)NSInteger requestType;
@property(nonatomic,retain)NSData*imageData;
@end
