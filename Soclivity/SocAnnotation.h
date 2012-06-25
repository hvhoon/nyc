//
//  SocAnnotation.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class InfoActivityClass;
@interface SocAnnotation : NSObject<MKAnnotation>{
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
	bool mIsTrophy;
    InfoActivityClass *_socAnnotation;
    CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;

}
@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic,retain)InfoActivityClass *_socAnnotation;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) bool mIsTrophy;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate annotationObject:(InfoActivityClass*)annotationObject;

@end
