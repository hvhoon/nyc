//
//  SocPlayerClass+Parse.m
//  Soclivity
//
//  Created by Kanav on 11/3/12.
//
//

#import "SocPlayerClass+Parse.h"
#import "JSON.h"
#import "InviteObjectClass.h"
@implementation SocPlayerClass (Parse)


+(SocPlayerClass*)GetUserProfileInfoAndCommonFriends:(NSDictionary*)ACTDict{
	if (!ACTDict) {
		return Nil;
	}
	
    
	SocPlayerClass *play = [[[SocPlayerClass alloc] init] autorelease];
    
    NSArray *friendsArray=[ACTDict objectForKey:@"friends"];
    NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
    for(id friend in friendsArray){
        
        
            
            InviteObjectClass *play = [[InviteObjectClass alloc] init];
            play.userName = [friend objectForKey:@"first_name"];
            NSNumber * n = [friend objectForKey:@"typeOfRelation"];
            play.typeOfRelation= [n intValue];
            NSNumber * DOS = [friend objectForKey:@"DOS"];
            play.DOS= [DOS intValue];
            play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"profilePhotoUrl"]];
            
            
            [entries addObject:play];
        
    }
    if([entries count]>0){
       play.commonFriends=entries;
       play.isCommon=YES;
    }
    else{
     play.isCommon=NO;
    }
    return play;
    
}

+(SocPlayerClass*)GetUserProfileInfoActivityPlusCommonFriends:(NSDictionary*)ACTDict{
	if (!ACTDict) {
		return Nil;
	}
	SocPlayerClass *play = [[[SocPlayerClass alloc] init] autorelease];
	
    NSDictionary *rsp=[ACTDict objectForKey:@"rsp"];
    NSArray *friend1=[rsp objectForKey:@"friend"];
    for(NSDictionary * friend in friend1){
    NSNumber * n = [friend objectForKey:@"id"];
    play.friendId= [n intValue];
    play.DOS=[[friend objectForKey:@"dos"]integerValue];
    play.playerName=[friend objectForKey:@"name"];
    play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"profile_photo"]];
    play.fbUid=[friend objectForKey:@"fbuid"];
    NSDictionary *lastActivity=[friend objectForKey:@"last_activity"];
    if(lastActivity!=nil && [lastActivity class]!=[NSNull class]){
        play.activityId=[[lastActivity objectForKey:@"id"]integerValue];
        play.activityTime=[lastActivity objectForKey:@"when"];
        play.latestActivityName=[lastActivity objectForKey:@"name"];
        play.activityType=[[lastActivity objectForKey:@"atype"]integerValue];
        
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        CLLocationDegrees latitude  = [[lastActivity objectForKey:@"where_lat"]  doubleValue];
        CLLocationDegrees longitude = [[lastActivity objectForKey:@"where_lng"]  doubleValue];
        CLLocation *tempLocObj = [[CLLocation alloc] initWithLatitude:latitude
                                                            longitude:longitude];
        
        CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:SOC.currentLocation.coordinate.latitude
                                                           longitude:SOC.currentLocation.coordinate.longitude];
        
        play.distance =[[NSString stringWithFormat:@"%.02f",[newCenter distanceFromLocation:tempLocObj] / 1000]floatValue];
        
        
        

    }
    }
    
    NSArray *friendsArray=[rsp objectForKey:@"common_friends"];
    NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
    for(id friend in friendsArray){
        
        
        
        InviteObjectClass *play = [[InviteObjectClass alloc] init];
        NSNumber * n = [friend objectForKey:@"id"];
        play.inviteId= [n intValue];

        play.userName = [friend objectForKey:@"name"];
        play.typeOfRelation= 5;
        NSNumber * DOS = [friend objectForKey:@"dos"];
        play.DOS= [DOS intValue];
        if([[friend objectForKey:@"status"]isEqualToString:@"On Soclivity"]){
        play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"photo"]];
        play.isOnFacebook=FALSE;
        }
        else{
            play.profilePhotoUrl=[NSString stringWithFormat:@"%@",[friend objectForKey:@"photo"]];
            play.isOnFacebook=TRUE;
            
        }
        
        [entries addObject:play];
        
    }
    if([entries count]>0){
        play.commonFriends=entries;
        play.isCommon=YES;
    }
    else{
        play.isCommon=NO;
    }
    return play;
    
}


@end
