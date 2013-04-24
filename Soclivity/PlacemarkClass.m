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
@synthesize streetNumber,where_city,where_state,where_zip,route,addType,queryName,formattedPhNo,address,fsqrUrl,moreInfoAvailable,category,ratingValue,foursquareId,phoneNumber;
-(void)dealloc{
    [super dealloc];
    [formattedAddress release];
    [vicinityAddress release];
    [streetNumber release];
    [where_city release];
    [where_state release];
    [where_zip release];
    [route release];
    [queryName release];
    [formattedPhNo release];
    [address release];
    [fsqrUrl release];
    [category release];
    [ratingValue release];
    [foursquareId release];
    [phoneNumber release];
}
@end
