//
//  SoclivityManager.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "FilterPreferenceClass.h"
@implementation SoclivityManager
@synthesize delegate,registrationObject,basicInfoDone,currentLocation,loggedInUser,filterObject;


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
        filterObject=[[FilterPreferenceClass alloc]init];
        filterObject.playAct=TRUE;
        filterObject.eatAct=TRUE;
        filterObject.seeAct=TRUE;
        filterObject.createAct=TRUE;
        filterObject.learnAct=TRUE;
        filterObject.whenSearchType=1;
    }
    return self;
}

@end
