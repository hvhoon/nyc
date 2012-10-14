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
#import "PlacemarkClass.h"
#define LISTVIEWREMOVE 0

#define kLeftBarImageView 10
#define kTopLineDescriptionView 11
#define kActivityDescTextLabel 12
#define kDescriptionView 13
#define kBottomLineImageView 14
#define kBottomView 15
#define kCalendarIconImageView 16
#define kCalendarDateLabelTag 17
#define kDetailLineImageView 18
#define kActivityTimeLabel 19
#define kClockIconImageView 20
#define kDetailLineTimeImageView 21
#define kLocationIcomImageview 22
#define kLocationInfolabel1 23
#define kLocationInfolabel2 24
#define kPrivacySetting5 25
#define kPrivacyImageView5 26
#define kDetailLineMap 27
#define kActivityAccessImageView 28
#define kActivityPlotMapButton 29
@implementation AddEventView
@synthesize activityObject,delegate,mapView,mapAnnotations,addressSearchBar,_geocodingResults,labelView,searching,editMode,firstALineddressLabel,secondLineAddressLabel,pinDrop,firstTime,activityInfoButton;


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
    topLine.tag=kTopLineDescriptionView;
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
    activityBarImgView.tag=kLeftBarImageView;
    description.tag=kDescriptionView;
    [self addSubview:description];
    
    // Adding description text to the view
    [activityTextLabel setFrame:CGRectMake(20, 12, 266, labelSize.height)];
    [activityTextLabel setTag:kActivityDescTextLabel];
    [description addSubview:activityTextLabel];
    
    
    
    
    
        
    // Adding line at the bottom of the description box
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
    bottomLine.frame = CGRectMake(26, 65+labelSize.height+descriptionBuffer, 294, 1);
    bottomLine.tag=kBottomLineImageView;
    [self addSubview:bottomLine];

    
    // Setting up the bottom view which includes all the date, time and location info.
    
    // Fist lets add up what our Y starting point is
    int fromTheTop = 65+labelSize.height+descriptionBuffer+1;
    [bottomView setTag:kBottomView];
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
    calendarIcon.tag=kCalendarIconImageView;
    
    calendarDateLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    calendarDateLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    calendarDateLabel.frame = CGRectMake(84, 12+4, 200, 15);
    calendarDateLabel.tag=kCalendarDateLabelTag;
    
    //calendarDateEditArrow.frame=CGRectMake(291, 12+4, 9, 14);
    
    // Seperator line here
    UIImageView *detailsLineCalendar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_detailsLine.png"]];
    detailsLineCalendar.frame = CGRectMake(26, 44, 272, 1);
    detailsLineCalendar.tag=kDetailLineImageView;
    [bottomView addSubview:detailsLineCalendar];
    [detailsLineCalendar release];
    
    // Time
    // Formatting the time string
    calendarDateLabel.text=prefixDateString;
    [prefixDateFormatter setDateFormat:@"h:mm a"];
    
    

    NSString *prefixTimeString = [prefixDateFormatter stringFromDate:date];
    activityTimeLabel.text=prefixTimeString;
    activityTimeLabel.tag=kActivityTimeLabel;
    


    clockIcon.image = [UIImage imageNamed:@"S05_clockIcon.png"];
    clockIcon.frame = CGRectMake(50, 57, 20, 20);
    clockIcon.tag=kClockIconImageView;
    activityTimeLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    activityTimeLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    activityTimeLabel.frame = CGRectMake(84, 57+4, 200, 15);
    //timeEditArrow.frame=CGRectMake(291, 57+4, 9, 14);


    // Seperator line here
    UIImageView *detailsLineTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_detailsLine.png"]];
    detailsLineTime.frame = CGRectMake(26, 89, 272, 1);
    detailsLineTime.tag=kDetailLineTimeImageView;
    [bottomView addSubview:detailsLineTime];
    [detailsLineTime release];
    
    

    
    // Location
    locationIcon.image = [UIImage imageNamed:@"S05_locationIcon.png"];
    locationIcon.frame = CGRectMake(50, 103, 19, 18);
    locationIcon.tag=kLocationIcomImageview;
    
    
    locationInfoLabel1.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel1.textColor=[SoclivityUtilities returnTextFontColor:5];
    locationInfoLabel1.tag=kLocationInfolabel1;
    
    locationTapRect=CGRectMake(84,fromTheTop+103+1, 175, 15+19);
    locationInfoLabel1.frame = CGRectMake(84, 103+1, 175, 15);
    


    locationInfoLabel2.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel2.textColor=[SoclivityUtilities returnTextFontColor:5];
    locationInfoLabel2.frame = CGRectMake(84, 124, 175, 15);
    
    locationInfoLabel2.tag=kLocationInfolabel2;
    
    // Deciding whether to show the mini map or not
    [self decideToShowMapView:info.activityRelationType];
    
    

    // Privacy settings
    // Add an extra privacy row with the privacy settings for the larger iPhone 5 screen
    if([SoclivityUtilities deviceType] & iPhone5){
        privacySetting.tag=kPrivacySetting5;
        privacyImage.tag=kPrivacyImageView5;
        
        // Setting the privacy text
        if ([info.access caseInsensitiveCompare:@"private"] == NSOrderedSame) {
            privacySetting.text = @"This event is invite only";
            privacyImage.image = [UIImage imageNamed:@"S05_private5.png"];
        }
        else {
            privacySetting.text = @"Anybody can join this event";
            privacyImage.image = [UIImage imageNamed:@"S05_public5.png"];
        }
        
        // Setting up the label
        privacySetting.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
        privacySetting.textColor = [SoclivityUtilities returnTextFontColor:5];
        
        // Maps seperator line here initiatilized
        UIImageView *detailsLineMap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_detailsLine.png"]];
        
        detailsLineMap.tag=kDetailLineMap;
        // Framing based on whether the mini Map is showing or not
        detailsLineMap.frame = CGRectMake(26, 148, 272, 1);
        privacySetting.frame = CGRectMake(84, 166, 190, 15);
        privacyImage.frame = CGRectMake(50, 162, privacyImage.image.size.width, privacyImage.image.size.height);
        
        // Add to the view
        [bottomView addSubview:detailsLineMap];
        [bottomView addSubview:privacySetting];
        [bottomView addSubview:privacyImage];
        [detailsLineMap release];
        [privacySetting release];
        [privacyImage release];
        

    }
    // If they user is still on the smaller screen
    else {
        // Variable to store the size of the privacy image
        CGSize privacySize;
        activityAccessStatusImgView.tag=kActivityAccessImageView;
        // Privacy icons
        if ([info.access caseInsensitiveCompare:@"public"] == NSOrderedSame){
            activityAccessStatusImgView.image=[UIImage imageNamed:@"S05_public.png"];
            privacySize = activityAccessStatusImgView.frame.size;
            activityAccessStatusImgView.frame=CGRectMake(288-privacySize.width, (labelSize.height+descriptionBuffer)-(privacySize.height+6), 47, 15);
        }
        else {
            activityAccessStatusImgView.image=[UIImage imageNamed:@"S05_private.png"];
            privacySize = activityAccessStatusImgView.frame.size;
            activityAccessStatusImgView.frame=CGRectMake(288-privacySize.width, (labelSize.height+descriptionBuffer)-(privacySize.height+6), 47, 15);
        }
        
        // Adding privacy settings to the description view
        [description addSubview:activityAccessStatusImgView];
    }

 
    self.addressSearchBar = [[[CustomSearchbar alloc] initWithFrame:CGRectMake(320,0, 320, 44)] autorelease];
    self.addressSearchBar.delegate = self;
    self.addressSearchBar.CSDelegate=self;
    if(self.addressSearchBar.text!=nil){
        self.addressSearchBar.showsCancelButton = YES;
    }
    
    self.addressSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.addressSearchBar.placeholder=@"Place or Address";
    self.addressSearchBar.backgroundImage=[UIImage imageNamed: @"S4.1_search-background.png"];
    [self addSubview:self.addressSearchBar];
    [self.addressSearchBar setHidden:YES];
    
    
    CGRect rect;
    if([SoclivityUtilities deviceType] & iPhone5){
        rect = CGRectMake(320, 0, 320, 404);
        
        
    }
    else
    {
        rect = CGRectMake(320, 0, 320, 316);
        
    }
    
    mapView = [[MKMapView alloc] initWithFrame:rect];
    mapView.delegate = self;
    [self addSubview:mapView];

    
    
#if LISTVIEWREMOVE    
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
#endif    
 

}

-(void)updateEditedActivityFields:(InfoActivityClass*)act{
 
    
    
    for(UIView *subview in [self subviews]) {
		if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kLeftBarImageView]) {
			[subview removeFromSuperview];
		}
        
        if([subview isKindOfClass:[UIView class]] && [subview viewWithTag:kTopLineDescriptionView]) {
			[subview removeFromSuperview];
		}
        
        if([subview isKindOfClass:[UILabel class]] && [subview viewWithTag:kActivityDescTextLabel]) {
			[subview removeFromSuperview];
		}

        if([subview isKindOfClass:[UIView class]] && [subview viewWithTag:kDescriptionView]) {
			[subview removeFromSuperview];
		}

        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kBottomLineImageView]) {
			[subview removeFromSuperview];
		}

        
        if([subview isKindOfClass:[UIView class]] && [subview viewWithTag:kBottomView]) {
			[subview removeFromSuperview];
		}
        
        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kCalendarIconImageView]) {
			[subview removeFromSuperview];
		}
        
        if([subview isKindOfClass:[UILabel class]] && [subview viewWithTag:kCalendarDateLabelTag]) {
			[subview removeFromSuperview];
		}
        
        
        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kDetailLineImageView]) {
			[subview removeFromSuperview];
		}
        
        if([subview isKindOfClass:[UILabel class]] && [subview viewWithTag:kActivityTimeLabel]) {
			[subview removeFromSuperview];
		}


        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kClockIconImageView]) {
			[subview removeFromSuperview];
		}

        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kDetailLineTimeImageView]) {
			[subview removeFromSuperview];
		}

        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kLocationIcomImageview]) {
			[subview removeFromSuperview];
		}

        if([subview isKindOfClass:[UILabel class]] && [subview viewWithTag:kLocationInfolabel1]) {
			[subview removeFromSuperview];
		}
        
        if([subview isKindOfClass:[UILabel class]] && [subview viewWithTag:kLocationInfolabel2]) {
			[subview removeFromSuperview];
		}
        
        if([subview isKindOfClass:[UILabel class]] && [subview viewWithTag:kPrivacySetting5]) {
			[subview removeFromSuperview];
		}
        
        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kPrivacyImageView5]) {
			[subview removeFromSuperview];
		}
        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kDetailLineMap]) {
			[subview removeFromSuperview];
		}
        if([subview isKindOfClass:[UIImageView class]] && [subview viewWithTag:kActivityAccessImageView]) {
			[subview removeFromSuperview];
		}


		if([subview isKindOfClass:[UIButton class]] && [subview viewWithTag:kActivityPlotMapButton]) {
			[subview removeFromSuperview];
		}


        
		
	}
    
    
    
    const int descriptionBuffer = 42; // buffer in the description box
    
    // Adding line at the top of the description box
    UIImageView *topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
    topLine.frame = CGRectMake(26, 64, 294, 1);
    [topLine setTag:kTopLineDescriptionView];
    [self addSubview:topLine];
    
    
    activityTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(42, 75, 264, 81)];

    // Checking to see if the description is empty first.
    if((act.what==(NSString*)[NSNull null])||([act.what isEqualToString:@""]||act.what==nil)||([act.what isEqualToString:@"(null)"]))
        activityTextLabel.text=@"No description given.";
    else
        activityTextLabel.text = act.what;
    
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

    
    activityBarImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, labelSize.height+descriptionBuffer+65)];
    switch (act.type) {
        case 1:
        {
            activityBarImgView.image=[UIImage imageNamed:@"S05_green-bar.png"];
                        description.backgroundColor=[SoclivityUtilities returnBackgroundColor:10];
        }
            break;
        case 2:
        {
            activityBarImgView.image=[UIImage imageNamed:@"S05_yellow-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:11];

        }
            break;
        case 3:
        {
            activityBarImgView.image=[UIImage imageNamed:@"S05_purple-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:12];

        }
            break;
        case 4:
        {
            activityBarImgView.image=[UIImage imageNamed:@"S05_red-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:13];

        }
            break;
        case 5:
        {
            activityBarImgView.image=[UIImage imageNamed:@"S05_aqua-marine-bar.png"];
            description.backgroundColor=[SoclivityUtilities returnBackgroundColor:14];

        }
            break;
        default:
            break;
    }
    
    
    activityBarImgView.tag=kLeftBarImageView;
    [self addSubview:activityBarImgView];

    description.tag=kDescriptionView;
    [self addSubview:description];
    
    // Adding description text to the view
    [activityTextLabel setFrame:CGRectMake(20, 12, 266, labelSize.height)];
    [activityTextLabel setTag:kActivityDescTextLabel];
    [description addSubview:activityTextLabel];
    
    
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
    bottomLine.frame = CGRectMake(26, 65+labelSize.height+descriptionBuffer, 294, 1);
    bottomLine.tag=kBottomLineImageView;
    [self addSubview:bottomLine];
    
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 150, 320, 180)];
    [self addSubview:bottomView];
    int fromTheTop = 65+labelSize.height+descriptionBuffer+1;
    
    [bottomView setTag:kBottomView];
    bottomView.frame = CGRectMake(0, fromTheTop, 320, 333-fromTheTop);
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *activityDate = [dateFormatter dateFromString:act.when];
    
    NSDate *date = activityDate;
    NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"EEEE, MMMM d, YYYY"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
    
    
    calendarIcon=[[UIImageView alloc]initWithFrame:CGRectMake(50, 43, 19, 20)];
    calendarIcon.image = [UIImage imageNamed:@"S05_calendarIcon.png"];
    calendarIcon.frame = CGRectMake(50, 12, 19, 20);
    calendarIcon.tag=kCalendarIconImageView;
    [bottomView addSubview:calendarIcon];
    
    
    calendarDateLabel=[[UILabel alloc]init];
    calendarDateLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    calendarDateLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    calendarDateLabel.frame = CGRectMake(84, 12+4, 200, 15);
    calendarDateLabel.tag=kCalendarDateLabelTag;
    [bottomView addSubview:calendarDateLabel];
    
    
    
    UIImageView *detailsLineCalendar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_detailsLine.png"]];
    detailsLineCalendar.frame = CGRectMake(26, 44, 272, 1);
    detailsLineCalendar.tag=kDetailLineImageView;
    [bottomView addSubview:detailsLineCalendar];
    [detailsLineCalendar release];
    
    
    calendarDateLabel.text=prefixDateString;
    [prefixDateFormatter setDateFormat:@"h:mm a"];

    
    
    NSString *prefixTimeString = [prefixDateFormatter stringFromDate:date];
    
    activityTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(94, 45, 192, 18)];
    activityTimeLabel.text=prefixTimeString;
    activityTimeLabel.tag=kActivityTimeLabel;
    
    [bottomView addSubview:activityTimeLabel];
    
    
    clockIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_clockIcon.png"]];
    clockIcon.frame = CGRectMake(50, 57, 20, 20);
    clockIcon.tag=kClockIconImageView;
    [bottomView addSubview:clockIcon];
    
    activityTimeLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    activityTimeLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    activityTimeLabel.frame = CGRectMake(84, 57+4, 200, 15);




    
    UIImageView *detailsLineTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_detailsLine.png"]];
    detailsLineTime.frame = CGRectMake(26, 89, 272, 1);
    detailsLineTime.tag=kDetailLineTimeImageView;
    [bottomView addSubview:detailsLineTime];
    [detailsLineTime release];

    locationIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_locationIcon.png"]];
    locationIcon.frame = CGRectMake(50, 103, 19, 18);
    locationIcon.tag=kLocationIcomImageview;
    [bottomView addSubview:locationIcon];
    
    
    locationInfoLabel1=[[UILabel alloc]initWithFrame:CGRectMake(94, 135, 175, 14)];
    locationInfoLabel1.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel1.textColor=[SoclivityUtilities returnTextFontColor:5];
    locationInfoLabel1.tag=kLocationInfolabel1;
    [bottomView addSubview:locationInfoLabel1];
    
    locationTapRect=CGRectMake(84,fromTheTop+103+1, 175, 15+19);
    locationInfoLabel1.frame = CGRectMake(84, 103+1, 175, 15);


    locationInfoLabel2=[[UILabel alloc]initWithFrame:CGRectMake(84, 124, 175, 15)];
    locationInfoLabel2.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel2.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    locationInfoLabel2.tag=kLocationInfolabel2;
    [bottomView addSubview:locationInfoLabel2];


    locationIcon.hidden=YES;
    
    locationInfoLabel1.frame=CGRectMake(50, 103+1, 190, 15);
    locationInfoLabel2.frame = CGRectMake(50, 124, 190, 15);

    locationInfoLabel1.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
    locationInfoLabel1.textColor=[SoclivityUtilities returnTextFontColor:5];
    locationInfoLabel2.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel2.textColor=[SoclivityUtilities returnTextFontColor:5];
    locationInfoLabel1.text=activityObject.where_address;
    locationInfoLabel2.text=[NSString stringWithFormat:@"in %@",activityObject.where_zip];

    
    
    
    
    activityPlotOnMapButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    activityPlotOnMapButton.frame = CGRectMake(249, 133, 37.0, 37.0);
    [activityPlotOnMapButton setImage:[UIImage imageNamed:@"S05_miniMap.png"] forState:UIControlStateNormal];
    [activityPlotOnMapButton addTarget:self action:@selector(activityMapPlotButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    activityPlotOnMapButton.tag=kActivityPlotMapButton;
    [bottomView addSubview:activityPlotOnMapButton];

    
    activityPlotOnMapButton.hidden=NO;
    activityPlotOnMapButton.frame=CGRectMake(260, 101, 37, 37);
    
    // Setting the variables for the map screen
    firstALineddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
    firstALineddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    secondLineAddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    secondLineAddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    firstALineddressLabel.text = activityObject.where_address;
    secondLineAddressLabel.text = [NSString stringWithFormat:@"in %@",activityObject.where_zip];

    


if([SoclivityUtilities deviceType] & iPhone5){
    
    privacySetting=[[UILabel alloc]initWithFrame:CGRectMake(94, 200, 190, 14)];
    privacySetting.tag=kPrivacySetting5;
    privacyImage=[[UIImageView alloc]initWithFrame:CGRectMake(50, 198, 19, 18)];
    privacyImage.tag=kPrivacyImageView5;
    
    // Setting the privacy text
    if ([act.access caseInsensitiveCompare:@"private"] == NSOrderedSame) {
        privacySetting.text = @"This event is invite only";
        privacyImage.image = [UIImage imageNamed:@"S05_private5.png"];
    }
    else {
        privacySetting.text = @"Anybody can join this event";
        privacyImage.image = [UIImage imageNamed:@"S05_public5.png"];
    }
    
    // Setting up the label
    privacySetting.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    privacySetting.textColor = [SoclivityUtilities returnTextFontColor:5];
    
    // Maps seperator line here initiatilized
    UIImageView *detailsLineMap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S05_detailsLine.png"]];
    
    detailsLineMap.tag=kDetailLineMap;
    // Framing based on whether the mini Map is showing or not
    detailsLineMap.frame = CGRectMake(26, 148, 272, 1);
    privacySetting.frame = CGRectMake(84, 166, 190, 15);
    privacyImage.frame = CGRectMake(50, 162, privacyImage.image.size.width, privacyImage.image.size.height);
    
    // Add to the view
    [bottomView addSubview:detailsLineMap];
    [bottomView addSubview:privacySetting];
    [bottomView addSubview:privacyImage];
    [detailsLineMap release];
    [privacySetting release];
    [privacyImage release];
    
    
}
else {
    // Variable to store the size of the privacy image
    CGSize privacySize;
    activityAccessStatusImgView=[[UIImageView alloc]initWithFrame:CGRectMake(256, 131, 50, 15)];
    activityAccessStatusImgView.tag=kActivityAccessImageView;
    // Privacy icons
    if ([act.access caseInsensitiveCompare:@"public"] == NSOrderedSame){
        activityAccessStatusImgView.image=[UIImage imageNamed:@"S05_public.png"];
        privacySize = activityAccessStatusImgView.frame.size;
        activityAccessStatusImgView.frame=CGRectMake(288-privacySize.width, (labelSize.height+descriptionBuffer)-(privacySize.height+6), 47, 15);
    }
    else {
        activityAccessStatusImgView.image=[UIImage imageNamed:@"S05_private.png"];
        privacySize = activityAccessStatusImgView.frame.size;
        activityAccessStatusImgView.frame=CGRectMake(288-privacySize.width, (labelSize.height+descriptionBuffer)-(privacySize.height+6), 47, 15);
    }
    
    // Adding privacy settings to the description view
    [description addSubview:activityAccessStatusImgView];
}


}

-(void)decideToShowMapView:(NSInteger)type{
    
  activityPlotOnMapButton.hidden=YES;
    
    switch (type) {
        case 1:
        case 2:
        case 3:
        case 4:

        {
            locationInfoLabel1.text=[NSString stringWithFormat:@"%@ miles away",activityObject.distance];
            locationInfoLabel2.text=[NSString stringWithFormat:@"in %@",activityObject.where_zip];
        }
            break;
            
        case 5:
        case 6:
        {
            
            activityPlotOnMapButton.hidden=NO;
            locationIcon.hidden=YES;
            locationInfoLabel1.frame=CGRectMake(50, 103+1, 190, 15);
            locationInfoLabel2.frame = CGRectMake(50, 124, 190, 15);
            activityPlotOnMapButton.frame=CGRectMake(260, 101, 37, 37);
            activityPlotOnMapButton.tag=kActivityPlotMapButton;
            locationInfoLabel1.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
            locationInfoLabel1.textColor=[SoclivityUtilities returnTextFontColor:5];
            locationInfoLabel2.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
            locationInfoLabel2.textColor=[SoclivityUtilities returnTextFontColor:5];
            locationInfoLabel1.text=activityObject.where_address;
            locationInfoLabel2.text=[NSString stringWithFormat:@"in %@",activityObject.where_zip];
            
            // Setting the variables for the map screen
            firstALineddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
            firstALineddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
            secondLineAddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
            secondLineAddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
            firstALineddressLabel.text = activityObject.where_address;
            secondLineAddressLabel.text = [NSString stringWithFormat:@"in %@",activityObject.where_zip];
            
            
        }
            break;
    }

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
    
    CGRect clearTextRect=CGRectMake(580, 20, 57, 30);
    CGRect mapURlRect=CGRectMake(370, 10, 270, 60);
    
    NSLog(@"Start Point_X=%f,Start Point_Y=%f",startPoint.x,startPoint.y);
    
    if((CGRectContainsPoint(profileImgView.frame,startPoint))||(CGRectContainsPoint(activityorganizerTextLabel.frame,startPoint))){
        [delegate pushUserProfileView];
    }
       
    if(CGRectContainsPoint(mapURlRect,startPoint) && !editMode){
        //[self openMapUrlApplication];
    }
        
    if(activityObject.activityRelationType==6){
        
        if(CGRectContainsPoint(clearTextRect,startPoint)&& editMode){
            [self customCancelButtonHit];
        }

    }
    
}   
#endif
-(IBAction)activityMapPlotButtonClicked:(id)sender{
    if((activityObject.activityRelationType==6)||(activityObject.activityRelationType==5)){
            [self ActivityEventOnMap];
        }
    
}

-(void)openMapUrlApplication{
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude, [activityObject.where_lat floatValue], [activityObject.where_lng floatValue]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

}

-(void)setUpLabelViewElements:(BOOL)show{
    
    
    if(show){
        
    [self.mapView removeAnnotations:self.mapView.annotations];

    firstALineddressLabel.hidden=YES;
    secondLineAddressLabel.hidden=YES;
    leftPinImageView.hidden=YES;
    searchTextLabel.hidden=NO;
    placeAndAddressLabel.hidden=NO;

    dropPinLabel.hidden=NO;
    touchAndHoldMapLabel.hidden=NO;
    verticalMiddleLine.hidden=NO;
    leftMagifyImageView.hidden=NO;
    rightPinImageView.hidden=NO;
    }
    else{
        
        firstALineddressLabel.hidden=NO;
        secondLineAddressLabel.hidden=NO;
        leftPinImageView.hidden=NO;
        searchTextLabel.hidden=YES;
        placeAndAddressLabel.hidden=YES;
        
        dropPinLabel.hidden=YES;
        touchAndHoldMapLabel.hidden=YES;
        verticalMiddleLine.hidden=YES;
        leftMagifyImageView.hidden=YES;
        rightPinImageView.hidden=YES;
        
    }
    
}
-(void)ActivityEventOnMap{
    SOC=[SoclivityManager SharedInstance];
    
    leftMagifyImageView.hidden=YES;
    firstTime=YES;
    searchTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    searchTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    placeAndAddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    placeAndAddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    dropPinLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    dropPinLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    touchAndHoldMapLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    touchAndHoldMapLabel.textColor=[SoclivityUtilities returnTextFontColor:5];



    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation=YES;
    searching=FALSE;
    self.addressSearchBar.text=@"";
    
    [self CurrentMapZoomUpdate];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(didLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    [lpgr release];

    [delegate slideInTransitionToLocationView];
#if 0
    
       if([SoclivityUtilities deviceType] & iPhone5)
        mapView.frame=CGRectMake(320, 0, 320, 404);//bug Fix
           else
        mapView.frame=CGRectMake(320, 0, 320, 316);//bug Fix
#endif
     
}
-(void)CurrentMapZoomUpdate{
    CLLocation* avgLoc = [self avgLocation];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(avgLoc.coordinate.latitude, avgLoc.coordinate.longitude), [self maxDistanceBetweenPoints:avgLoc], [self maxDistanceBetweenPoints:avgLoc]);
    adjustedRegion = [mapView regionThatFits:viewRegion];                
    [mapView setRegion:adjustedRegion animated:YES];
    
    _geocodingResults=[NSMutableArray new];
    
    _geocoder = [[CLGeocoder alloc] init];
    
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [activityObject.where_lat doubleValue];
    theCoordinate.longitude = [activityObject.where_lng doubleValue];
    
    ActivityAnnotation *sfAnnotation = [[[ActivityAnnotation alloc] initWithName:activityObject.where_address address:activityObject.where_zip coordinate:theCoordinate  firtsLine:@" " secondLine:@" " tagIndex:0 isDropped:NO]autorelease];
    [self.mapAnnotations insertObject:sfAnnotation atIndex:0];
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:0]];

}
-(IBAction)activityInfoButtonClicked:(id)sender{
    [self openMapUrlApplication];
}
- (void)gotoLocation
{
    [mapView setRegion:adjustedRegion animated:YES];
    
    //[self CurrentMapZoomUpdate];
    /*
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = SOC.currentLocation.coordinate.latitude;
    newRegion.center.longitude = SOC.currentLocation.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.06;
    newRegion.span.longitudeDelta = 0.06;
    
    [self.mapView setRegion:newRegion animated:YES];*/
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
        
        ActivityAnnotation *location = (ActivityAnnotation *) annotation;
        static NSString* SFAnnotationIdentifier = @"SFAnnotationIdentifier";
        static NSString* ActivityAnnotationIdentifier = @"ActivityAnnotationIdentifier";
        MKPinAnnotationView* pinView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        //if (!pinView)
        {
            MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
            reuseIdentifier:ActivityAnnotationIdentifier] autorelease];
            UIImage *flagImage=[UIImage imageNamed:@"S05.1_pinUnselected.png"];
            
            
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
            
            if(location.pinDrop){
                CGRect pinDropLabelRect=CGRectMake(10,0,80,16);
                UILabel *pinDropLabel=[[UILabel alloc] initWithFrame:pinDropLabelRect];
                pinDropLabel.textAlignment=UITextAlignmentCenter;
                pinDropLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
                pinDropLabel.textColor=[UIColor whiteColor];
                pinDropLabel.backgroundColor=[UIColor clearColor];
                pinDropLabel.text=@"Dropped Pin";
                annotationView.leftCalloutAccessoryView=pinDropLabel;
                [pinDropLabel release];

            }
            else{
            annotationView.leftCalloutAccessoryView=[self DrawAMapLeftAccessoryView:location];
            }

            annotationView.canShowCallout=YES;
            pinView.animatesDrop=YES;
            return annotationView;
        }
        /*else
         {
         pinView.annotation = annotation;
         }*/
        return pinView;
    }
    
    return nil;
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    MKAnnotationView *aV; 
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.mapView.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options:UIViewAnimationCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }
    
    if(pinDrop){
        
        //[self.mapView selectAnnotation:[[self.mapView annotations]lastObject] animated:YES];
        for (id<MKAnnotation> currentAnnotation in self.mapView.annotations) {       
            if ([currentAnnotation isKindOfClass:[ActivityAnnotation class]]) {
                [self.mapView selectAnnotation:currentAnnotation animated:YES];
                //[self.mapView selectAnnotation:[[self.mapView annotations] lastObject] animated:YES];
            }
        }
        
        //[self.mapView selectAnnotation:[[self.mapView annotations]lastObject] animated:YES];
    }
    else if(firstTime){
        for (id<MKAnnotation> currentAnnotation in self.mapView.annotations) {       
            if ([currentAnnotation isKindOfClass:[ActivityAnnotation class]]) {
                [self.mapView selectAnnotation:currentAnnotation animated:YES];
                //[self.mapView selectAnnotation:[[self.mapView annotations] lastObject] animated:YES];
            }
        }
        
    }

}


-(UIView*)DrawAMapLeftAccessoryView:(ActivityAnnotation *)locObject{
	
    CGSize  size = [locObject.businessAdress sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15]];
    
    if(size.width>300){
        size.width=300;
    }
	
    CGRect nameLabelRect=CGRectMake(5,0,size.width,16);
    UIView *mapLeftView=[[UIView alloc] initWithFrame:CGRectMake(0,0, size.width, 30)];
	UILabel *nameLabel=[[UILabel alloc] initWithFrame:nameLabelRect];
	nameLabel.textAlignment=UITextAlignmentCenter;
	nameLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
	nameLabel.textColor=[UIColor whiteColor];
	nameLabel.backgroundColor=[UIColor clearColor];
	nameLabel.text=locObject.businessAdress;
	[mapLeftView addSubview:nameLabel];
	[nameLabel release];
	
	
	
	return mapLeftView;
	
	
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
        return;
    }
    
    if(searching){
        
        ActivityAnnotation *loc=view.annotation;
        
        view.image=[UIImage imageNamed:@"S05.1_pinSelected.png"];
        
        //now ask the table to scrollAtThat Row in the table and become highlighted    
        pointTag=loc.annotTag;
        pointTag=pointTag%777;
        
        NSLog(@"pointTag=%d",pointTag);
        firstALineddressLabel.text=loc.businessAdress;
        secondLineAddressLabel.text=loc.infoActivity;
        [delegate enableDisableTickOnTheTopRight:YES];
        
        
#if LISTVIEWREMOVE        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:pointTag inSection:0];
        UITableViewCell* theCell = [locationResultsTableView cellForRowAtIndexPath:indexPath];
        
        theCell.contentView.backgroundColor=[SoclivityUtilities returnBackgroundColor:1];
        [locationResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [locationResultsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
#endif        
    }
    else if(firstTime){
        firstTime=FALSE;
        view.image=[UIImage imageNamed:@"S05.1_pinSelected.png"];
        
    }
    else if(pinDrop){
        ActivityAnnotation *loc=view.annotation;
        pointTag=loc.annotTag;
        pointTag=pointTag%777;

        view.image=[UIImage imageNamed:@"S05.1_pinSelected.png"];
        firstALineddressLabel.text=loc.businessAdress;
        secondLineAddressLabel.text=loc.infoActivity;
        [delegate enableDisableTickOnTheTopRight:YES];

        //pinDrop=FALSE;
    }

    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
        return;
    }
    if(searching){
        
        pinDrop=FALSE;
        ActivityAnnotation *loc=view.annotation;
        view.image=[UIImage imageNamed:@"S05.1_pinUnselected.png"];
        
        pointTag=loc.annotTag;
        pointTag=pointTag%777;
        
        firstALineddressLabel.text=@"Pick a Location";
        secondLineAddressLabel.text=@"Select a pin above to see it's full address";
        [delegate enableDisableTickOnTheTopRight:NO];
        
#if LISTVIEWREMOVE       
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:pointTag inSection:0];
        UITableViewCell* theCell = [locationResultsTableView cellForRowAtIndexPath:indexPath];
        
        theCell.contentView.backgroundColor=[UIColor clearColor];
        [locationResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [locationResultsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
#endif        
    }
    else if(pinDrop){
        ActivityAnnotation *loc=view.annotation;
        pointTag=loc.annotTag;
        pointTag=pointTag%777;

        pinDrop=FALSE;
        [self setUpLabelViewElements:YES];
        [delegate enableDisableTickOnTheTopRight:NO];
    }
    
}


- (void) didLongPress:(UILongPressGestureRecognizer *)gr {
    
    
    if(!editMode)
        return;
    
    if (gr.state == UIGestureRecognizerStateBegan) {
        
        // convert the touch point to a CLLocationCoordinate & geocode
        CGPoint touchPoint = [gr locationInView:self.mapView];
        CLLocationCoordinate2D coord = [self.mapView convertPoint:touchPoint 
                                         toCoordinateFromView:self.mapView];
        [self reverseGeocodeCoordinate:coord];
    }
}

- (void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coord {
    if ([_geocoder isGeocoding])
        [_geocoder cancelGeocode];
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coord.latitude 
                                                       longitude:coord.longitude];
    
    [self.mapView removeAnnotations:self.mapView.annotations];

    searching=FALSE;
    pinDrop=TRUE;

    ActivityAnnotation *sfAnnotation = [[[ActivityAnnotation alloc] initWithName:@" " address:@" " coordinate:coord firtsLine:@" " secondLine:@" " tagIndex:7770 isDropped:YES]autorelease];
    
    [self.mapView addAnnotation:sfAnnotation];

    
    [_geocoder reverseGeocodeLocation:location
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (!error)
                            [self processReverseGeocodingResults:placemarks];
                    }];
}

- (void) processReverseGeocodingResults:(NSArray *)placemarks {
    
    
    self.addressSearchBar.text=@"";
    [_geocodingResults removeAllObjects];
    //[self.mapView removeAnnotations:self.mapView.annotations];
          searching=FALSE;
    
    if([placemarks count]>0){
             CLPlacemark * placemark1 = [placemarks objectAtIndex:0];
            PlacemarkClass *placemark=[[[PlacemarkClass alloc]init]autorelease];
            placemark.latitude = placemark1.location.coordinate.latitude;
            placemark.longitude = placemark1.location.coordinate.longitude;
        NSLog(@"placemark.city=%@",[placemark1.addressDictionary objectForKey:@"City"]);
        NSLog(@"placemark.country=%@",placemark1.country);
        NSLog(@"placemark.subThoroughfare=%@",placemark1.subThoroughfare);
        NSLog(@"placemark.locality=%@",placemark1.locality);
        NSLog(@"placemark.subLocality=%@",placemark1.subLocality);
        NSLog(@"placemark.administrativeArea=%@",placemark1.administrativeArea);
        NSLog(@"placemark.subAdministrativeArea=%@",placemark1.subAdministrativeArea);
        NSLog(@"placemark.inlandWater=%@",placemark1.inlandWater);
        NSLog(@"placemark.ocean=%@",placemark1.ocean);
        NSLog(@"placemark.postalCode=%@",placemark1.postalCode);
        placemark.formattedAddress =ABCreateStringWithAddressDictionary(placemark1.addressDictionary, NO);

        NSLog(@"placemark.formattedAddress=%@",placemark.formattedAddress);
        placemark.formattedAddress = [placemark.formattedAddress stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        placemark.formattedAddress = [[placemark.formattedAddress componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        
        if([placemark1.addressDictionary objectForKey:@"City"]==nil||[[placemark1.addressDictionary objectForKey:@"City"] isEqualToString:@""]|| [[placemark1.addressDictionary objectForKey:@"City"] isEqualToString:@"(null)"])
        {
        
        }else{
            NSString *param = nil;
            NSRange start = [placemark.formattedAddress rangeOfString:[placemark1.addressDictionary objectForKey:@"City"]];
            if (start.location != NSNotFound)
            {
                param=[placemark.formattedAddress substringWithRange:NSMakeRange(0, start.location)];
                placemark.formattedAddress=param;

            
           }
        }
        NSString * zipAddress=nil;
        
        if(placemark1.postalCode==nil || [placemark1.postalCode isEqualToString:@""]){
            zipAddress=[NSString stringWithFormat:@"%@ %@",[placemark1.addressDictionary objectForKey:@"City"],placemark1.administrativeArea];
            
        }
        else{
          zipAddress=[NSString stringWithFormat:@"%@ %@ %@",[placemark1.addressDictionary objectForKey:@"City"],placemark1.administrativeArea,placemark1.postalCode];
        }
          placemark.vicinityAddress =zipAddress;
        NSArray *stringValues=[placemark.vicinityAddress componentsSeparatedByString:@" "];
        NSMutableArray*mutableArray=[NSMutableArray arrayWithArray:stringValues];
        NSArray *copy = [mutableArray copy];
        NSInteger index = [copy count] - 1;
        for (id object in [copy reverseObjectEnumerator]) {
            if ([mutableArray indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
                [mutableArray removeObjectAtIndex:index];
            }
            index--;
        }
        [copy release];
        NSMutableString*zipString=[NSMutableString string];
        for(NSString*duplicate in mutableArray){
            
            if(duplicate==nil||[duplicate isEqualToString:@""]|| [duplicate isEqualToString:@"(null)"])
            
                    NSLog(@"dont add nil or null values");
             else
                [zipString appendString:duplicate];
        }
        NSLog(@"Zip=%@",zipString);
           placemark.vicinityAddress =zipString;
            [_geocodingResults addObject:placemark];
    }     
        if([_geocodingResults count]>0){
            searching=FALSE;
            
            pinDrop=TRUE;
            
                
                for (id<MKAnnotation> currentAnnotation in self.mapView.annotations) {       
                    if ([currentAnnotation isKindOfClass:[ActivityAnnotation class]]) {
                        NSLog(@"annotation %@", currentAnnotation);
                        
                                ActivityAnnotation *location = (ActivityAnnotation *) currentAnnotation;
                         PlacemarkClass * placemark = [_geocodingResults objectAtIndex:0];
                        
                        NSString * formattedAddress = [NSString stringWithFormat:@"%@",placemark.formattedAddress];
                        NSString * zipAddress=[NSString stringWithFormat:@"%@",placemark.vicinityAddress];
                        CLLocationCoordinate2D theCoordinate;
                        theCoordinate.latitude = placemark.latitude;
                        theCoordinate.longitude =placemark.longitude;
                        
                        location.businessAdress=formattedAddress;
                        location.infoActivity=zipAddress;
                        
                        [self setUpLabelViewElements:NO];
                        
                        firstALineddressLabel.text=location.businessAdress;
                        secondLineAddressLabel.text=location.infoActivity;

                }
            }

            //[self addPinAnnotationForPlacemark:_geocodingResults droppedStatus:YES];
            currentLocationArray =[NSMutableArray arrayWithCapacity:[_geocodingResults count]];
            currentLocationArray=[_geocodingResults retain];
            
            //Zoom in all results.
/*            
            CLLocation* avgLoc = [self ZoomToAllResultPointsOnMap];
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(avgLoc.coordinate.latitude, avgLoc.coordinate.longitude), [self maxDistanceBetweenAllResultPointsOnMap:avgLoc], [self maxDistanceBetweenAllResultPointsOnMap:avgLoc]);
            MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
            [mapView setRegion:adjustedRegion animated:YES];*/
            

//            firstALineddressLabel.text=@"Pick a Location";
//            secondLineAddressLabel.text=@"Select a pin above to see it's full address";

            
        }
        
#if LISTVIEWREMOVE
        [self showSearchBarAndAnimateWithListViewInMiddle];
        [locationResultsTableView reloadData];
#endif    

}

#if TESTING
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
#else

-(void) geocodeFromSearchBar{
    // in case of error use api key like 
    
    responseData = [[NSMutableData data] retain];
	 NSString*urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?keyword=%@&location=%f,%f&rankby=distance&sensor=false&key=AIzaSyDYk5wlP6Pg6uA7PGJn853bnIj5Y8bmNnk",[addressSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude];
	
	
    // Create NSURL string from formatted string
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	
   [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
#if 0    

    
    NSString *urlString4 = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&radius=50&types=food&name=harbour&sensor=false&key=AIzaSyDYk5wlP6Pg6uA7PGJn853bnIj5Y8bmNnk"];
	// http://maps.google.com/maps/geo?q=%@&output=csv&key=YourGoogleMapsAPIKey
    NSString *urlString3 = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&key=AIzaSyDYk5wlP6Pg6uA7PGJn853bnIj5Y8bmNnk", 
                           [addressSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *urlString1 = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=Winnetka&bounds=34.172684,-118.604794|34.236144,-118.500938&sensor=false"];
    
    
    NSString *urlString2 = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?keyword=coffee&location=37.16107,-122.806618&rankby=distance&sensor=false&key=AIzaSyDYk5wlP6Pg6uA7PGJn853bnIj5Y8bmNnk"];
    
    NSString *urlString3=[NSString stringWithFormat@"http://maps.googleapis.com/maps/api/geocode/xml?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=true"];
    
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
    double latitude = 0.0;
    double longitude = 0.0;
	
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
		//Show error
		NSLog(@"error:address not found");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Address not found"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];		
    }
#endif   
}
#endif
- (void) processForwardGeocodingResults:(NSArray *)placemarks {
    [_geocodingResults removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];

    
    searching=FALSE;
    
    if([placemarks count]>0){
        
        
        
        for (CLPlacemark *placemark in placemarks){
            
            PlacemarkClass *placemark1=[[[PlacemarkClass alloc]init]autorelease];
            placemark1.formattedAddress =ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            placemark1.latitude  = placemark.location.coordinate.latitude;
            placemark1.longitude = placemark.location.coordinate.longitude;

            
            placemark1.formattedAddress =ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            placemark1.vicinityAddress =placemark.postalCode;
            [_geocodingResults addObject:placemark1];

        }
        
    }
    
    if([_geocodingResults count]>0){
        searching=TRUE;
        [self addPinAnnotationForPlacemark:_geocodingResults droppedStatus:NO];
        currentLocationArray =[NSMutableArray arrayWithCapacity:[_geocodingResults count]];
        currentLocationArray=[_geocodingResults retain];
        
        //Zoom in all results.
        
        CLLocation* avgLoc = [self ZoomToAllResultPointsOnMap];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(avgLoc.coordinate.latitude, avgLoc.coordinate.longitude), [self maxDistanceBetweenAllResultPointsOnMap:avgLoc], [self maxDistanceBetweenAllResultPointsOnMap:avgLoc]);
        adjustedRegion = [mapView regionThatFits:viewRegion];
        [mapView setRegion:adjustedRegion animated:YES];
        
        [self setUpLabelViewElements:NO];
        firstALineddressLabel.text=@"Pick a Location";
        secondLineAddressLabel.text=@"Select a pin above to see it's full address";
        
    }
    
#if LISTVIEWREMOVE
    [self showSearchBarAndAnimateWithListViewInMiddle];
    [locationResultsTableView reloadData];
#endif    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	NSLog(@"Connection failed: %@", [error description]);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
													message:@"Try Again Later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
	return;
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	[connection release];
    
    [_geocodingResults removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];

    searching=FALSE;
    NSDictionary* resultsd = [[[NSString alloc] initWithData:responseData 
                                               encoding:NSUTF8StringEncoding] JSONValue];
    
     NSDictionary *dict = [resultsd objectForKey:@"results"];
    
    for(id object in dict){
        PlacemarkClass *placemark=[[[PlacemarkClass alloc]init]autorelease];
        NSDictionary *geometryDict = [object objectForKey:@"geometry"];
        placemark.latitude = [[[geometryDict objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        placemark.longitude = [[[geometryDict objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        
        placemark.formattedAddress =[object objectForKey:@"name"];
        placemark.vicinityAddress =[object objectForKey:@"vicinity"];
        [_geocodingResults addObject:placemark];
    }
    
    if([_geocodingResults count]>0){
        searching=TRUE;
        [self addPinAnnotationForPlacemark:_geocodingResults droppedStatus:NO];
        currentLocationArray =[NSMutableArray arrayWithCapacity:[_geocodingResults count]];
        currentLocationArray=[_geocodingResults retain];
        
        //Zoom in all results.
        
        CLLocation* avgLoc = [self ZoomToAllResultPointsOnMap];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(avgLoc.coordinate.latitude, avgLoc.coordinate.longitude), [self maxDistanceBetweenAllResultPointsOnMap:avgLoc], [self maxDistanceBetweenAllResultPointsOnMap:avgLoc]);
        adjustedRegion = [mapView regionThatFits:viewRegion];                
        [mapView setRegion:adjustedRegion animated:YES];
        
        [self setUpLabelViewElements:NO];
        firstALineddressLabel.text=@"Pick a Location";
        secondLineAddressLabel.text=@"Select a pin above to see it's full address";
        
    }

#if LISTVIEWREMOVE
    [self showSearchBarAndAnimateWithListViewInMiddle];
    [locationResultsTableView reloadData];
#endif

	
	[responseData release];
	
}

-(CLLocation*)ZoomToAllResultPointsOnMap{
    CGFloat xAvg=0;
    CGFloat yAvg=0;
    for (int i=0; i<currentLocationArray.count; i++) {
        
#if TESTING        
        CLPlacemark * placemark = [currentLocationArray objectAtIndex:i];
        xAvg+=placemark.location.coordinate.latitude;
        yAvg+=placemark.location.coordinate.longitude;
#else
  PlacemarkClass * placemark = [currentLocationArray objectAtIndex:i];
        xAvg+=placemark.latitude;
        yAvg+=placemark.longitude;

#endif        
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
            
#if TESTING
            CLPlacemark * placemark = [currentLocationArray objectAtIndex:i];
            newCenter = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude
                                                   longitude:placemark.location.coordinate.longitude];
#else
            PlacemarkClass * placemark = [currentLocationArray objectAtIndex:i];
            newCenter = [[CLLocation alloc] initWithLatitude:placemark.latitude
                                                   longitude:placemark.longitude];
            
#endif
            distance =(distance>[avgLocation distanceFromLocation:(CLLocation*)newCenter]?distance:[avgLocation distanceFromLocation:(CLLocation*)newCenter]);
        }
        return 2*distance;
    }
}
- (void) addPinAnnotationForPlacemark:(NSArray*)placemarks droppedStatus:(BOOL)droppedStatus {
    
    for(int i=0;i<[placemarks count];i++){
        
#if TESTING        
        CLPlacemark * placemark = [placemarks objectAtIndex:i];
        NSString * formattedAddress = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
        NSString * zipAddress=[NSString stringWithFormat:@"%@ %@ %@",placemark.subLocality,placemark.subAdministrativeArea,placemark.postalCode];
        CLLocationCoordinate2D theCoordinate=placemark.location.coordinate;

#else
     PlacemarkClass * placemark = [placemarks objectAtIndex:i];
        NSString * formattedAddress = [NSString stringWithFormat:@"%@",placemark.formattedAddress];
        NSString * zipAddress=[NSString stringWithFormat:@"%@",placemark.vicinityAddress];
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = placemark.latitude;
        theCoordinate.longitude =placemark.longitude;


#endif        
        NSString*tryIndex=[NSString stringWithFormat:@"777%d",i];
        ActivityAnnotation *sfAnnotation = [[[ActivityAnnotation alloc] initWithName:formattedAddress address:zipAddress coordinate:theCoordinate firtsLine:@" " secondLine:@" " tagIndex:[tryIndex intValue] isDropped:droppedStatus]autorelease];
        
        [self.mapView addAnnotation:sfAnnotation];
        
        
    }
}
#if TESTING
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
#else
-(void) zoomMapToPlacemark:(PlacemarkClass *)selectedPlacemark {
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = selectedPlacemark.latitude;
    coordinate.longitude =selectedPlacemark.longitude;

    //CLLocationCoordinate2D coordinate = selectedPlacemark.location.coordinate;
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    double radius = (MKMapPointsPerMeterAtLatitude(coordinate.latitude) * 2)/2;
    MKMapSize size = {radius, radius};
    MKMapRect mapRect = {mapPoint, size};
    mapRect = MKMapRectOffset(mapRect, -radius/2, -radius/2); // adjust the rect so the coordinate is in the middle
    [self.mapView setVisibleMapRect:mapRect
                           animated:YES];
}
#endif
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

    
    if([SoclivityUtilities deviceType] & iPhone5)
        mapView.frame=CGRectMake(320, 44, 320,360);//bug Fix
else
    mapView.frame=CGRectMake(320, 44, 320,272);
#if 0
#if LISTVIEWREMOVE 
    [locationResultsTableView setHidden:NO];
#endif    
    if (!footerActivated) {
		[UIView beginAnimations:@"expandFooter" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		
		// Resize the map.
		CGRect mapFrame = [self.mapView frame];
        mapFrame.size.height-=60;
        mapFrame.origin.y += 44;
		[self.mapView setFrame:mapFrame];
#if LISTVIEWREMOVE        
        CGRect tableViewFrame = [locationResultsTableView frame];
		tableViewFrame.origin.y -= 188;
		[locationResultsTableView setFrame:tableViewFrame];
#endif
        
        [self.addressSearchBar setHidden:NO];
        
		[UIView commitAnimations];
		footerActivated = YES;
	}
#endif
}
-(void)hideSearchBarAndAnimateWithListViewInMiddle{
 
    if([SoclivityUtilities deviceType] & iPhone5)
        mapView.frame=CGRectMake(320, 0, 320, 404);//bug Fix
    else
    mapView.frame=CGRectMake(320, 0, 320, 316);
#if 0    
    if (footerActivated) {
		[UIView beginAnimations:@"collapseFooter" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		
		// Resize the map.
		CGRect mapFrame = [self.mapView frame];
		mapFrame.origin.y -= 44;
        mapFrame.size.height+=60;

		[self.mapView setFrame:mapFrame];
#if LISTVIEWREMOVE        
        CGRect tableViewFrame = [locationResultsTableView frame];
		tableViewFrame.origin.y += 188;
		[locationResultsTableView setFrame:tableViewFrame];
        
        [locationResultsTableView setHidden:YES];
#endif
        
        [self.addressSearchBar setHidden:YES];

		[UIView commitAnimations];
		footerActivated = NO;
	}
#endif
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
    
    
    [self.addressSearchBar resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    [self geocodeFromSearchBar];

}
-(void)customCancelButtonHit{
    
    
    //[self cancelClicked];
    searching=FALSE;
    self.addressSearchBar.text=@"";
    self.addressSearchBar.showClearButton=NO;
    [addressSearchBar setShowsCancelButton:NO animated:YES];
    [self.addressSearchBar resignFirstResponder];
    [self setUpLabelViewElements:YES];
    [delegate enableDisableTickOnTheTopRight:NO];

}

#if LISTVIEWREMOVE
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
#if TESTING        
     CLPlacemark * placemark = [_geocodingResults objectAtIndex:indexPath.row];
        NSString * formattedAddress = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
        NSString * zipAddress=[NSString stringWithFormat:@"%@ %@ %@",placemark.subLocality,placemark.subAdministrativeArea,placemark.postalCode];
#else
      PlacemarkClass * placemark = [_geocodingResults objectAtIndex:indexPath.row];
      
        NSString * formattedAddress=placemark.formattedAddress;
        NSString * zipAddress=placemark.vicinityAddress;
#endif 
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
        zipStreetLabel.text=zipAddress;
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
        pointTag=[[NSString stringWithFormat:@"777%d",indexPath.row]intValue];
    UITableViewCell* theCell = [tableView cellForRowAtIndexPath:indexPath];
    
    theCell.contentView.backgroundColor=[SoclivityUtilities returnBackgroundColor:1];
        
 #if TESTING       
    CLPlacemark * selectedPlacemark = [_geocodingResults objectAtIndex:indexPath.row];
        [self zoomMapToPlacemark:selectedPlacemark];
#else
        PlacemarkClass * placemark = [_geocodingResults objectAtIndex:indexPath.row];
        [self zoomMapToPlacemark:placemark];
#endif
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}
#endif
-(void)setNewLocation{
    
    #if TESTING
CLPlacemark * selectedPlacemark = [_geocodingResults objectAtIndex:pointTag];
    activityObject.where_lat=[NSString stringWithFormat:@"%f",selectedPlacemark.location.coordinate.latitude];
    activityObject.where_lng=[NSString stringWithFormat:@"%f",selectedPlacemark.location.coordinate.longitude];
    NSString * formattedAddress = ABCreateStringWithAddressDictionary(selectedPlacemark.addressDictionary, NO);
    NSString * zipAddress=[NSString stringWithFormat:@"%@ %@ %@",selectedPlacemark.subLocality,selectedPlacemark.subAdministrativeArea,selectedPlacemark.postalCode];
    CLLocation *tempLocObj = [[CLLocation alloc] initWithLatitude:selectedPlacemark.location.coordinate.latitude
                                                        longitude:selectedPlacemark.location.coordinate.longitude];


    #else
    PlacemarkClass * selectedPlacemark = [currentLocationArray objectAtIndex:pointTag];
    activityObject.where_lat=[NSString stringWithFormat:@"%f",selectedPlacemark.latitude];
    activityObject.where_lng=[NSString stringWithFormat:@"%f",selectedPlacemark.longitude];
    NSString * formattedAddress = [NSString stringWithFormat:@"%@",selectedPlacemark.formattedAddress];
    NSString * zipAddress=[NSString stringWithFormat:@"%@",selectedPlacemark.vicinityAddress];
    CLLocation *tempLocObj = [[CLLocation alloc] initWithLatitude:selectedPlacemark.latitude
                                                        longitude:selectedPlacemark.longitude];


#endif
    activityObject.where_address=formattedAddress;
    activityObject.where_zip=zipAddress;
    locationInfoLabel1.text=firstALineddressLabel.text=formattedAddress;
    locationInfoLabel2.text=secondLineAddressLabel.text=zipAddress;
    
    
    CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:SOC.currentLocation.coordinate.latitude
                                                       longitude:SOC.currentLocation.coordinate.longitude];
    
    activityObject.distance =[NSString stringWithFormat:@"%.02f",[newCenter distanceFromLocation:tempLocObj] / 1000];

     pinDrop=FALSE;
     self.mapView.showsUserLocation=YES;
     firstTime=TRUE;
     searching=FALSE;
    [self CurrentMapZoomUpdate];
    
    
    // also make sure you update the database for list and map View and refresh the list and map state
    
    [SoclivitySqliteClass UpadateTheActivityEventTable:activityObject];
    SOC.localCacheUpdate=TRUE;
     
}
-(void)cancelClicked{
    
    firstTime=TRUE;
    
    if (footerActivated) {
		[UIView beginAnimations:@"collapseFooter" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		
		// Resize the map.
		CGRect mapFrame = [self.mapView frame];
		mapFrame.size.height += 60;
        mapFrame.origin.y -= 44;
		[self.mapView setFrame:mapFrame];
#if LISTVIEWREMOVE       
        CGRect tableViewFrame = [locationResultsTableView frame];
		tableViewFrame.origin.y += 188;
		[locationResultsTableView setFrame:tableViewFrame];
        
        [locationResultsTableView setHidden:YES];
#endif        
        [UIView commitAnimations];
		footerActivated = NO;
	}
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
