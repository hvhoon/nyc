//
//  ActivityAnnotation.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class PlacemarkClass;
@interface ActivityAnnotation : NSObject<MKAnnotation>{
    NSInteger annotTag;
    BOOL pinDrop;
    NSInteger searchType;
    PlacemarkClass *annotation;
    CLLocationCoordinate2D _coordinate;
}
@property (nonatomic,assign)NSInteger annotTag;
@property (nonatomic,assign)BOOL pinDrop;
@property (nonatomic,assign)BOOL IsMoreInfo;
@property (nonatomic,assign)CLLocationCoordinate2D _coordinate;

@property(nonatomic,retain)PlacemarkClass*annotation;
- (id)initWithAnnotation:(PlacemarkClass*)mapPin tag:(NSInteger)tag pin:(BOOL)isDropped;
@end
