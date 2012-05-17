//
//  MainServiceManager.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainServiceManager.h"

@implementation MainServiceManager



-(id)retain {	
	return [super retain];
}

-(void)dealloc {	
	[super dealloc];
}

-(void)registrationDetailInvocation:(id<RegistrationDetailDelegate>)delegate{
    
    RegistrationDetailInvocation *invocation = [[[RegistrationDetailInvocation alloc] init] autorelease];
    [self invoke:invocation withDelegate:delegate];
}

-(void)GetPlayersInvocation:(id<GetPlayersDetailDelegate>)delegate{
	GetPlayersDetailInvocation *invocation = [[[GetPlayersDetailInvocation alloc] init] autorelease];
	[self invoke:invocation withDelegate:delegate];
}

-(void)getLoginInvocation:(NSString*)username Password:(NSString*)password delegate:(id<GetLoginInvocationDelegate>)delegate{
    GetLoginInvocation *invocation = [[[GetLoginInvocation alloc] init] autorelease];
    invocation.username = username;
    invocation.password = password;
    [self invoke:invocation withDelegate:delegate];
}

-(void)postResetAndConfirmNewPasswordInvocation:(NSString*)newPassword cPassword:(NSString*)cPassword delegate:(id<ResetPasswordInvocationDelegate>)delegate{
    ResetPasswordInvocation *invocation = [[[ResetPasswordInvocation alloc] init] autorelease];
    invocation.newPassword = newPassword;
    invocation.confirmPassword = cPassword;
    [self invoke:invocation withDelegate:delegate];
}

-(void)postForgotPasswordInvocation:(NSString*)email delegate:(id<ForgotPasswordInvocationDelegate>)delegate{
    ForgotPasswordInvocation *invocation = [[[ForgotPasswordInvocation alloc] init] autorelease];
    invocation.emailAddress = email;
    [self invoke:invocation withDelegate:delegate];
}
@end
