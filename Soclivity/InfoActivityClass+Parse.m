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
#import "SoclivityManager.h"
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
    NSNumber *activityId = [ACTDict objectForKey:@"id"];
    play.activityId =[activityId intValue];
    NSNumber *ownerId = [ACTDict objectForKey:@"ownnerid"];
    play.organizerId =[ownerId intValue];
    play.updated_at=[ACTDict objectForKey:@"updated_at"];
    play.when=[ACTDict objectForKey:@"when"];
    play.where_address=[ACTDict objectForKey:@"where_address"];
    play.where_lat=[ACTDict objectForKey:@"where_lat"];
    play.where_lng=[ACTDict objectForKey:@"where_lng"];
    NSNumber *distance = [ACTDict objectForKey:@"Distance"];
    play.distance=[NSString stringWithFormat:@"%.02f",[distance doubleValue]];
    NSNumber *dosOwner = [ACTDict objectForKey:@"dos0"];
    play.DOS =[dosOwner intValue];
    play.organizerName=[ACTDict objectForKey:@"ownername"];
    NSNumber *dos1 = [ACTDict objectForKey:@"dos1"];
    play.DOS1 =[dos1 intValue];
    NSNumber *dos2 = [ACTDict objectForKey:@"dos2"];
    play.DOS2 =[dos2 intValue];
    NSNumber *dos3 = [ACTDict objectForKey:@"dos3"];
    play.DOS3 =[dos3 intValue];



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


+(InfoActivityClass*) DetailInfoParse:(NSDictionary*)ACTDict{
	if (!ACTDict) {
		return Nil;
	}
	
	InfoActivityClass *play = [[[InfoActivityClass alloc] init] autorelease];   
    play.activityName = [ACTDict objectForKey:@"name"];
    NSNumber *type = [ACTDict objectForKey:@"atype"];
    play.type =[type intValue];
    play.access = [ACTDict objectForKey:@"access"];
    NSNumber *numberOfPeople = [ACTDict objectForKey:@"num_of_people"];
    play.num_of_people =[numberOfPeople intValue];
    NSNumber *activityId = [ACTDict objectForKey:@"id"];
    play.activityId =[activityId intValue];
    NSNumber *ownerId = [ACTDict objectForKey:@"ownnerid"];
    play.organizerId =[ownerId intValue];
    play.updated_at=[ACTDict objectForKey:@"updated_at"];
    play.created_at=[ACTDict objectForKey:@"created_at"];
    play.what=[ACTDict objectForKey:@"what"];
    play.when=[ACTDict objectForKey:@"when"];
    play.where_address=[ACTDict objectForKey:@"where_address"];
    play.where_state=[ACTDict objectForKey:@"where_state"];
    play.where_zip=[ACTDict objectForKey:@"where_zip"];
    play.where_city=[ACTDict objectForKey:@"where_city"];
    play.where_lat=[ACTDict objectForKey:@"where_lat"];
    play.where_lng=[ACTDict objectForKey:@"where_lng"];
    NSString *photoUrl=[ACTDict objectForKey:@"owner_photo"];
    play.ownerProfilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",photoUrl];
    NSString*relation=[ACTDict objectForKey:@"ura_member"];
    
    if([relation isEqualToString:@"yes"]){
        play.isParticipant=TRUE;
    }
    else{
         play.isParticipant=FALSE;
    }
    
#if 1        
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    CLLocationDegrees latitude  = [play.where_lat  doubleValue];
    CLLocationDegrees longitude = [play.where_lng  doubleValue];
    CLLocation *tempLocObj = [[CLLocation alloc] initWithLatitude:latitude
                                                        longitude:longitude];
    
    CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:SOC.currentLocation.coordinate.latitude
                                                       longitude:SOC.currentLocation.coordinate.longitude];
    
    play.distance =[NSString stringWithFormat:@"%.02f miles",[newCenter distanceFromLocation:tempLocObj] / 1000];
#endif            

    //NSNumber *distance =[ACTDict objectForKey:@"Distance"];
    //play.distance=[NSString stringWithFormat:@"%.02f",[distance doubleValue]];
    NSNumber *dosOwner = [ACTDict objectForKey:@"dos0"];
    play.DOS =[dosOwner intValue];
    play.organizerName=[ACTDict objectForKey:@"owner_name"];
    NSNumber *dos1 = [ACTDict objectForKey:@"dos1"];
    play.DOS1 =[dos1 intValue];
    NSNumber *dos2 = [ACTDict objectForKey:@"dos2"];
    play.DOS2 =[dos2 intValue];
    NSNumber *dos3 = [ACTDict objectForKey:@"dos3"];
    play.DOS3 =[dos3 intValue];
    
    
	return play;
    
}


@end
