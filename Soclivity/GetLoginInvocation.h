//
//  GetLoginInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"
#import "ParseOperation.h"
@class GetLoginInvocation;

@protocol GetLoginInvocationDelegate 

-(void)LoginInvocationDidFinish:(GetLoginInvocation*)invocation
                      withResponse:(NSArray*)responses
                         withError:(NSError*)error;

@end

@interface GetLoginInvocation : ProjectAsyncInvocation<ParseOperationDelegate>{
    NSOperationQueue*queue;
}
@property(nonatomic,retain) NSOperationQueue*queue;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@end
