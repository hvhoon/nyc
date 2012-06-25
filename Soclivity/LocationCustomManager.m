//
//  LocationCustomManager.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationCustomManager.h"
#import "SoclivityManager.h"
@implementation LocationCustomManager

@synthesize delegate,locationManager,bestEffortAtLocation,theTag;

-(id)init{
    
    self = [super init];
    
    if (self) {

    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    successGeo=FALSE;
    
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
        locationManager.desiredAccuracy=kCLLocationAccuracyThreeKilometers; //kCLLocationAccuracyBest;
    if(!CLLocationManager.locationServicesEnabled)
	{
		
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Switch On the Location Services on Your Device"
														message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
		
	}
    else{
        
    
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:30.0f];
    
    }
    }
    return self;

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // store all of the measurements, just so we can see what kind of data we might receive
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"

        self.bestEffortAtLocation = newLocation;
        SoclivityManager *SocInfo=[SoclivityManager SharedInstance];
        
        SocInfo.currentLocation=newLocation;

        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
    // update the display with the new location data
    ;    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
        //the user did'nt allow to access the location
    }
}


- (void)stopUpdatingLocation:(NSString *)state{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    NSLog(@"Latiude=%f",bestEffortAtLocation.coordinate.latitude);
    NSLog(@"Longitude=%f",bestEffortAtLocation.coordinate.longitude);

      
    if(!successGeo &&(theTag==kLatLongAndActivities) &&(bestEffortAtLocation.coordinate.latitude!=0.0f && bestEffortAtLocation.coordinate.longitude!=0.0f)){
        successGeo=TRUE;
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = bestEffortAtLocation.coordinate.latitude;
        theCoordinate.longitude =bestEffortAtLocation.coordinate.longitude;
        [delegate currentLocation:theCoordinate];

    }
    else if(!successGeo &&(theTag==kOnlyLatLong) &&(bestEffortAtLocation.coordinate.latitude!=0.0f && bestEffortAtLocation.coordinate.longitude!=0.0f)){
        
        successGeo=TRUE;
        [delegate currentGeoUpdate];
    }
    else if(theTag==kNoLocation){    
    
    if(bestEffortAtLocation.coordinate.latitude!=0.0f && bestEffortAtLocation.coordinate.longitude!=0.0f){
        
    
    CLGeocoder * clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:bestEffortAtLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            //NSString *city=[placemark.addressDictionary objectForKey:@"City"];
            NSLog(@"placemark.city=%@",[placemark.addressDictionary objectForKey:@"City"]);
            NSLog(@"placemark.country=%@",placemark.country);
             NSLog(@"placemark.subThoroughfare=%@",placemark.subThoroughfare);
             NSLog(@"placemark.locality=%@",placemark.locality);
             NSLog(@"placemark.subLocality=%@",placemark.subLocality);
             NSLog(@"placemark.administrativeArea=%@",placemark.administrativeArea);
             NSLog(@"placemark.subAdministrativeArea=%@",placemark.subAdministrativeArea);
             NSLog(@"placemark.inlandWater=%@",placemark.inlandWater);
             NSLog(@"placemark.ocean=%@",placemark.ocean);

            for(id object in placemark.areasOfInterest){
                
                NSLog(@"location is=%@",object);
            }
            if(theTag==kNoLocation){
                NSDictionary *states = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"AL", @"Alabama", 
                                        @"AK", @"Alaska",
                                        @"AZ", @"Arizona",
                                        @"AR", @"Arkansas",
                                        @"CA", @"California",
                                        @"CO", @"Colorado", 
                                        @"CT", @"Connecticut", 
                                        @"DE", @"Delaware",
                                        @"DC", @"District of Columbia",
                                        @"FL", @"Florida", 
                                        @"GA", @"Georgia", 
                                        @"HI", @"Hawaii", 
                                        @"ID", @"Idaho", 
                                        @"IL", @"Illinois", 
                                        @"IN", @"Indiana", 
                                        @"IA", @"Iowa", 
                                        @"KS", @"Kansas", 
                                        @"KY", @"Kentucky", 
                                        @"LA", @"Louisiana", 
                                        @"ME", @"Maine", 
                                        @"MD", @"Maryland", 
                                        @"MA", @"Massachusetts", 
                                        @"MI", @"Michigan", 
                                        @"MN", @"Minnesota", 
                                        @"MS", @"Mississippi", 
                                        @"MO", @"Missouri", 
                                        @"MT", @"Montana", 
                                        @"NE", @"Nebraska", 
                                        @"NV", @"Nevada", 
                                        @"NH", @"New Hampshire", 
                                        @"NJ", @"New Jersey", 
                                        @"NM", @"New Mexico", 
                                        @"NY", @"New York", 
                                        @"NC", @"North Carolina", 
                                        @"ND", @"North Dakota", 
                                        @"OH", @"Ohio", 
                                        @"OK", @"Oklahoma", 
                                        @"OR", @"Oregon", 
                                        @"PA", @"Pennsylvania", 
                                        @"RI", @"Rhode Island", 
                                        @"SC", @"South Carolina", 
                                        @"SD", @"South Dakota", 
                                        @"TN", @"Tennessee", 
                                        @"TX", @"Texas", 
                                        @"UT", @"Utah", 
                                        @"VT", @"Vermont", 
                                        @"VA", @"Virginia", 
                                        @"WA", @"Washington", 
                                        @"WV", @"West Virginia", 
                                        @"WI", @"Wisconsin", 
                                        @"WY", @"Wyoming",
                                        nil];
                
                NSString *stateAbbreviation = [states objectForKey:placemark.administrativeArea];
                NSString *locString=[NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary objectForKey:@"City"],stateAbbreviation];
             [delegate  LocationAcquired:locString];

            }
        } 
        
    }];
        [clGeoCoder release];
    }
    else{
        [delegate  LocationAcquired:@"Not Available"];
    }
    
    }
    
}



@end
