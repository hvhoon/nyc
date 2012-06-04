//
//  MapActivityClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapActivityClass.h"

@implementation MapActivityClass
@synthesize mapCoord,pinType,activityName,organizer,activityDateAndTime,DOS;

-(void)dealloc{
    [super dealloc];
    [activityName release];
    [organizer release];
    [activityDateAndTime release];
}
@end
