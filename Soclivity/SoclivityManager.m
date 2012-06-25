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
@synthesize delegate,registrationObject,basicInfoDone,currentLocation,loggedInUser,filterObject,AllowTapAndDrag;


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
        AllowTapAndDrag=TRUE;
        filterObject=[[FilterPreferenceClass alloc]init];
        filterObject.playAct=TRUE;
        filterObject.eatAct=TRUE;
        filterObject.seeAct=TRUE;
        filterObject.createAct=TRUE;
        filterObject.learnAct=TRUE;
        filterObject.whenSearchType=1;
        filterObject.startTime_48=0;
        filterObject.finishTime_48=48;
        filterObject.morning=YES;
        filterObject.afternoon=YES;
        filterObject.evening=YES;
        
            NSCalendar* myCalendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                                         fromDate:[NSDate date]];
            [components setHour: 23];
            [components setMinute:59];
            [components setSecond:59];
            filterObject.endPickDateTime=[myCalendar dateFromComponents:components];
            
            NSLog(@"weekdayComponentsEnd=%@",[myCalendar dateFromComponents:components]);
            
            [components setHour:00];
            [components setMinute:00];
            [components setSecond:01];
            NSLog(@"weekdayComponentsStart=%@",[myCalendar dateFromComponents:components]);
            filterObject.startPickDateTime=[myCalendar dateFromComponents:components];
            
        
    }
    return self;
}

@end
