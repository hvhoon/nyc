//
//  SocAnnotation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocAnnotation.h"
#import "GetPlayersClass.h"
@implementation SocAnnotation
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize mIsTrophy;
@synthesize _socAnnotation;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate annotationObject:(GetPlayersClass*)annotationObject{
    if ((self = [super init])) {
		
		_name = [name copy];
        _socAnnotation=annotationObject;
        _address = [address copy];
		
		_coordinate = coordinate;
        
    }
    return self;
}
- (NSString *)title {
    return _name;
}
- (NSString *)subtitle {
    return _address;
}
- (void)dealloc{
    [_name release];
	[_address release];
    [_socAnnotation release];
    [super dealloc];
}


@end
