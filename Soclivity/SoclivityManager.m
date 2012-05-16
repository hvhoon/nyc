//
//  SoclivityManager.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoclivityManager.h"
#import "SocFacebookLogin.h"
#import "GetPlayersClass.h"
@implementation SoclivityManager
@synthesize delegate,_session,FacebookLogin,registrationObject,basicInfoDone;


+ (id) SharedInstance {
	static id sharedManager = nil;
	
    if (sharedManager == nil) {
        sharedManager = [[self alloc] init];
    }
	
    return sharedManager;
}
-(id)init{
    
    if(self=[super init]){
        registrationObject=[[GetPlayersClass alloc]init];
    }
    return self;
}
-(void)SetFacebookConnectObject:(id)parentDelegate fTag:(NSInteger)fTag{
	FacebookLogin=[[SocFacebookLogin alloc]initWithApiKeyAndSecret:fTag];
	FacebookLogin.delegate=parentDelegate;
	[FacebookLogin ShowFacebookDialog];
	
	
}

@end
