//
//  ActivityAnnotation.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityAnnotation.h"

@implementation ActivityAnnotation
@synthesize image;
@synthesize latitude;
@synthesize longitude;
@synthesize businessAdress;
@synthesize infoActivity,annotTag;
- (CLLocationCoordinate2D)coordinate;
{
    return _coordinate; 
}

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate tagIndex:(NSInteger)tagIndex{
    if ((self = [super init])) {
		
		businessAdress = [name copy];
        infoActivity = [address copy];
		annotTag=tagIndex;
		_coordinate = coordinate;
        
    }
    return self;
}
- (void)dealloc
{
    [image release];
    [super dealloc];
}

- (NSString *)title
{
    return businessAdress;
}

// optional
- (NSString *)subtitle
{
    return infoActivity;
}

@end
