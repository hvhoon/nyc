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
                             withResponse:(NSArray*)responses
                                withError:(NSError*)error;

@end


@interface GetUsersByFirstLastNameInvocation : ProjectAsyncInvocation

@property (nonatomic,retain)NSString*searchName;
@end
