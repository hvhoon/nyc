//
//  EventsMapView.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class SocAnnotation;
@interface EventsMapView : UIView<MKMapViewDelegate>{
    MKMapView *mapView;
    NSMutableArray *mapAnnotations;
	MKAnnotationView *_selectedAnnotationView;
	SocAnnotation *_customAnnotation;
    SocAnnotation *_calloutAnnotation;

}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

@end
