//
//  ForgotPasswordInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"
#import "ParseOperation.h"


@class ForgotPasswordInvocation;

@protocol ForgotPasswordInvocationDelegate 

-(void)ForgotPasswordInvocationDelegate:(ForgotPasswordInvocation*)invocation
                           withResponse:(NSArray*)responses
                              withError:(NSError*)error;

@end

@interface ForgotPasswordInvocation : ProjectAsyncInvocation<ParseOperationDelegate>{
     NSOperationQueue*queue;
}
@property(nonatomic,retain) NSOperationQueue*queue;
@property (nonatomic, retain) NSString *emailAddress;

@end
