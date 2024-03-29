//
//  EventsMapView.h
//  
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class SocAnnotation;
@class InfoActivityClass;

@protocol EventsMapViewDelegate <NSObject>

@optional
-(void)PushToDetailActivityView:(InfoActivityClass*)detailedInfo andFlipType:(NSInteger)andFlipType;
@end

@interface EventsMapView : UIView<MKMapViewDelegate,CLLocationManagerDelegate>{
    MKMapView *mapView;
	MKAnnotationView *_selectedAnnotationView;
	SocAnnotation *_customAnnotation;
    SocAnnotation *_calloutAnnotation;
    CLLocationCoordinate2D currentCoord;
    NSArray *plays;
    id <EventsMapViewDelegate>delegate;
    NSMutableArray *mapAnnotations;
    BOOL centerLocation;
    int spinnerMapIndex;

}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
@property (nonatomic,retain)NSArray *plays;
@property (nonatomic,retain)id <EventsMapViewDelegate>delegate;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;
- (void)gotoLocation;
-(void)setUpMapAnnotations;
-(UIView*)DrawAMapLeftAccessoryView:(SocAnnotation *)locObject;
-(void)pushTodetailActivity:(id)sender;
-(void)doFilteringByActivities;
- (void)findUserLocation;
-(void)spinnerCloseAndIfoDisclosureButtonUnhide;
@property(nonatomic,assign)BOOL centerLocation;
@end
