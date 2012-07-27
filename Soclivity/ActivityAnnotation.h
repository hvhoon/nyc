//
//  ActivityAnnotation.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ActivityAnnotation : NSObject<MKAnnotation>{
    UIImage *image;
    NSNumber *latitude;
    NSNumber *longitude;
    NSString *businessAdress;
    NSString *infoActivity;
    CLLocationCoordinate2D _coordinate;
    NSInteger annotTag;
}
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property   (nonatomic, retain) NSString *businessAdress;
@property   (nonatomic, retain) NSString *infoActivity;
@property (nonatomic,assign)NSInteger annotTag;
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate tagIndex:(NSInteger)tagIndex;
@end
