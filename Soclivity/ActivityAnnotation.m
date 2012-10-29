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

@synthesize infoActivity,annotTag,firstLineAddress,secondLineAddress,pinDrop;
- (CLLocationCoordinate2D)coordinate;
{
    return _coordinate; 
}

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate firtsLine:(NSString*)firtsLine secondLine: (NSString*)secondLine tagIndex:(NSInteger)tagIndex isDropped:(BOOL)isDropped{
    if ((self = [super init])) {
		
		businessAdress = [name copy];
        infoActivity = [address copy];
		annotTag=tagIndex;
		_coordinate = coordinate;
        firstLineAddress=[firtsLine copy];
        secondLineAddress=[secondLine copy];
        pinDrop=isDropped;
        
    }
    return self;
}
- (void)dealloc
{
    [image release];
    [firstLineAddress release];
    [secondLineAddress release];
    [businessAdress release];
    [infoActivity release];
    [super dealloc];
}

- (NSString *)title
{
    return firstLineAddress;
}

// optional
- (NSString *)subtitle
{
    return secondLineAddress;
}

@end
