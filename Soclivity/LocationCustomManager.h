//
//  LocationCustomManager.h
//  Xling
//
//  Created by Kanav Gupta on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol CoreLocationDelegate <NSObject>

@optional
-(void)LocationAcquired:(NSString*)SoclivityLoc;
-(void)TagNearbyLocations:(NSMutableArray*)tagLocationsArray;
@end

@interface LocationCustomManager : NSObject<CLLocationManagerDelegate>{
    
    id<CoreLocationDelegate>delegate;
    CLLocationManager *locationManager;
    CLLocation *bestEffortAtLocation;
    NSInteger theTag;


    
}
@property (nonatomic,retain) id<CoreLocationDelegate>delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;
@property (nonatomic,assign) NSInteger theTag;
- (void)stopUpdatingLocation:(NSString *)state;
@end
