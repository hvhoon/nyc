//
//  CreateActivityViewController.h
//  Soclivity
//
//  Created by Kanav on 10/8/12.
//
//

#import <UIKit/UIKit.h>
#import "MJDetailViewController.h"
#import "CustomSearchBar.h"
#import <MapKit/MapKit.h>
#import "NotifyAnimationView.h"
@class SoclivityManager;
@class MainServiceManager;
@class MBProgressHUD;
@protocol  NewActivityViewDelegate <NSObject>

@optional
-(void)cancelCreateActivityEventScreen;
-(void)pushToNewActivity:(InfoActivityClass*)activity;
-(void)updateDetailedActivityScreen:(InfoActivityClass*)activityObj;
-(void)deleteActivityEventByOrganizer;
@end


@interface CreateActivityViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,PickerDetailViewDelegate,SoclivitySearchBarDelegate,UISearchBarDelegate,MKMapViewDelegate,NotifyAnimationViewDelegate,UIAlertViewDelegate,UIViewControllerRestoration>{
    id<NewActivityViewDelegate>delegate;
    IBOutlet UILabel *createActivtyStaticLabel;
    NSInteger activityType;
    IBOutlet UIView *createActivityView;
    IBOutlet UITextField *activityNameTextField;
    IBOutlet UIView*backgroundView;
    IBOutlet UITextView*descriptionTextView;
    IBOutlet UILabel *countTextLabel;
    IBOutlet UILabel *totalCountTextLabel;
    BOOL validAcivityName;
    SoclivityManager *SOC;
    UILabel *placeholderLabel;
    IBOutlet UIButton*pickADayImageButton;
    IBOutlet UIButton*pickATimeImageButton;

    IBOutlet UILabel *capacityLabel;
    IBOutlet UIButton*pickADayButton;
    IBOutlet UIButton*pickATimeButton;
    IBOutlet UIButton*publicPrivateButton;
    IBOutlet UITextField *capacityTextField;
    IBOutlet UILabel *blankTextLabel;
    
    IBOutlet UIButton*pickALocationButton;
    IBOutlet UIButton *privacyImageButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *crossButton;
    IBOutlet UIButton *centerLocationButton;
    IBOutlet UIButton *createActivityButton;
    IBOutlet UILabel *locationTextLabel;
    CustomSearchbar*addressSearchBar;
    BOOL searching;
    MKMapView* _mapView;
    UIImageView *leftPinImageView;
    UILabel *firstALineddressLabel;
    UILabel *secondLineAddressLabel;
    UIButton *activityInfoButton;
    UIImageView *leftMagifyImageView;
    UILabel *searchTextLabel;
    UILabel *placeAndAddressLabel;
    UIImageView *verticalMiddleLine;
    UIImageView *rightPinImageView;
    UILabel *dropPinLabel;
    UILabel *touchAndHoldMapLabel;
    IBOutlet UIButton *locationCrossButton;
    NSMutableData *responseData;
    NSMutableArray *_geocodingResults;
    NSMutableArray*currentLocationArray;
    MKCoordinateRegion adjustedRegion;
    BOOL pinDrop;
    NSInteger pointTag;
    CLGeocoder * _geocoder;
    BOOL isTransition;
    InfoActivityClass *activityObject;
    IBOutlet UILabel*onlyInviteesIphone5Label;
    BOOL newActivity;
    BOOL dateSelected;
    BOOL timeSelected;
    MainServiceManager *devServer;
    MBProgressHUD *HUD;
    UISearchBar *ios7SearchBar;
    IBOutlet UIButton *crossEditButton;
    IBOutlet UIButton *tickEditButton;
    IBOutlet UIButton *deleteActivityButton;
    BOOL selectionType;
    int indexRE;
    NSInteger preSelectionIndex;
    
    UIImageView*phoneIconImageView;
    UILabel*phoneLabel;
    UIImageView*ratingIconImageView;
    UILabel*ratingLabel;
    UILabel *categoryTextLabel;
    UIButton *disclosureButton;
    NSInteger urlIndex;
    UIButton *phoneButton;
    
    IBOutlet UIImageView *topBarImageView;
    IBOutlet UIImageView *bottomBarImageView;


}
@property (nonatomic, retain)  MKMapView* mapView;
@property (nonatomic,retain)NSMutableArray *_geocodingResults;
@property (nonatomic,retain)id<NewActivityViewDelegate>delegate;
@property (nonatomic,retain)CustomSearchbar *addressSearchBar;
@property(nonatomic,retain)UISearchBar*ios7SearchBar;
@property (nonatomic,retain)InfoActivityClass *activityObject;
@property (nonatomic,assign) BOOL newActivity;
-(IBAction)crossClicked:(id)sender;
-(IBAction)pickADateButtonPressed:(id)sender;
-(IBAction)pickATimeButtonPressed:(id)sender;
-(IBAction)publicOrPrivateActivityButtonPressed:(id)sender;
-(IBAction)pickALocationButtonPressed:(id)sender;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)currentLocationButtonClicked:(id)sender;
-(IBAction)createActivityButtonClicked:(id)sender;
-(IBAction)crossLocationButtonClicked:(id)sender;
-(void)geocodeFromSearchBar:(NSInteger)type;
- (void)gotoLocation;
-(void)activityInfoButtonClicked:(id)sender;
-(void)openMapUrlApplication;
-(void)setUpLabelViewElements:(BOOL)show;
- (void) addPinAnnotationForPlacemark:(NSArray*)placemarks droppedStatus:(BOOL)droppedStatus;
-(CGFloat) maxDistanceBetweenAllResultPointsOnMap:(CLLocation*)avgLocation;
-(CLLocation*)ZoomToAllResultPointsOnMap;
-(void)startAnimation:(NSInteger)type;
-(IBAction)deleteActivtyPressed:(id)sender;
-(IBAction)crossClickedByOrganizer:(id)sender;
-(IBAction)tickClickedByOrganizer:(id)sender;
-(BOOL)checkValidations;
-(void)enableOrDisablePickerElements:(BOOL)show;
-(void)getAddressDetailsFromLatLong:(float)latitude lng:(float)longitude;
@end
