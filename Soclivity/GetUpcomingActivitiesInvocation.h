//
//  GetUpcomingActivitiesInvocation.h
//  Soclivity
//
//  Created by Kanav on 11/1/12.
//
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"


@class GetUpcomingActivitiesInvocation;

@protocol GetUpcomingActivitiesInvocationDelegate

-(void)UpcomingActivitiesInvocationDidFinish:(GetUpcomingActivitiesInvocation*)invocation
                             withResponse:(NSArray*)responses
                                withError:(NSError*)error;

@end


@interface GetUpcomingActivitiesInvocation : ProjectAsyncInvocation

@property (nonatomic,assign) NSInteger player1Id;
@property (nonatomic,assign) NSInteger player2Id;


@end
