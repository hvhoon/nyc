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

-(void)registrationDetailInvocation:(NSString *)userName Pass:(NSString *)password delegate: (id<RegistrationDetailDelegate>)delegate{
    
    RegistrationDetailInvocation *invocation = [[[RegistrationDetailInvocation alloc] init] autorelease];
    invocation.password = userName;
    invocation.password_confirmation = password;
    [self invoke:invocation withDelegate:delegate];
}

-(void)GetPlayersInvocation:(id<GetPlayersDetailDelegate>)delegate{
	GetPlayersDetailInvocation *invocation = [[[GetPlayersDetailInvocation alloc] init] autorelease];
	[self invoke:invocation withDelegate:delegate];
}
@end
