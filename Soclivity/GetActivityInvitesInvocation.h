//
//  GetActivityInvitesInvocation.h
//  Soclivity
//
//  Created by Kanav on 10/5/12.
//
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"



@class GetActivityInvitesInvocation;

@protocol GetActivityInvitesInvocationDelegate

-(void)ActivityInvitesInvocationDidFinish:(GetActivityInvitesInvocation*)invocation
                             withResponse:(NSArray*)responses type:(NSInteger)type
                           withError:(NSError*)error;

@end

@interface GetActivityInvitesInvocation : ProjectAsyncInvocation


@property (nonatomic,assign) NSInteger playerId;
@property (nonatomic,assign) NSInteger activityId;
@property (nonatomic,assign) NSInteger inviteeType;
@property (nonatomic,retain) NSString *responseABString;
@end
