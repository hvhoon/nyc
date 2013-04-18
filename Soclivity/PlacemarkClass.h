//
//  PlacemarkClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlacemarkClass : NSObject{
  
    
    float latitude;
    float longitude;
    NSString*formattedAddress;
    NSString *vicinityAddress;
    NSString *streetNumber;
    NSString *route;
    NSString *adminLevel1;
    NSString *adminLevel2;
    NSString *whereZip;
    int addType;
    NSString *queryName;
    NSString *formattedPhNo;
    NSString *address;
    NSString *fsqrUrl;
    BOOL moreInfoAvailable;
    NSString *category;
    NSString *ratingValue;
    NSString*foursquareId;
}
@property (nonatomic,retain) NSString *streetNumber;
@property (nonatomic,retain)NSString *adminLevel1;
@property (nonatomic,retain)NSString *adminLevel2;
@property (nonatomic,retain)NSString *whereZip;
@property (nonatomic,retain) NSString *route;
@property (nonatomic,retain) NSString*formattedAddress;
@property (nonatomic,retain) NSString*vicinityAddress;
@property (nonatomic,assign) float latitude;
@property (nonatomic,assign) float longitude;
@property(nonatomic,assign) int addType;
@property (nonatomic,retain)NSString *queryName;
@property (nonatomic,retain)NSString *formattedPhNo;
@property (nonatomic,retain)NSString *address;
@property (nonatomic,retain)NSString *fsqrUrl;
@property (nonatomic,retain)NSString *category;
@property(nonatomic,assign) BOOL moreInfoAvailable;
@property (nonatomic,retain)NSString *ratingValue;
@property (nonatomic,retain)NSString*foursquareId;
@end
