//
//  InfoActivityClass+Parse.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoActivityClass+Parse.h"
#import "InfoActivityClass.h"
#import "JSON.h"

@implementation InfoActivityClass (Parse)


+(InfoActivityClass*) ActivitiesFromDictionary:(NSDictionary*)ACTDict{
	if (!ACTDict) {
		return Nil;
	}
	
	InfoActivityClass *play = [[[InfoActivityClass alloc] init] autorelease];
#if 1    
    play.activityName = [ACTDict objectForKey:@"name"];
    NSNumber *type = [ACTDict objectForKey:@"atype"];
    play.type =[type intValue];
    play.access = [ACTDict objectForKey:@"access"];
    NSNumber *numberOfPeople = [ACTDict objectForKey:@"num_of_people"];
    play.num_of_people =[numberOfPeople intValue];
    play.activityId = [ACTDict objectForKey:@"id"];
    NSNumber *ownerId = [ACTDict objectForKey:@"ownnerid"];
    play.OwnerId =[ownerId intValue];
    play.updated_at=[ACTDict objectForKey:@"updated_at"];
    play.when=[ACTDict objectForKey:@"when"];
    play.where_address=[ACTDict objectForKey:@"where_address"];
    play.where_lat=[ACTDict objectForKey:@"where_lat"];
    play.where_lng=[ACTDict objectForKey:@"where_lng"];
    NSNumber *distance = [ACTDict objectForKey:@"Distance"];
    play.distance=[NSString stringWithFormat:@"%.02f",[distance doubleValue]];


#endif    
	return play;
    
}
+(NSArray*) ActivitiesFromArray:(NSArray*) ActivitiesSchedulesAt{
	if (!ActivitiesSchedulesAt) {
		return Nil;
	}
	
	NSMutableArray *schedules = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < ActivitiesSchedulesAt.count; i++) {
        InfoActivityClass *sch = [InfoActivityClass ActivitiesFromDictionary:[ActivitiesSchedulesAt objectAtIndex:i]];
        if (sch) {
            [schedules addObject:sch];
        }
    }
	
	return schedules;	
}
@end
