//
//  InfoActivityClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoActivityClass.h"

@implementation InfoActivityClass
@synthesize type,activityName,organizerName,DOS,distance,goingCount,quotations,latitude,longitude,stamp,dateFormatterString,dateAndTime;

-(void)dealloc{
    [activityName release];
    [organizerName release];
    [DOS release];
    [distance release];
    [goingCount release];
    [latitude release];
    [longitude release];
    [quotations release];
    [dateFormatterString release];
    [dateAndTime release];
}

@end
