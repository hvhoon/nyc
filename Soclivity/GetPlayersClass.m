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
-(void)dealloc{
    [super dealloc];
    [birth_date release];
    [created_at release];
    [email release];
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
}
@end
