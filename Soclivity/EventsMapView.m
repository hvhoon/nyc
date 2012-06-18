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
#import "SoclivityUtilities.h"
#import "InfoActivityClass.h"
#import "MapActivityClass.h"
#import "DetailInfoActivityClass.h"
@interface EventsMapView()

@property (nonatomic, retain) SocAnnotation *calloutAnnotation;
@property (nonatomic, retain) SocAnnotation *customAnnotation;

@end

@implementation EventsMapView
@synthesize mapView;
@synthesize calloutAnnotation = _calloutAnnotation;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize customAnnotation = _customAnnotation;
@synthesize plays,delegate,mapAnnotations;
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
    //[self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    [super dealloc];
}
- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = currentCoord.latitude;
    newRegion.center.longitude = currentCoord.longitude;
    newRegion.span.latitudeDelta = 0.04;
    newRegion.span.longitudeDelta = 0.04;
    
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
    //[self.mapView setShowsUserLocation:YES];
    self.mapView.showsUserLocation=YES;
    /*[self.mapView.userLocation addObserver:self  
                                forKeyPath:@"location"  
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
                                   context:NULL];*/
}

- (void)observeValueForKeyPath:(NSString *)keyPath  
                      ofObject:(id)object  
                        change:(NSDictionary *)change  
                       context:(void *)context {  
     NSLog(@"observeValueForKeyPath");
    if ([self.mapView showsUserLocation]) {  
        NSLog(@"observeValueForKeyPath for showsUserLocation");
        // and of course you can use here old and new location values
    }
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation      {
    CLLocationAccuracy accuracy = userLocation.location.horizontalAccuracy;
    if (accuracy) {
        NSLog(@"didUpdateUserLocation");
        //self.mapView.showsUserLocation=NO;

    } 
}
-(void)setUpMapAnnotations{
    int index=0;
     [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:[self.plays count]];
    for (InfoActivityClass *play in self.plays){
        
        if([SoclivityUtilities ValidActivityDate:play.dateFormatterString]){
    if([SoclivityUtilities validFilterActivity:play.type]){
        
        if([SoclivityUtilities DoTheTimeLogic:play.dateFormatterString]){
            
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = [play.latitude doubleValue];
        theCoordinate.longitude =[play.longitude doubleValue];
        play.stamp=index;
        SocAnnotation *sfAnnotation = [[SocAnnotation alloc] initWithName:@" " address:@" " coordinate:theCoordinate annotationObject:play];
        [self.mapAnnotations insertObject:sfAnnotation atIndex:index];
        
            index++;
        }
    }
    }
        
    }
    for(SocAnnotation *sfAnn in self.mapAnnotations)
       [self.mapView addAnnotation:sfAnn];
        
}
-(void)currentLocation:(CLLocationCoordinate2D)theCoord{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = theCoord.latitude;
    theCoordinate.longitude =theCoord.longitude;
    currentCoord=theCoordinate;
    [self gotoLocation];
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    self.plays=[SoclivityUtilities getPlayerActivities];
    [self setUpMapAnnotations];
}

-(void)doFilteringByActivities{
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    [self setUpMapAnnotations];

}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
#if 0    
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
			UIImage *asynchronyLogo = [UIImage imageNamed:@"S02.1_rightarrow.png"];
			UIImageView *asynchronyLogoView = [[[UIImageView alloc] initWithImage:asynchronyLogo] autorelease];
			asynchronyLogoView.frame = CGRectMake(50, 20, asynchronyLogoView.frame.size.width, asynchronyLogoView.frame.size.height);
			[calloutMapAnnotationView.contentView addSubview:asynchronyLogoView];
		}
		calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
		calloutMapAnnotationView.mapView = self.mapView;
		return calloutMapAnnotationView;
	}
    
    else if ([annotation isKindOfClass:[SocAnnotation class]]){
        static NSString* SFAnnotationIdentifier = @"SFAnnotationIdentifier";
        SocAnnotation *location = (SocAnnotation *) annotation;
        MKPinAnnotationView* pinView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        //if (!pinView)
        {
            MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:SFAnnotationIdentifier] autorelease];
            annotationView.canShowCallout = YES;
            UIImage *flagImage=nil;
            switch (location._socAnnotation.type) {
                case 1:
                {
                    flagImage=[UIImage imageNamed:@"S04_location_play.png"];
                }
                    break;
                case 2:
                {
                    flagImage=[UIImage imageNamed:@"S04_location_eat.png"];
                    
                }
                    break;
                case 3:
                {
                    flagImage=[UIImage imageNamed:@"S04_location_see.png"];
                    
                }
                    break;
                case 4:
                {
                    flagImage=[UIImage imageNamed:@"S04_location_create.png"];
                    
                }
                    break;
                case 5:
                {
                    flagImage=[UIImage imageNamed:@"S04_location_learn.png"];
                    
                }
                    break;
                    
                default:
                    break;
            }

            
            CGRect resizeRect;
            
            resizeRect.size = flagImage.size;
            CGSize maxSize = CGRectInset(self.bounds,
                                         [EventsMapView annotationPadding],
                                         [EventsMapView annotationPadding]).size;
            maxSize.height -= 44 + [EventsMapView calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [flagImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;
            annotationView.opaque = NO;
            annotationView.leftCalloutAccessoryView=[self DrawAMapLeftAccessoryView:location];
            UIButton *disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
            disclosureButton.frame = CGRectMake(0.0, 0.0, 29.0, 30.0);
            [disclosureButton setImage:[UIImage imageNamed:@"S02.1_rightarrow.png"] forState:UIControlStateNormal];
            disclosureButton.tag=location._socAnnotation.stamp;
            [disclosureButton addTarget:self action:@selector(pushTodetailActivity:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView=disclosureButton;

            return annotationView;
        }
        /*else
        {
            pinView.annotation = annotation;
        }*/
        return pinView;
    }
    
   else if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

	return nil;
#endif    
}

-(UIView*)DrawAMapLeftAccessoryView:(SocAnnotation *)locObject{
	
	UIView *mapLeftView=[[UIView alloc] initWithFrame:CGRectMake(0,0, 150, 30)];
	
	CGRect nameLabelRect=CGRectMake(10,0,140,15);
	UILabel *nameLabel=[[UILabel alloc] initWithFrame:nameLabelRect];
	nameLabel.textAlignment=UITextAlignmentLeft;
	nameLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
	nameLabel.textColor=[UIColor whiteColor];
	nameLabel.backgroundColor=[UIColor clearColor];
	nameLabel.text=[locObject._socAnnotation activityName];
	[mapLeftView addSubview:nameLabel];
	[nameLabel release];
	
	CGRect timeLabelRect=CGRectMake(10,16,140,12);
	UILabel *timeLabel=[[UILabel alloc] initWithFrame:timeLabelRect];
	timeLabel.textAlignment=UITextAlignmentLeft;
	timeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
	timeLabel.textColor=[UIColor whiteColor];
	timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.text=[locObject._socAnnotation dateAndTime];
    [mapLeftView addSubview:timeLabel];
	[timeLabel release];
	
	
	return mapLeftView;
	
	
}

- (void)locationUpdate:(CLLocation *)location {
    
    NSLog(@"locationUpdate");
    [mapView setCenterCoordinate:location.coordinate];
    if ([mapView showsUserLocation] == NO) {
        [mapView setShowsUserLocation:YES];
    }
}
-(void)pushTodetailActivity:(UIButton*)sender{
    SocAnnotation *detailAnnotation=[self.mapAnnotations objectAtIndex:[sender tag]];
    [delegate PushToDetailActivityView:detailAnnotation._socAnnotation];

}
@end
