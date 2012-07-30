//
//  PlacemarkClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacemarkClass.h"

@implementation PlacemarkClass
@synthesize longitude,latitude,vicinityAddress,formattedAddress;

-(void)dealloc{
    [super dealloc];
    [formattedAddress release];
    [vicinityAddress release];
}
@end
