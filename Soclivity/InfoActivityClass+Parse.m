//
//  InfoActivityClass+Parse.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoActivityClass+Parse.h"
#import "JSON.h"
#import "SoclivityManager.h"
#import "ParticipantClass.h"
#import "GetPlayersClass.h"
#import "DetailInfoActivityClass.h"
@implementation InfoActivityClass (Parse)


+(InfoActivityClass*) ActivitiesFromDictionary:(NSDictionary*)ACTDict isQuotation:(BOOL)isQuotation{
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
    
    if(isQuotation){
        
    NSNumber *distance = [ACTDict objectForKey:@"distance"];
    play.distance=[NSString stringWithFormat:@"%.02f",[distance doubleValue]];
    NSNumber *dos1 = [ACTDict objectForKey:@"dos1count"];
    play.DOS1 =[dos1 intValue];
    NSNumber *dos2 = [ACTDict objectForKey:@"dos2count"];
    play.DOS2 =[dos2 intValue];
    NSNumber *dos3 = [ACTDict objectForKey:@"dos3count"];
    play.DOS3 =[dos3 intValue];
        
    play.organizerName=[ACTDict objectForKey:@"organizer"];

    NSNumber *dosOwner = [ACTDict objectForKey:@"dosRelation"];
    play.DOS =[dosOwner intValue];

    DetailInfoActivityClass *quotation = [[[DetailInfoActivityClass alloc] init]autorelease];
    quotation.location = [NSString stringWithFormat:@"%@",play.where_address];
    play.goingCount=[NSString stringWithFormat:@"%d",play.DOS1+play.DOS2+play.DOS3];
    
    NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:1];
    quotation.DOS_1=play.DOS1;
    quotation.DOS_2=play.DOS2;
    [quotations addObject:quotation];
    play.quotations = quotations;
    }

   return play;
    
}
+(NSArray*) ActivitiesFromArray:(NSArray*) ActivitiesSchedulesAt{
	if (!ActivitiesSchedulesAt) {
		return Nil;
	}
	
	NSMutableArray *schedules = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < ActivitiesSchedulesAt.count; i++) {
        
        InfoActivityClass *sch = [InfoActivityClass ActivitiesFromDictionary:[ActivitiesSchedulesAt objectAtIndex:i] isQuotation:NO];
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
    
    NSLog(@"ACTDict::%@",ACTDict);
	
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
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    GetPlayersClass *player=SOC.loggedInUser;
    if([player.idSoc intValue]==[ownerId intValue]){
        play.activityRelationType=6;
    }

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
    play.btnstate=[ACTDict objectForKey:@"btnstate"];    
    
    
    if([play.btnstate isEqualToString:@"join"]){
        play.activityRelationType=1;
        
    }
    else if([play.btnstate isEqualToString:@"cancel"]){
        play.activityRelationType=2;
        
    }
    
    else if([play.btnstate isEqualToString:@"gng"]){
        play.activityRelationType=4;
        
    }
    
    else if([play.btnstate isEqualToString:@"leave"]){
        play.activityRelationType=5;
        
    }

    else if([play.btnstate isEqualToString:@"edit"]){
        play.activityRelationType=6;

    }
    
    
    NSString *photoUrl=[ACTDict objectForKey:@"owner_photo"];
    play.ownerProfilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",photoUrl];
    NSString*relation=[ACTDict objectForKey:@"ura_member"];
    
    if([relation isEqualToString:@"yes"]){
        play.isParticipant=TRUE;
    }
    else{
         play.isParticipant=FALSE;
    }
    
    
    NSArray*friendsArray =[ACTDict objectForKey:@"friends"];
    NSMutableArray *DOS1Array=[NSMutableArray new];

    for(id obj in friendsArray){
        ParticipantClass *pObject=[[[ParticipantClass alloc]init]autorelease];
        NSNumber *participantId = [obj objectForKey:@"id"];
        pObject.participantId=[participantId intValue];
        pObject.dosConnection=1;
        pObject.name=[obj objectForKey:@"name"];
        pObject.photoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[obj objectForKey:@"photo"]];
        [DOS1Array addObject:pObject];
        
    }
    if([DOS1Array count]>0){
        play.friendsArray=DOS1Array; 
    }

    NSArray *friendsOfFriends=[ACTDict objectForKey:@"friendsoffriends"];
    NSMutableArray *DOS2Array=[NSMutableArray new];
    
    for(id object in friendsOfFriends){
        ParticipantClass *pObject=[[[ParticipantClass alloc]init]autorelease];
        NSNumber *participantId = [object objectForKey:@"id"];
        pObject.participantId=[participantId intValue];
        pObject.dosConnection=2;
        pObject.name=[object objectForKey:@"name"];
        pObject.photoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[object objectForKey:@"photo"]];
        [DOS2Array addObject:pObject];
        
    }
    if([DOS2Array count]>0){
        play.friendsOfFriendsArray=DOS2Array; 
    }
    
    NSArray *pending_membersArray=[ACTDict objectForKey:@"members_pending"];
    NSMutableArray *pendingMembersArray=[NSMutableArray new];
    
    for(id object in pending_membersArray){
        ParticipantClass *pObject=[[[ParticipantClass alloc]init]autorelease];
        NSNumber *participantId = [object objectForKey:@"id"];
        pObject.participantId=[participantId intValue];
        NSNumber *dos = [object objectForKey:@"dos"];
        pObject.dosConnection=[dos intValue];
        pObject.name=[object objectForKey:@"name"];
        pObject.photoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[object objectForKey:@"photo"]];
        [pendingMembersArray addObject:pObject];
        
    }
    if([pendingMembersArray count]>0){
        play.pendingRequestArray=pendingMembersArray;
        play.pendingRequestCount=[pendingMembersArray count];
    }
    
    NSArray *other_friendsArray=[ACTDict objectForKey:@"other_friends"];
    NSMutableArray *DOS3FriendsArray=[NSMutableArray new];
    
    for(id object in other_friendsArray){
        ParticipantClass *pObject=[[[ParticipantClass alloc]init]autorelease];
        NSNumber *participantId = [object objectForKey:@"id"];
        pObject.participantId=[participantId intValue];
        pObject.dosConnection=3;
        pObject.name=[object objectForKey:@"name"];
        pObject.photoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[object objectForKey:@"photo"]];
        [DOS3FriendsArray addObject:pObject];
        
    }
    if([DOS3FriendsArray count]>0){
        play.otherParticipantsArray=DOS3FriendsArray;
    }


    
    
#if 0        
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    CLLocationDegrees latitude  = [play.where_lat  doubleValue];
    CLLocationDegrees longitude = [play.where_lng  doubleValue];
    CLLocation *tempLocObj = [[CLLocation alloc] initWithLatitude:latitude
                                                        longitude:longitude];
    
    CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:SOC.currentLocation.coordinate.latitude
                                                       longitude:SOC.currentLocation.coordinate.longitude];
    
    play.distance =[NSString stringWithFormat:@"%.02f",[newCenter distanceFromLocation:tempLocObj] / 1000];
            

    
#else
    NSNumber *distance =[ACTDict objectForKey:@"distance"];
    play.distance=[NSString stringWithFormat:@"%.02f",[distance doubleValue]];
 #endif   
    NSNumber *dosOwner = [ACTDict objectForKey:@"dos0"];
    play.DOS =[dosOwner intValue];
    play.organizerName=[ACTDict objectForKey:@"owner_name"];
    NSNumber *dos1 = [ACTDict objectForKey:@"dos1"];
    play.DOS1 =[dos1 intValue];
    NSNumber *dos2 = [ACTDict objectForKey:@"dos2"];
    play.DOS2 =[dos2 intValue];
    NSNumber *dos3 = [ACTDict objectForKey:@"dos3"];
    play.DOS3 =[dos3 intValue];
    
    play.goingCount=[NSString stringWithFormat:@"%d",play.DOS1+play.DOS2+play.DOS3];
    
 
    return play;
    
}

+(NSArray*)GetAllActivitiesForTheUser:(NSDictionary*)ACTDict{
	if (!ACTDict) {
		return Nil;
	}
    
    
    NSMutableArray *content = [NSMutableArray new];
    
    
    NSDictionary*abDict =[ACTDict objectForKey:@"list"];
    
    
    NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableArray *schedules = [[[NSMutableArray alloc] init] autorelease];
    NSArray *myActivitiesArray=[abDict objectForKey:@"my_activities"];

    if([myActivitiesArray count]>0){
    for(id obj in myActivitiesArray){
        
        InfoActivityClass *sch = [InfoActivityClass ActivitiesFromDictionary:obj isQuotation:YES];
            if (sch)
              [schedules addObject:sch];
        
    }
    [row setValue:[NSNumber numberWithInt:1] forKey:@"activityType"];
    
    [row setValue:schedules forKey:@"Elements"];
    [content addObject:row];
    }
    
    row = [[[NSMutableDictionary alloc] init] autorelease];
    schedules = [[[NSMutableArray alloc] init] autorelease];

    NSArray *invitedToArray=[abDict objectForKey:@"invited_to"];
    if([invitedToArray count]>0){
    
    for(id obj in invitedToArray){
        InfoActivityClass *sch = [InfoActivityClass ActivitiesFromDictionary:obj isQuotation:YES];
        if (sch)
            [schedules addObject:sch];
    }
    [row setValue:[NSNumber numberWithInt:2] forKey:@"activityType"];
    
    [row setValue:schedules forKey:@"Elements"];
    [content addObject:row];
    
    }
    row = [[[NSMutableDictionary alloc] init] autorelease];
    schedules = [[[NSMutableArray alloc] init] autorelease];

    NSArray *completedArray=[abDict objectForKey:@"completed"];
    if([completedArray count]>0){
    
    for(id obj in completedArray){
        InfoActivityClass *sch = [InfoActivityClass ActivitiesFromDictionary:obj isQuotation:YES];
            if (sch)
                [schedules addObject:sch];
        }
    [row setValue:[NSNumber numberWithInt:3] forKey:@"activityType"];
    
    [row setValue:schedules forKey:@"Elements"];
    [content addObject:row];
        
    }
    
    row = [[[NSMutableDictionary alloc] init] autorelease];
    schedules = [[[NSMutableArray alloc] init] autorelease];

    NSArray *goingToArray=[abDict objectForKey:@"going_to"];
    if([goingToArray count]>0){
        
    for(id obj in goingToArray){
        InfoActivityClass *sch = [InfoActivityClass ActivitiesFromDictionary:obj isQuotation:YES];
        if (sch) 
            [schedules addObject:sch];
        }
        
    
    [row setValue:[NSNumber numberWithInt:4] forKey:@"activityType"];
  
    [row setValue:schedules forKey:@"Elements"];
    [content addObject:row];
    }

    return content;
    
}


@end
