//
//  InviteObjectClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InviteObjectClass.h"

@implementation InviteObjectClass
@synthesize userName,profilePhotoUrl,profileImage,typeOfRelation,DOS,status;



-(void)dealloc{
    [super dealloc];
    [userName release];
    [profilePhotoUrl release];
    [profileImage release];
}
@end
