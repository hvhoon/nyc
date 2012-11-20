//
//  GetUserProfileInfoInvocation.h
//  Soclivity
//
//  Created by Kanav on 11/3/12.
//
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"
#import "SocPlayerClass.h"

@class GetUserProfileInfoInvocation;

@protocol GetUserProfileInfoInvocationDelegate

-(void)UserProfileInfoInvocationDidFinish:(GetUserProfileInfoInvocation*)invocation
                                withResponse:(SocPlayerClass*)response
                                   withError:(NSError*)error;

@end


@interface GetUserProfileInfoInvocation : ProjectAsyncInvocation
@property (nonatomic,assign) NSInteger playerId;
@property (nonatomic,assign) NSInteger friendId;

@end
