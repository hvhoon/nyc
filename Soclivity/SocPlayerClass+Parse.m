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


+(SocPlayerClass*)GetUserProfileObject:(NSDictionary*)ACTDict{
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

@end
