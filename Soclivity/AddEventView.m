//
//  AddEventView.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddEventView.h"
#import "InfoActivityClass.h"
#import "SoclivityUtilities.h"
#import "DetailInfoActivityClass.h"
#import "SoclivityManager.h"
#import "ActivityAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SoclivitySqliteClass.h"
#define METERS_PER_MILE 1609.344
@implementation AddEventView
@synthesize activityObject,delegate,calendarDateEditArrow,timeEditArrow,editMarkerButton,mapView,mapAnnotations,addressSearchBar,_geocodingResults,labelView,searching;


#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)loadViewWithActivityDetails:(InfoActivityClass*)info{
            
    // Loading picture information
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                    initWithTarget:self
                                           selector:@selector(loadProfileImage:) 
                                    object:info.ownerProfilePhotoUrl];
    [queue addOperation:operation];
    [operation release];
    
    activityObject=[info retain];
    // Activity organizer name
    activityorganizerTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    activityorganizerTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    activityorganizerTextLabel.text=[NSString stringWithFormat:@"%@",info.organizerName];
    CGSize  size = [info.organizerName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15]];
    NSLog(@"width=%f",size.width);
    activityorganizerTextLabel.frame=CGRectMake(104, 24, size.width, 16);
    
    // Activity organizer DOS
    DOSConnectionImgView.frame=CGRectMake(104+6+size.width, 24, 21, 12);
    switch (info.DOS){
        case 1:
            DOSConnectionImgView.image=[UIImage imageNamed:@"S05_dos1.png"];
            break;
            
        case 2:
            DOSConnectionImgView.image=[UIImage imageNamed:@"S05_dos2.png"];
            break;
            
            
        default:
            break;
    }
    
    // Determing the user's relationship to the organizer
    organizerLinkLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    organizerLinkLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    switch (info.DOS){
        case 1:
            organizerLinkLabel.text=[NSString stringWithFormat:@"Created by a friend!"];
            break;
            
        case 2:
            organizerLinkLabel.text=[NSString stringWithFormat:@"Created by a friend of a friend!"];
            break;
            
        case 0:
            organizerLinkLabel.text=[NSString stringWithFormat:@"You created this event!"];
            break;
            
        default:
            organizerLinkLabel.text=[NSString stringWithFormat:@"Created this event!"];
            break;
    }
    
    
    // Moving to the description field
    
    const int descriptionBuffer = 42; // buffer in the description box
    
    // Adding line at the top of the description box
    UIImageView *topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
    topLine.frame = CGRectMake(26, 64, 294, 1);
    [self addSubview:topLine];
    
    // Checking to see if the description is empty first.
    if((info.what==(NSString*)[NSNull null])||([info.what isEqualToString:@""]||info.what==nil)||([info.what isEqualToString:@"(null)"]))
        activityTextLabel.text=@"No description given.";
    else
        activityTextLabel.text = info.what;
    
    activityTextLabel.numberOfLines = 0;
    activityTextLabel.lineBreakMode = UILineBreakModeWordWrap;

	activityTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    activityTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    activityTextLabel.backgroundColor=[UIColor clearColor];
    
    CGSize labelSize = [activityTextLabel.text sizeWithFont:activityTextLabel.font constrainedToSize:activityTextLabel.frame.size
            lineBreakMode:UILineBreakModeWordWrap];
    
    // Cap the description at 160 characters or 4 lines
    if(labelSize.height>72){
        labelSize.height=72;
    }
    
    CGRect descriptionBox=CGRectMake(26, 65, 294, labelSize.height+descriptionBuffer);
    UIView *description = [[UIView alloc] initWithFrame:descriptionBox];
    
    // Change the description box and activity bar color based on the activity type
    switch (info.type) {
        case 1:
            activityBarImgView.image=[UIImage imageNamed:@"S05_green-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:10];
            break;
        case 2:
            activityBarImgView.image=[UIImage imageNamed:@"S05_yellow-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:11];
            break;
        case 3:
            activityBarImgView.image=[UIImage imageNamed:@"S05_purple-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:12];
            break;
        case 4:
            activityBarImgView.image=[UIImage imageNamed:@"S05_red-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:13];
            break;
        case 5:
            activityBarImgView.image=[UIImage imageNamed:@"S05_aqua-marine-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:14];
            break;
        default:
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:1];
            break;
    }

    [self addSubview:description];
    
    // Adding description text to the view
    [activityTextLabel setFrame:CGRectMake(20, 12, 266, labelSize.height)];
    [description addSubview:activityTextLabel];
    
    // Variable to store the size of the privacy image
    CGSize privacySize;
    
    // Privacy icons
    if ([info.access isEqualToString:@"public"]){
        activityAccessStatusImgView.image=[UIImage imageNamed:@"S05_public.png"];
        privacySize = activityAccessStatusImgView.frame.size;
        activityAccessStatusImgView.frame=CGRectMake(288-privacySize.width, (labelSize.height+descriptionBuffer)-(privacySize.height+6), 47, 15);
    }
    else {
        activityAccessStatusImgView.image=[UIImage imageNamed:@"S05_private.png"];
        privacySize = activityAccessStatusImgView.frame.size;
        activityAccessStatusImgView.frame=CGRectMake(288-privacySize.width, (labelSize.height+descriptionBuffer)-(privacySize.height+6), 50, 15);
    }
    
    // Adding privacy settings to the description view
    [description addSubview:activityAccessStatusImgView];
        
    // Adding line at the bottom of the description box
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
    bottomLine.frame = CGRectMake(26, 65+labelSize.height+descriptionBuffer, 294, 1);
    [self addSubview:bottomLine];

    
    // Setting up the bottom view which includes all the date, time and location info.
    
    // Fist lets add up what our Y starting point is
    int fromTheTop = 65+labelSize.height+descriptionBuffer+1;
    bottomView.frame = CGRectMake(0, fromTheTop, 320, 333-fromTheTop);

    // Calendar
    
    // Correctly formatting the date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *activityDate = [dateFormatter dateFromString:info.when];
    
    NSDate *date = activityDate;
    NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"EEEE, MMMM d, YYYY"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];

    
    // Now adding the date to the view
    calendarIcon.image = [UIImage imageNamed:@"S05_calendarIcon.png"];
    calendarIcon.frame = CGRectMake(50, 12, 19, 20);
     
    calendarDateLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    calendarDateLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    calendarDateLabel.frame = CGRectMake(84, 12+4, 200, 15);
    
    
    calendarDateEditArrow.frame=CGRectMake(291, 12+4, 9, 14);
    
    // Seperator line here
    UIImageView *detailsLineCalendar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_detailsLine.png"]];
    detailsLineCalendar.frame = CGRectMake(26, 44, 272, 1);
    [bottomView addSubview:detailsLineCalendar];
    [detailsLineCalendar release];
    
    // Time
    // Formatting the time string
    calendarDateLabel.text=prefixDateString;
    [prefixDateFormatter setDateFormat:@"h:mm a"];

    NSString *prefixTimeString = [prefixDateFormatter stringFromDate:date];
    activityTimeLabel.text=prefixTimeString;
    
    clockIcon.image = [UIImage imageNamed:@"S05_clockIcon.png"];
    clockIcon.frame = CGRectMake(50, 57, 20, 20);
    activityTimeLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    activityTimeLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    activityTimeLabel.frame = CGRectMake(84, 57+4, 200, 15);
    
    timeEditArrow.frame=CGRectMake(291, 57+4, 9, 14);
    
    // Seperator line here
    UIImageView *detailsLineTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_detailsLine.png"]];
    detailsLineTime.frame = CGRectMake(26, 89, 272, 1);
    [bottomView addSubview:detailsLineTime];
    [detailsLineTime release];
    
    // Location
    
    locationInfoLabel2.text=[NSString stringWithFormat:@"%@ %@",info.where_city,info.where_state];
    
    locationIcon.image = [UIImage imageNamed:@"S05_locationIcon.png"];
    locationIcon.frame = CGRectMake(50, 102, 19, 18);
    locationInfoLabel1.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel1.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    locationTapRect=CGRectMake(84,fromTheTop+102+1, 175, 15+19);
    locationInfoLabel1.frame = CGRectMake(84, 102+1, 175, 15);

    locationInfoLabel2.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel2.textColor=[SoclivityUtilities returnTextFontColor:5];
    locationInfoLabel2.frame = CGRectMake(84, 122, 175, 15);
    
    
    switch (info.activityRelationType) {
        case 1:
        {
            locationInfoLabel1.text=[NSString stringWithFormat:@"%@ miles away",info.distance];
        }
            break;
            
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            firstALineddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
            firstALineddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
            secondLineAddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
            secondLineAddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];

            locationInfoLabel1.text=info.where_address;
            firstALineddressLabel.text=info.where_address;
            secondLineAddressLabel.text=[NSString stringWithFormat:@"%@ %@",info.where_city,info.where_state];

        }
            break;
    }
    
    self.addressSearchBar = [[[CustomSearchbar alloc] initWithFrame:CGRectMake(320,0, 320, 44)] autorelease];
    self.addressSearchBar.delegate = self;
    self.addressSearchBar.CSDelegate=self;
    if(self.addressSearchBar.text!=nil){
        self.addressSearchBar.showsCancelButton = YES;
    }
    
    self.addressSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.addressSearchBar.placeholder=@"Search";
    self.addressSearchBar.backgroundImage=[UIImage imageNamed: @"S4.1_search-background.png"];
    [self addSubview:self.addressSearchBar];
    [self.addressSearchBar setHidden:YES];
    
    
    locationResultsTableView=[[UITableView alloc]initWithFrame:CGRectMake(320, 376, 320, 188) style:UITableViewStylePlain];
    [locationResultsTableView setRowHeight:kCustomRowHeight];
    locationResultsTableView.scrollEnabled=YES;
    locationResultsTableView.delegate=self;
    locationResultsTableView.dataSource=self;
    locationResultsTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    locationResultsTableView.separatorColor=[UIColor blackColor];
    locationResultsTableView.showsVerticalScrollIndicator=YES;
    locationResultsTableView.clipsToBounds=YES;
    [self addSubview:locationResultsTableView];
    [locationResultsTableView setHidden:YES];
}


#pragma mark -
#pragma mark Profile Picture Functions
// Profile picture loading functions
- (void)loadProfileImage:(NSString*)url {
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
    [imageData release];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}
- (void)displayImage:(UIImage *)image {
    
    
    if(image.size.height != image.size.width)
        image = [SoclivityUtilities autoCrop:image];
    
    // If the image needs to be compressed
    if(image.size.height > 42 || image.size.width > 42)
        profileImgView.image = [SoclivityUtilities compressImage:image size:CGSizeMake(42,42)];
    
   [profileImgView setImage:image]; //UIImageView
}
#pragma mark -

#if 1
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self];
    
    
    
    NSLog(@"Start Point_X=%f,Start Point_Y=%f",startPoint.x,startPoint.y);
        
        
    if(activityObject.activityRelationType==6){
        if(CGRectContainsPoint(locationTapRect,startPoint)){
            [self ActivityEventOnMap];
        }
    }
    
}   
#endif

-(void)ActivityEventOnMap{
    SOC=[SoclivityManager SharedInstance];

    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation=YES;
    searching=FALSE;
    self.addressSearchBar.text=@"";
    
    [self CurrentMapZoomUpdate];

    [delegate slideInTransitionToLocationView];
}
-(void)CurrentMapZoomUpdate{
    CLLocation* avgLoc = [self avgLocation];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(avgLoc.coordinate.latitude, avgLoc.coordinate.longitude), [self maxDistanceBetweenPoints:avgLoc], [self maxDistanceBetweenPoints:avgLoc]);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    [mapView setRegion:adjustedRegion animated:YES];
    
    _geocodingResults=[NSMutableArray new];
    
    _geocoder = [[CLGeocoder alloc] init];
    
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [activityObject.where_lat doubleValue];
    theCoordinate.longitude = [activityObject.where_lng doubleValue];
    
    ActivityAnnotation *sfAnnotation = [[[ActivityAnnotation alloc] initWithName:firstALineddressLabel.text address:secondLineAddressLabel.text coordinate:theCoordinate tagIndex:0]autorelease];
    [self.mapAnnotations insertObject:sfAnnotation atIndex:0];
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:0]];

}
- (void)gotoLocation
{
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = SOC.currentLocation.coordinate.latitude;
    newRegion.center.longitude = SOC.currentLocation.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.06;
    newRegion.span.longitudeDelta = 0.06;
    
    [self.mapView setRegion:newRegion animated:YES];
}
-(IBAction)currentLocationBtnClicked:(id)sender{
    [self gotoLocation];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
    else if ([annotation isKindOfClass:[ActivityAnnotation class]]){
        static NSString* SFAnnotationIdentifier = @"SFAnnotationIdentifier";
        MKPinAnnotationView* pinView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        if (!pinView)
        {
            MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
            reuseIdentifier:SFAnnotationIdentifier] autorelease];
            UIImage *flagImage=[UIImage imageNamed:@"S05.1_map-tag.png"];
            
            
            CGRect resizeRect;
            
            resizeRect.size = flagImage.size;
            CGSize maxSize = CGRectInset(self.bounds,
                                          10.0f,
                                          10.0f).size;
            maxSize.height -= 44 +  40.0f;
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
            
            annotationView.canShowCallout=YES;
            
            return annotationView;
        }
        else
         {
         pinView.annotation = annotation;
         }
        return pinView;
    }
    
    return nil;
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    
    if(searching){
        
        
        ActivityAnnotation *loc=view.annotation;
        //view.image=[UIImage imageNamed:@"S05.1_map-tag.png"];
        
        pointTag=loc.annotTag;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:pointTag inSection:0];
        UITableViewCell* theCell = [locationResultsTableView cellForRowAtIndexPath:indexPath];
        
        theCell.contentView.backgroundColor=[UIColor clearColor];
        [locationResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [locationResultsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if(searching){
	ActivityAnnotation *loc=view.annotation;
    //view.image=[UIImage imageNamed:@"S04_location_create.png"];
        
    //now ask the table to scrollAtThat Row in the table and become highlighted    
    pointTag=loc.annotTag;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:pointTag inSection:0];
    UITableViewCell* theCell = [locationResultsTableView cellForRowAtIndexPath:indexPath];
    
        theCell.contentView.backgroundColor=[SoclivityUtilities returnBackgroundColor:1];
    [locationResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
        
    [locationResultsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void) geocodeFromSearchBar{
    
    
    // Cancel any active geocoding. Note: Cancelling calls the completion handler on the geocoder
    if (_geocoder.isGeocoding)
        [_geocoder cancelGeocode];
    
    [_geocoder geocodeAddressString:addressSearchBar.text
                  completionHandler:^(NSArray *placemark, NSError *error) {
                      if (!error)
                          [self processForwardGeocodingResults:placemark];
                  }
     ];
}

- (void) processForwardGeocodingResults:(NSArray *)placemarks {
    [_geocodingResults removeAllObjects];
    
    searching=FALSE;
    // check if the location is less than 50 miles
    NSMutableArray *lessThan50Miles=[NSMutableArray new];
    
    if([placemarks count]>0){
        
        
        
        for (CLPlacemark *placemark in placemarks){
            CLLocationDegrees latitude  = placemark.location.coordinate.latitude;
            CLLocationDegrees longitude = placemark.location.coordinate.longitude;
            CLLocation *tempLocObj = [[CLLocation alloc] initWithLatitude:latitude
                                                                longitude:longitude];
            
            CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:SOC.currentLocation.coordinate.latitude
                                                               longitude:SOC.currentLocation.coordinate.longitude];
            
            float distance =[newCenter distanceFromLocation:tempLocObj] / 1000;
            NSLog(@"distance=%f",distance);
            //if(distance<=50){
            [lessThan50Miles addObject:placemark];
            //}
            
        }
        
    }
    
    if([lessThan50Miles count]>0){
        searching=TRUE;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self addPinAnnotationForPlacemark:lessThan50Miles];
        currentLocationArray =[NSMutableArray arrayWithCapacity:[lessThan50Miles count]];
        currentLocationArray=[lessThan50Miles retain];
        
        //Zoom in all results.
        
        CLLocation* avgLoc = [self ZoomToAllResultPointsOnMap];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(avgLoc.coordinate.latitude, avgLoc.coordinate.longitude), [self maxDistanceBetweenAllResultPointsOnMap:avgLoc], [self maxDistanceBetweenAllResultPointsOnMap:avgLoc]);
        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
        [mapView setRegion:adjustedRegion animated:YES];
        [_geocodingResults addObjectsFromArray:placemarks];
        
    }
    
    [self showSearchBarAndAnimateWithListViewInMiddle];
    [locationResultsTableView reloadData];
}


-(CLLocation*)ZoomToAllResultPointsOnMap{
    CGFloat xAvg=0;
    CGFloat yAvg=0;
    for (int i=0; i<currentLocationArray.count; i++) {
        
        CLPlacemark * placemark = [currentLocationArray objectAtIndex:i];
        xAvg+=placemark.location.coordinate.latitude;
        yAvg+=placemark.location.coordinate.longitude;
    }
    return [[CLLocation alloc] initWithLatitude:xAvg/currentLocationArray.count longitude:yAvg/currentLocationArray.count];
}

-(CGFloat) maxDistanceBetweenAllResultPointsOnMap:(CLLocation*)avgLocation{
    if (currentLocationArray.count==1) {
        return 2*METERS_PER_MILE;
    }
    else{
        CGFloat distance=0;
        CLLocation *newCenter;
        
        for (int i=0; i<currentLocationArray.count; i++) {
            
            CLPlacemark * placemark = [currentLocationArray objectAtIndex:i];
            newCenter = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude
                                                   longitude:placemark.location.coordinate.longitude];
            distance =(distance>[avgLocation distanceFromLocation:(CLLocation*)newCenter]?distance:[avgLocation distanceFromLocation:(CLLocation*)newCenter]);
        }
        return 2*distance;
    }
}
- (void) addPinAnnotationForPlacemark:(NSArray*)placemarks {
    
    for(int i=0;i<[placemarks count];i++){
        
        CLPlacemark * placemark = [placemarks objectAtIndex:i];
        
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = [activityObject.where_lat doubleValue];
        theCoordinate.longitude = [activityObject.where_lng doubleValue];
        
        ActivityAnnotation *sfAnnotation = [[[ActivityAnnotation alloc] initWithName:ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO) address:secondLineAddressLabel.text coordinate:placemark.location.coordinate tagIndex:i]autorelease];
        
        [self.mapView addAnnotation:sfAnnotation];
        
        
    }
}

- (void) zoomMapToPlacemark:(CLPlacemark *)selectedPlacemark {
    CLLocationCoordinate2D coordinate = selectedPlacemark.location.coordinate;
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    double radius = (MKMapPointsPerMeterAtLatitude(coordinate.latitude) * selectedPlacemark.region.radius)/2;
    MKMapSize size = {radius, radius};
    MKMapRect mapRect = {mapPoint, size};
    mapRect = MKMapRectOffset(mapRect, -radius/2, -radius/2); // adjust the rect so the coordinate is in the middle
    [self.mapView setVisibleMapRect:mapRect
                           animated:YES];
}

-(CLLocation*)avgLocation{
    CGFloat xAvg=0;
    CGFloat yAvg=0;
    for (int i=0; i<2; i++) {
        
        
        switch (i) {
            case 0:
            {
                xAvg += SOC.currentLocation.coordinate.latitude;
                yAvg += SOC.currentLocation.coordinate.longitude;
            }
                break;
                
            case 1:
            {
                xAvg += [activityObject.where_lat doubleValue];
                yAvg += [activityObject.where_lng doubleValue];
                
                
            }
                break;
        }
        
        
    }
    
    return [[CLLocation alloc] initWithLatitude:xAvg/2 longitude:yAvg/2];
}


-(CGFloat) maxDistanceBetweenPoints:(CLLocation*)avgLocation{
    CGFloat distance=0;
    CLLocation *newCenter;
    for (int i=0; i<2; i++) {
        
        switch (i) {
            case 0:
            {
                newCenter = [[CLLocation alloc] initWithLatitude:SOC.currentLocation.coordinate.latitude
                                                       longitude:SOC.currentLocation.coordinate.longitude];
                
            }
                break;
                
            case 1:
            {
                newCenter = [[CLLocation alloc] initWithLatitude:[activityObject.where_lat doubleValue]
                                                       longitude:[activityObject.where_lng doubleValue]];
                
            }
                break;
        }
        distance =(distance>[avgLocation distanceFromLocation:(CLLocation*)newCenter]?distance:[avgLocation distanceFromLocation:(CLLocation*)newCenter]);
    }
    return 2*distance;
}

-(void)showSearchBarAndAnimateWithListViewInMiddle{
    
    [locationResultsTableView setHidden:NO];
    
    if (!footerActivated) {
		[UIView beginAnimations:@"expandFooter" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		
		// Resize the map.
		CGRect mapFrame = [self.mapView frame];
		mapFrame.size.height -= 188;
		[self.mapView setFrame:mapFrame];
        
        CGRect tableViewFrame = [locationResultsTableView frame];
		tableViewFrame.origin.y -= 188;
		[locationResultsTableView setFrame:tableViewFrame];

        
        [self.addressSearchBar setHidden:NO];
        labelView.hidden=YES;
        
		[UIView commitAnimations];
		footerActivated = YES;
	}

}
-(void)hideSearchBarAndAnimateWithListViewInMiddle{
 
    if (footerActivated) {
		[UIView beginAnimations:@"collapseFooter" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		
		// Resize the map.
		CGRect mapFrame = [self.mapView frame];
		mapFrame.size.height += 188;
		[self.mapView setFrame:mapFrame];
        
        CGRect tableViewFrame = [locationResultsTableView frame];
		tableViewFrame.origin.y += 188;
		[locationResultsTableView setFrame:tableViewFrame];
        
        [locationResultsTableView setHidden:YES];

        
        [self.addressSearchBar setHidden:YES];
        labelView.hidden=NO;

		[UIView commitAnimations];
		footerActivated = NO;
	}

}
#pragma mark -
#pragma mark UISearchBarDelegate


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidEndEditing=%@",searchBar.text);
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if([self.addressSearchBar.text isEqualToString:@""]){
        
        [searchBar setShowsCancelButton:NO animated:YES];
        self.addressSearchBar.showClearButton=NO;
        
    }
    else{
        [searchBar setShowsCancelButton:NO animated:NO];
        self.addressSearchBar.showClearButton=YES;
        
    }
    [searchBar setShowsCancelButton:YES animated:NO];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    self.addressSearchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [self.addressSearchBar resignFirstResponder];
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self geocodeFromSearchBar];
    
    [self.addressSearchBar resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
}
-(void)customCancelButtonHit{
    
    self.addressSearchBar.text=@"";
    self.addressSearchBar.showClearButton=NO;
    [addressSearchBar setShowsCancelButton:NO animated:YES];
    [self.addressSearchBar resignFirstResponder];
}


#pragma mark Table view data source and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if([_geocodingResults count]==0)
        return 1;
    else
        return [_geocodingResults count];
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return kCustomRowHeight;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
	static NSString *profilEditIdentifier = @"ProfileEditCell";
	int nodeCount=[_geocodingResults count];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profilEditIdentifier];
	//if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:profilEditIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//}
	
    if(nodeCount==0 && indexPath.row==0){
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
         cell.textLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        cell.textLabel.text=@"No results found";
    }
    if(nodeCount>0){
     CLPlacemark * placemark = [_geocodingResults objectAtIndex:indexPath.row];
    
     NSString * formattedAddress = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
        
        CGRect addressLabelRect=CGRectMake(35,10,270,14);
        UILabel *addressLabel=[[UILabel alloc] initWithFrame:addressLabelRect];
        addressLabel.textAlignment=UITextAlignmentLeft;
        addressLabel.text=formattedAddress;
        addressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
        addressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];

        addressLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:addressLabel];
        [addressLabel release];
    
        CGRect zipStreetLabelRect=CGRectMake(35,28,270,14);
        UILabel *zipStreetLabel=[[UILabel alloc] initWithFrame:zipStreetLabelRect];
        zipStreetLabel.textAlignment=UITextAlignmentLeft;
        zipStreetLabel.text=[NSString stringWithFormat:@"%@ %@ %@",placemark.subLocality,placemark.subAdministrativeArea,placemark.postalCode];
        zipStreetLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
        zipStreetLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        zipStreetLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:zipStreetLabel];
        [zipStreetLabel release];
    }
        return cell;
}
#pragma mark -
#pragma mark Table cell image support

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if([_geocodingResults count]>0){ 
        
    searching=TRUE;   
    pointTag=indexPath.row;
    UITableViewCell* theCell = [tableView cellForRowAtIndexPath:indexPath];
    
    theCell.contentView.backgroundColor=[SoclivityUtilities returnBackgroundColor:1];
    CLPlacemark * selectedPlacemark = [_geocodingResults objectAtIndex:indexPath.row];

    [self zoomMapToPlacemark:selectedPlacemark];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

-(void)setNewLocation{
    
    CLPlacemark * selectedPlacemark = [_geocodingResults objectAtIndex:pointTag];
    activityObject.where_lat=[NSString stringWithFormat:@"%f",selectedPlacemark.location.coordinate.latitude];
    activityObject.where_lng=[NSString stringWithFormat:@"%f",selectedPlacemark.location.coordinate.longitude];
    NSString * formattedAddress = ABCreateStringWithAddressDictionary(selectedPlacemark.addressDictionary, NO);
    locationInfoLabel1.text=firstALineddressLabel.text=formattedAddress;
    locationInfoLabel2.text=secondLineAddressLabel.text=[NSString stringWithFormat:@"%@ %@ %@",selectedPlacemark.subLocality,selectedPlacemark.subAdministrativeArea,selectedPlacemark.postalCode];
    
    CLLocation *tempLocObj = [[CLLocation alloc] initWithLatitude:selectedPlacemark.location.coordinate.latitude
                                                        longitude:selectedPlacemark.location.coordinate.longitude];
    
    CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:SOC.currentLocation.coordinate.latitude
                                                       longitude:SOC.currentLocation.coordinate.longitude];
    
    activityObject.distance =[NSString stringWithFormat:@"%.02f",[newCenter distanceFromLocation:tempLocObj] / 1000];

    
    
    
    // also make sure you update the database for list and map View and refresh the list and map state
    
    [SoclivitySqliteClass UpadateTheActivityEventTable:activityObject];
    SOC.localCacheUpdate=TRUE;
     
}
-(void)cancelClicked{
    self.mapView.showsUserLocation=YES;
    searching=FALSE;
    self.addressSearchBar.text=@"";
    
    [self CurrentMapZoomUpdate];

}


- (void)dealloc {
    [super dealloc];

    [calendarIcon release];
    [clockIcon release];
    [locationIcon release];
    [mapView release];
    [mapAnnotations release];

}
@end
