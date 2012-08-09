//
//  AddEventView.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomSearchBar.h"
@class PlacemarkClass;
@class SoclivityManager;
@class ActivityAnnotation;
@protocol AddEventViewDelegate <NSObject>

@optional
-(void)pushToHomeViewController;
-(void)slideInTransitionToLocationView;
-(void)enableDisableTickOnTheTopRight:(BOOL)show;
@end


@interface AddEventView : UIView<MKMapViewDelegate,UISearchBarDelegate,CustomSearchBarDelegate>{
    InfoActivityClass *activityObject;
    IBOutlet UIImageView *activityBarImgView;
    IBOutlet UIImageView *activityAccessStatusImgView;
    IBOutlet UILabel*activityTextLabel;
    IBOutlet UILabel *organizerLinkLabel;
    IBOutlet UILabel*activityorganizerTextLabel;
    IBOutlet UIImageView *DOSConnectionImgView;
    id <AddEventViewDelegate>delegate;
    IBOutlet UIImageView *profileImgView;
    
    IBOutlet UILabel*calendarDateLabel;
    IBOutlet UILabel*activityTimeLabel;
    IBOutlet UILabel*locationInfoLabel1;
    IBOutlet UILabel*locationInfoLabel2;
    IBOutlet UIView *bottomView;
    IBOutlet UIImageView *calendarIcon;
    IBOutlet UIImageView *clockIcon;
    IBOutlet UIImageView *locationIcon;
    
    IBOutlet UIButton*calendarDateEditArrow;
    IBOutlet UIButton*timeEditArrow;
    IBOutlet UIButton*editMarkerButton;
    MKCoordinateRegion adjustedRegion; 
    
    IBOutlet UIImageView *leftPinImageView;
    IBOutlet UIImageView *leftMagifyImageView;
    IBOutlet UILabel *firstALineddressLabel;
    IBOutlet UILabel *secondLineAddressLabel;
    IBOutlet UILabel *searchTextLabel;
    IBOutlet UILabel *placeAndAddressLabel;
    
    IBOutlet UIImageView *verticalMiddleLine;
    IBOutlet UIImageView *rightPinImageView;
    IBOutlet UILabel *dropPinLabel;
    IBOutlet UILabel *touchAndHoldMapLabel;

    IBOutlet MKMapView *mapView;
    CGRect locationTapRect;
    NSMutableArray *mapAnnotations;
    CustomSearchbar*addressSearchBar;
    IBOutlet UIView *labelView;
    BOOL footerActivated;
    UITableView *locationResultsTableView;
    NSMutableArray *_geocodingResults;
    CLGeocoder * _geocoder;
    NSMutableArray *currentLocationArray;
    BOOL searching;
    int pointTag;
    SoclivityManager *SOC;
    NSMutableData *responseData;
    BOOL editMode;
    BOOL pinDrop;
}
@property (nonatomic,retain)InfoActivityClass *activityObject;
@property (nonatomic,retain)id <AddEventViewDelegate>delegate;
@property (nonatomic,retain) UIButton*calendarDateEditArrow;
@property (nonatomic,retain) UIButton*timeEditArrow;
@property (nonatomic,retain) UIButton*editMarkerButton;
@property (nonatomic,retain)IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) CustomSearchbar *addressSearchBar;
@property (nonatomic,retain)NSMutableArray *_geocodingResults;
@property (nonatomic,retain)UIView*labelView;
@property (nonatomic,assign)BOOL searching;
@property (nonatomic,assign)BOOL editMode;
@property (nonatomic,retain) UILabel *firstALineddressLabel;
@property(nonatomic,retain) UILabel *secondLineAddressLabel;
@property (nonatomic,assign)BOOL pinDrop;
@property (nonatomic,assign)BOOL firstTime;
-(void)showSearchBarAndAnimateWithListViewInMiddle;
-(void)ActivityEventOnMap;
-(void)loadViewWithActivityDetails:(InfoActivityClass*)info;
- (void)gotoLocation;
-(void)hideSearchBarAndAnimateWithListViewInMiddle;
- (void) processForwardGeocodingResults:(NSArray *)placemarks;
- (void) addPinAnnotationForPlacemark:(NSArray*)placemarks droppedStatus:(BOOL)droppedStatus;
#if TESTING
- (void) zoomMapToPlacemark:(CLPlacemark *)selectedPlacemark;
#else
- (void) zoomMapToPlacemark:(PlacemarkClass *)selectedPlacemark;
#endif
- (void) geocodeFromSearchBar;
-(CGFloat) maxDistanceBetweenPoints:(CLLocation*)avgLocation;
-(CLLocation*)avgLocation;
-(CLLocation*)ZoomToAllResultPointsOnMap;
-(CGFloat) maxDistanceBetweenAllResultPointsOnMap:(CLLocation*)avgLocation;
-(void)setNewLocation;
-(void)CurrentMapZoomUpdate;
-(void)cancelClicked;
-(void)openMapUrlApplication;
- (void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coord;
- (void) processReverseGeocodingResults:(NSArray *)placemarks;
-(UIView*)DrawAMapLeftAccessoryView:(ActivityAnnotation *)locObject;
-(void)setUpLabelViewElements:(BOOL)show;
@end
