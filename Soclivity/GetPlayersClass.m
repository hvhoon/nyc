//
//  GetPlayersClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPlayersClass.h"

@implementation GetPlayersClass
@synthesize birth_date;
@synthesize created_at;
@synthesize email;
@synthesize first_name;
@synthesize idSoc;
@synthesize last_name;
@synthesize updated_at;
@synthesize password;
@synthesize password_confirmation;
@synthesize profileImageData;
@synthesize gender;
@synthesize activityTypes;
@synthesize password_status;
@synthesize status;
@synthesize statusMessage;
@synthesize FBProfileImage;
@synthesize fullName;
@synthesize facebookUId;
@synthesize facebookAccessToken;
@synthesize registered;
@synthesize profileImageUrl;
@synthesize channel;
@synthesize badgeCount;
@synthesize calendarSync;
@synthesize fbAccessToken;
@synthesize DDActivityTypes;
-(void)dealloc{
    [super dealloc];
    [birth_date release];
    [created_at release];
    [email release];
    [fullName release];
    [first_name release];
    [idSoc release];
    [last_name release];
    [updated_at release];
    [password release];
    [password_confirmation release];
    [profileImageData release];
    [gender release];
    [activityTypes release];
    [password_status release];
    [statusMessage release];
    [FBProfileImage release];
    [facebookUId release];
    [facebookAccessToken release];
    [profileImageUrl release];
    [channel release];
    [fbAccessToken release];
    [DDActivityTypes release];
}
@end
