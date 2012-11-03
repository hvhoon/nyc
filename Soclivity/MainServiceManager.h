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
#import "FBSignInInvocation.h"
#import "GetActivitiesInvocation.h"
#import "DetailedActivityInfoInvocation.h"
#import "PostActivityRequestInvocation.h"
#import "EditActivityEventInvocation.h"
#import "GetActivityInvitesInvocation.h"
#import "NewActivityInvocation.h"
#import "GetUpcomingActivitiesInvocation.h"
#import "GetUserProfileInfoInvocation.h"
@interface MainServiceManager : SAService{
    
}

-(void)registrationDetailInvocation:(id<RegistrationDetailDelegate>)delegate isFBuser:(BOOL)isFBuser isActivityUpdate:(BOOL)isActivityUpdate;
-(void)GetPlayersInvocation:(id<GetPlayersDetailDelegate>)delegate;
-(void)getLoginInvocation:(NSString*)username Password:(NSString*)password delegate:(id<GetLoginInvocationDelegate>)delegate;
-(void)postResetAndConfirmNewPasswordInvocation:(NSString*)newPassword cPassword:(NSString*)cPassword andUserId:(NSInteger)userId tempPassword:(NSString*)tempPassword delegate:(id<ResetPasswordInvocationDelegate>)delegate;
-(void)postForgotPasswordInvocation:(NSString*)email delegate:(id<ForgotPasswordInvocationDelegate>)delegate;
-(void)postFBSignInInvocation:(NSString*)emailAddress facebookUid:(NSString*)facebookUid fbAccessToken:(NSString*)fbAccessToken delegate:(id<FBSignInInvocationDelegate>)delegate;
-(void)getActivitiesInvocation:(NSInteger)userId latitude:(float)latitude longitude:(float)longitude timeSpanFilter:(NSString*)timeSpanFilter updatedAt:(NSString*)updatedAt  delegate:(id<GetActivitiesInvocationDelegate>)delegate;
-(void)getActivitiesInvocation:(NSInteger)userId latitude:(float)latitude longitude:(float)longitude delegate:(id<GetActivitiesInvocationDelegate>)delegate;

-(void)getDetailedActivityInfoInvocation:(NSInteger)pId actId:(NSInteger)actId latitude:(float)latitude longitude:(float)longitude delegate:(id<DetailedActivityInfoInvocationDelegate>)delegate;
-(void)postActivityRequestInvocation:(NSInteger) rTag playerId:(NSInteger)playerid actId:(NSInteger)actId delegate:(id<PostActivityRequestInvocationDelegate>)delegate;
-(void)editActivityEventRequestInvocation:(InfoActivityClass*)acTClass requestType:(int)requestType delegate:(id<EditActivityEventInvocationDelegate>)delegate;
-(void)getActivityPlayerInvitesInvocation:(NSInteger)pId actId:(NSInteger)actId inviteeListType:(NSInteger)inviteeListType abContacts:(NSString*)abContacts delegate:(id<GetActivityInvitesInvocationDelegate>)delegate;
-(void)postCreateANewActivityInvocation:(InfoActivityClass*)activityObject delegate:(id<NewActivityRequestInvocationDelegate>)delegate;
-(void)getUpcomingActivitiesForUserInvocation:(NSInteger)playerSOCId player2:(NSInteger)player2 delegate:(id<GetUpcomingActivitiesInvocationDelegate>)delegate;
-(void)getUserProfileInfoInvocation:(NSInteger)playerSOCId friendPlayer:(NSInteger)friendPlayer delegate:(id<GetUserProfileInfoInvocationDelegate>)delegate;

@end
