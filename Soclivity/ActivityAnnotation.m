//
//  ActivityAnnotation.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityAnnotation.h"
#import "PlacemarkClass.h"
@implementation ActivityAnnotation
@synthesize annotTag,pinDrop,annotation,_coordinate;
- (CLLocationCoordinate2D)coordinate;
{
    return _coordinate; 
}
- (id)initWithAnnotation:(PlacemarkClass*)mapPin tag:(NSInteger)tag pin:(BOOL)isDropped{
    if ((self = [super init])) {
		
		annotTag=tag;
        
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = mapPin.latitude;
        theCoordinate.longitude = mapPin.longitude;
        annotation=[mapPin retain];
		_coordinate = theCoordinate;
        pinDrop=isDropped;
        
    }
    return self;

}
- (void)dealloc
{
    [super dealloc];
}

- (NSString *)title
{
    return @" ";
}

// optional
- (NSString *)subtitle
{
    return @" ";
}

@end
