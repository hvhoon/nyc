//
//  EventsMapView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventsMapView.h"
#import "GetPlayersClass.h"
#import "SocAnnotation.h"
#import "CalloutMapAnnotationView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface EventsMapView()

@property (nonatomic, retain) SocAnnotation *calloutAnnotation;
@property (nonatomic, retain) SocAnnotation *customAnnotation;

@end

@implementation EventsMapView
@synthesize mapView, mapAnnotations;
@synthesize calloutAnnotation = _calloutAnnotation;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize customAnnotation = _customAnnotation;

#pragma mark -

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}
- (void)dealloc {
    [mapView release];
    [mapAnnotations release];
    
    [super dealloc];
}
- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = currentCoord.latitude;
    newRegion.center.longitude = currentCoord.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [self.mapView setRegion:newRegion animated:YES];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    LocationCustomManager *SocLocation=[[LocationCustomManager alloc]init];
    SocLocation.delegate=self;
    SocLocation.theTag=kOnlyLatLong;

    self.mapView.mapType = MKMapTypeStandard;
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
}

-(void)currentLocation:(CLLocationCoordinate2D)theCoord{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = theCoord.latitude;
    theCoordinate.longitude =theCoord.longitude;
    currentCoord=theCoordinate;
    GetPlayersClass *myPlayers=[[GetPlayersClass alloc]init];
    SocAnnotation *sfAnnotation = [[[SocAnnotation alloc] initWithName:@"Current Location" address:@"Soclivity" coordinate:theCoordinate annotationObject:myPlayers] autorelease];
    [self.mapAnnotations insertObject:sfAnnotation atIndex:0];
    [sfAnnotation release];
    
    
    [self gotoLocation];
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:0]];

}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
#if 1    
	if ([view.annotation isKindOfClass:[SocAnnotation class]]) {
		if (self.calloutAnnotation == nil) {
            GetPlayersClass *myPlayers=[[GetPlayersClass alloc]init];

			self.calloutAnnotation = [[[SocAnnotation alloc] initWithName:@"Current Location" address:@"Soclivity" coordinate:currentCoord annotationObject:myPlayers] autorelease];
		} else {
			self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
			self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
		}
		[self.mapView addAnnotation:self.calloutAnnotation];
		self.selectedAnnotationView = view;
	}
#endif   
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	if (self.calloutAnnotation && view.annotation == self.customAnnotation) {
		[self.mapView removeAnnotation: self.calloutAnnotation];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
#if 1   
	if (annotation == self.calloutAnnotation){
		CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
		if (!calloutMapAnnotationView) {
			calloutMapAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation 
                reuseIdentifier:@"CalloutAnnotation"] autorelease];
			calloutMapAnnotationView.contentHeight = 58.0f;
			UIImage *asynchronyLogo = [UIImage imageNamed:@"S04_rightarrow.png"];
			UIImageView *asynchronyLogoView = [[[UIImageView alloc] initWithImage:asynchronyLogo] autorelease];
			asynchronyLogoView.frame = CGRectMake(50, 20, asynchronyLogoView.frame.size.width, asynchronyLogoView.frame.size.height);
			[calloutMapAnnotationView.contentView addSubview:asynchronyLogoView];
		}
		calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
		calloutMapAnnotationView.mapView = self.mapView;
		return calloutMapAnnotationView;
	}
    
 else if ([annotation isKindOfClass:[SocAnnotation class]]) {
    MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
    reuseIdentifier:@"CustomAnnotation"] autorelease];
     annotationView.canShowCallout = NO;
     UIImage *flagImage = [UIImage imageNamed:@"S04_locationred.png"];
     annotationView.image = flagImage;
     annotationView.opaque = NO;
    return annotationView;
}

	return nil;
#endif    
}


@end
