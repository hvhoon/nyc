//
//  MainServiceManager.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAService.h"
#import "RegistrationDetailInvocation.h"
#import "GetPlayersDetailInvocation.h"
#import "GetLoginInvocation.h"
#import "ResetPasswordInvocation.h"
#import "ForgotPasswordInvocation.h"
@interface MainServiceManager : SAService{
    
}

-(void)registrationDetailInvocation:(id<RegistrationDetailDelegate>)delegate;
-(void)GetPlayersInvocation:(id<GetPlayersDetailDelegate>)delegate;
-(void)getLoginInvocation:(NSString*)username Password:(NSString*)password delegate:(id<GetLoginInvocationDelegate>)delegate;
-(void)postResetAndConfirmNewPasswordInvocation:(NSString*)newPassword cPassword:(NSString*)cPassword delegate:(id<ResetPasswordInvocationDelegate>)delegate;
-(void)postForgotPasswordInvocation:(NSString*)email delegate:(id<ForgotPasswordInvocationDelegate>)delegate;
@end
