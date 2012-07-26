//
//  AddEventView.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol AddEventViewDelegate <NSObject>

@optional
-(void)pushToHomeViewController;
-(void)slideInTransitionToLocationView;
@end


@interface AddEventView : UIView<MKMapViewDelegate>{
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
    
    IBOutlet UIButton *currentLocationInMap;
    IBOutlet UILabel *firstALineddressLabel;
    IBOutlet UILabel *secondLineAddressLabel;
    IBOutlet MKMapView *mapView;
    CGRect locationTapRect;
    NSMutableArray *mapAnnotations;
    


}
@property (nonatomic,retain)InfoActivityClass *activityObject;
@property (nonatomic,retain)id <AddEventViewDelegate>delegate;
@property (nonatomic,retain) UIButton*calendarDateEditArrow;
@property (nonatomic,retain) UIButton*timeEditArrow;
@property (nonatomic,retain) UIButton*editMarkerButton;
@property (nonatomic,retain)IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
-(void)ActivityEventOnMap;
-(void)loadViewWithActivityDetails:(InfoActivityClass*)info;
-(IBAction)currentLocationBtnClicked:(id)sender;
- (void)gotoLocation;
@end
