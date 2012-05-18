//
//  ResetPasswordInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"
#import "ParseOperation.h"

@class ResetPasswordInvocation;

@protocol ResetPasswordInvocationDelegate 

-(void)ResetPasswordInvocationDidFinish:(ResetPasswordInvocation*)invocation
                   withResponse:(NSArray*)responses
                      withError:(NSError*)error;

@end

@interface ResetPasswordInvocation : ProjectAsyncInvocation<ParseOperationDelegate>{
    NSOperationQueue*queue;
    NSString *newPassword;
    NSString *confirmPassword;
}
@property(nonatomic,retain) NSOperationQueue*queue;
@property (nonatomic, retain) NSString *newPassword;
@property (nonatomic, retain) NSString *confirmPassword;

@end
