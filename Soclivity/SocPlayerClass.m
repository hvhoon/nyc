//
//  SocPlayerClass.m
//  Soclivity
//
//  Created by Kanav on 10/1/12.
//
//

#import "SocPlayerClass.h"

@implementation SocPlayerClass
@synthesize profileImage,profilePhotoUrl,playerName,DOS,activityType,latestActivityName,distance,activityId,friendId,isCommon,isCurrentActivity,commonFriends,fbUid,activityTime;


-(void)dealloc{
    [super dealloc];
    [profileImage release];
    [profilePhotoUrl release];
    [playerName release];
    [latestActivityName release];
    [commonFriends release];
    [fbUid release];
    [activityTime release];
}
@end
