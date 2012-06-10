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
#if 0    
    play.activityName = [ACTDict objectForKey:@"name"];
    NSNumber *type = [ACTDict objectForKey:@"atype"];
    play.type =[type intValue];
    play.time_slot_id = [ACTDict objectForKey:@"when_act"];
    play.from_time = [ACTDict objectForKey:@"where_lat"];
    play.to_time = [ACTDict objectForKey:@"where_lng"];
    play.user_role_id = [ACTDict objectForKey:@"where_address"];
    play.user_id = [ACTDict objectForKey:@"where_city"];
    play.role_id = [ACTDict objectForKey:@"where_state"];
    play.sub_tenant_id = [ACTDict objectForKey:@"where_zip"];
    play.day = [ACTDict objectForKey:@"what"];
    play.sub_tenant_id = [ACTDict objectForKey:@"access"];
    play.goingCount = [ACTDict objectForKey:@"numofpeople"];
    play.sub_tenant_id = [ACTDict objectForKey:@"ownnerid"];
    play.day = [ACTDict objectForKey:@"created"];
    play.sub_tenant_id = [ACTDict objectForKey:@"last_update"];
    play.day = [ACTDict objectForKey:@"deleted"];
    play.sub_tenant_id = [ACTDict objectForKey:@"created_at"];
    play.day = [ACTDict objectForKey:@"updated_at"];
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
