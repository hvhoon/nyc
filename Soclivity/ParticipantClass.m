//
//  ParticipantClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticipantClass.h"

@implementation ParticipantClass
@synthesize photoUrl,profilePhotoImage,name,NSInteger;

-(void)dealloc{
    [super dealloc];
    [photoUrl release];
    [profilePhotoImage release];
    [name release];
}
@end
