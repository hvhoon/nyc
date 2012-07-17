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

-(void)registrationDetailInvocation:(id<RegistrationDetailDelegate>)delegate isFBuser:(BOOL)isFBuser{
    
    RegistrationDetailInvocation *invocation = [[[RegistrationDetailInvocation alloc] init] autorelease];
    invocation.isFacebookUser=isFBuser;
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

-(void)postResetAndConfirmNewPasswordInvocation:(NSString*)newPassword cPassword:(NSString*)cPassword andUserId:(NSInteger)userId tempPassword:(NSString*)tempPassword delegate:(id<ResetPasswordInvocationDelegate>)delegate{
    ResetPasswordInvocation *invocation = [[[ResetPasswordInvocation alloc] init] autorelease];
    invocation.theNewPassword = newPassword;
    invocation.confirmPassword = cPassword;
    invocation.userId=userId;
    invocation.oldPassword=tempPassword;
    [self invoke:invocation withDelegate:delegate];
}

-(void)postForgotPasswordInvocation:(NSString*)email delegate:(id<ForgotPasswordInvocationDelegate>)delegate{
    ForgotPasswordInvocation *invocation = [[[ForgotPasswordInvocation alloc] init] autorelease];
    invocation.emailAddress = email;
    [self invoke:invocation withDelegate:delegate];
}
-(void)postFBSignInInvocation:(NSString*)emailAddress facebookUid:(NSString*)facebookUid fbAccessToken:(NSString*)fbAccessToken delegate:(id<FBSignInInvocationDelegate>)delegate{
    FBSignInInvocation *invocation = [[[FBSignInInvocation alloc] init] autorelease];
    invocation.email = emailAddress;
    invocation.fbuid = facebookUid;
    invocation.access_token=fbAccessToken;
    [self invoke:invocation withDelegate:delegate];
    
}
-(void)getActivitiesInvocation:(NSInteger)userId latitude:(float)latitude longitude:(float)longitude timeSpanFilter:(NSString*)timeSpanFilter updatedAt:(NSString*)updatedAt  delegate:(id<GetActivitiesInvocationDelegate>)delegate{
    GetActivitiesInvocation *invocation = [[[GetActivitiesInvocation alloc] init] autorelease];
    invocation.userSOCId = userId;
    invocation.timeSpan = timeSpanFilter;
    invocation.lastUpdated = updatedAt;

    [self invoke:invocation withDelegate:delegate];

}
-(void)getActivitiesInvocation:(NSInteger)userId latitude:(float)latitude longitude:(float)longitude delegate:(id<GetActivitiesInvocationDelegate>)delegate{
    GetActivitiesInvocation *invocation = [[[GetActivitiesInvocation alloc] init] autorelease];
    invocation.userSOCId = userId;
    invocation.currentLatitude = latitude;
    invocation.currentLongitude = longitude;
   [self invoke:invocation withDelegate:delegate];
    
}
-(void)getDetailedActivityInfoInvocation:(NSInteger)pId actId:(NSInteger)actId delegate:(id<DetailedActivityInfoInvocationDelegate>)delegate{
    DetailedActivityInfoInvocation *invocation = [[[DetailedActivityInfoInvocation alloc] init] autorelease];
    invocation.playerId = pId;
    invocation.activityId = actId;
    [self invoke:invocation withDelegate:delegate];
    
}

@end
