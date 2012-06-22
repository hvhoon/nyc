//
//  InfoActivityClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoActivityClass.h"

@implementation InfoActivityClass
@synthesize type,activityName,organizerName,DOS,DOS1,DOS2,DOS3,distance,goingCount,quotations,where_lat,where_lng,stamp,dateAndTime;

@synthesize access,activityType,created_at,num_of_people,activityId,organizerId,updated_at,what,when,where_address,where_city;
@synthesize where_state,where_zip;
-(void)dealloc{
    [activityName release];
    [organizerName release];
    [distance release];
    [goingCount release];
    [where_lat release];
    [where_lng release];
    [quotations release];
    [dateAndTime release];
    [access release];
    [activityType release];
    [created_at release];
    [activityId release];
    [updated_at release];
    [what release];
    [when release];
    [where_address release];
    [where_city release];
    [where_state release];
    [where_zip release];
     
}

@end
