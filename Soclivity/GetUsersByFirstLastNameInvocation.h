//
//  GetUsersByFirstLastNameInvocation.h
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"

@class GetUsersByFirstLastNameInvocation;

@protocol GetUsersByFirstLastNameInvocationDelegate

-(void)SearchUsersInvocationDidFinish:(GetUsersByFirstLastNameInvocation*)invocation
                         withResponse:(NSArray*)responses type:(NSInteger)type
                                withError:(NSError*)error;

@end


@interface GetUsersByFirstLastNameInvocation : ProjectAsyncInvocation

@property (nonatomic,retain)NSString*searchName;
@property (nonatomic,assign) NSInteger playerId;
@property (nonatomic,assign) NSInteger activityId;
@property (nonatomic,assign)NSInteger typeOfSearch;
@end
