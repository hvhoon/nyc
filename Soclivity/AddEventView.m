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

@implementation AddEventView
@synthesize activityObject,delegate;

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
    locationInfoLabel1.frame = CGRectMake(84, 102+1, 175, 15);

    locationInfoLabel2.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel2.textColor=[SoclivityUtilities returnTextFontColor:5];
    locationInfoLabel2.frame = CGRectMake(84, 122, 175, 15);
    
    
    
    switch (info.activityRelationType) {
        case 1:
        {
            locationInfoLabel1.text=info.distance;
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
            locationInfoLabel1.text=info.where_address;
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
    
    
    
    NSLog(@"Start Point_X=%f,Start Point_Y=%f",startPoint.x,startPoint.y);
        CGRect tapDescriptionSection =CGRectMake(40, 70, 240, 60);
        
        
        
        if(CGRectContainsPoint(tapDescriptionSection,startPoint)){
            //[self setOpened];
        }
    }
    
#endif

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [calendarIcon release];
    [clockIcon release];
    [locationIcon release];
    [super dealloc];
}
@end
