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

@class ResetPasswordInvocation;

@protocol ResetPasswordInvocationDelegate 

-(void)ResetPasswordInvocationDidFinish:(ResetPasswordInvocation*)invocation
                   withResponse:(NSString*)responses
                      withError:(NSError*)error;

@end

@interface ResetPasswordInvocation : ProjectAsyncInvocation{
    NSString *theNewPassword;
    NSString *confirmPassword;
    NSInteger userId;
    NSString *oldPassword;
}
@property (nonatomic, retain) NSString *confirmPassword;
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,retain)NSString*oldPassword;
@property (nonatomic, retain) NSString *theNewPassword;

@end
