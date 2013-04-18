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
@synthesize streetNumber,adminLevel1,adminLevel2,whereZip,route,addType,queryName,formattedPhNo,address,fsqrUrl,moreInfoAvailable,category,ratingValue,foursquareId;
-(void)dealloc{
    [super dealloc];
    [formattedAddress release];
    [vicinityAddress release];
    [streetNumber release];
    [adminLevel1 release];
    [adminLevel2 release];
    [whereZip release];
    [route release];
    [queryName release];
    [formattedPhNo release];
    [address release];
    [fsqrUrl release];
    [category release];
    [ratingValue release];
    [foursquareId release];
}
@end
