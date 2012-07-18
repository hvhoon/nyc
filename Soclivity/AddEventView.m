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
    
    locationInfoLabel.hidden=YES;
#if 1   
        switch (info.type) {
            case 1:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S05_green-bar.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S05_green-box.png"];
                
                
            }
                break;
            case 2:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S05_yellow-bar.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S05_yellow-box.png"];
                
                
            }
                break;
            case 3:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S05_purple-bar.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S05_purple-box.png"];
                
                
            }
                break;
            case 4:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S05_red-bar.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S05_red-box.png"];
                
                
            }
                break;
            case 5:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S05_aqua-marine-bar.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S05_aqua-marine-box.png"];
            }
                break;
                
                
                
        }
#endif    
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
    activityorganizerTextLabel.frame=CGRectMake(102, 23, size.width, 16);
    
    // Activity organizer DOS
    DOSConnectionImgView.frame=CGRectMake(102+6+size.width, 24, 21, 12);
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
    }
    
    if((info.what==(NSString*)[NSNull null])||([info.what isEqualToString:@""]||info.what==nil)||([info.what isEqualToString:@"(null)"])){
        activityTextLabel.text=@"No description given.";
    }
    else
     activityTextLabel.text = info.what;
    
    activityTextLabel.numberOfLines = 0;
    activityTextLabel.lineBreakMode = UILineBreakModeWordWrap;

	activityTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    activityTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    activityTextLabel.backgroundColor=[UIColor clearColor];

    
    CGSize labelSize = [activityTextLabel.text sizeWithFont:activityTextLabel.font constrainedToSize:activityTextLabel.frame.size 
            lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat labelHeight = labelSize.height;
    
    
    
    int lines = labelHeight/14;
    
    if(lines>3){
        //time to bother
        collapse=TRUE;
        delta=labelHeight-42;
        yTextLabel=42.0f;
    }
    else{
        yTextLabel=labelHeight;
        collapse=FALSE;
    }
    NSLog(@"lines=%d",lines);
	[activityTextLabel setFrame:CGRectMake(40, 80, 240, yTextLabel)];

    
    // Privacy icons
    if ([info.access isEqualToString:@"public"]){
            activityAccessStatusImgView.image=[UIImage imageNamed:@"S05_public.png"];
    }
    else {
            activityAccessStatusImgView.image=[UIImage imageNamed:@"S05_private.png"];
    }
    
    calendarDateLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    calendarDateLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    activityTimeLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    activityTimeLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    distanceLocationLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    distanceLocationLabel.textColor=[SoclivityUtilities returnTextFontColor:5];

    locationInfoLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    locationInfoLabel.textColor=[SoclivityUtilities returnTextFontColor:5];


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
    calendarDateLabel.text=prefixDateString;
   [prefixDateFormatter setDateFormat:@"h:mm a"];
    NSString *prefixTimeString = [prefixDateFormatter stringFromDate:date];
    activityTimeLabel.text=prefixTimeString;


    distanceLocationLabel.text=info.distance;
    locationInfoLabel.text=info.where_address;
    
    
        

#if 0        
    
    whatDescTextView.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    whatDescTextView.text=info.what;
    whatDescTextView.editable=NO;
    whatDescTextView.scrollEnabled=NO;
    whatDescTextView.textAlignment=UITextAlignmentLeft;
    whatDescTextView.tag=23;
    whatDescTextView.textColor=[SoclivityUtilities returnTextFontColor:5];
    whatDescTextView.backgroundColor=[UIColor clearColor];
    whatDescTextView.autocorrectionType=UITextAutocorrectionTypeNo;
    [whatDescTextView sizeToFit];
    whatDescTextView.contentInset = UIEdgeInsetsMake(-12.0,0.0,0,0.0);

    
    size = [info.activityName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
    NSLog(@"width=%f",size.width);
    activityTextLabel.frame=CGRectMake(50, 6, size.width, size.height);
    activityTextLabel.text=info.activityName;
    
    activityBarTextImgView.frame=CGRectMake(50+size.width+5, 12, 26, 9);
    
    
    activityTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    activityTextLabel.textColor=[SoclivityUtilities returnTextFontColor:1];

        activityCreatedImgView.frame=CGRectMake(119+5+size.width, 246, 75, 9);
        
        peopleYouKnowCountLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:13];
        peopleYouKnowCountLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        peopleYouKnowCountLabel.text=[NSString stringWithFormat:@"You have %d friends going",info.DOS1];
        
        peopleYouMayKnowCountLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:13];
        peopleYouMayKnowCountLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        peopleYouMayKnowCountLabel.text=[NSString stringWithFormat:@"You may know %d people going",info.DOS2];
        
        
        
        
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        
        
        NSDate *activityDate = [dateFormatter dateFromString:info.when];
        
        NSDate *date = activityDate;
        NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [prefixDateFormatter setDateFormat:@"h:mm a | EEE, MMM d"];
        NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
        NSDateFormatter *monthDayFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [monthDayFormatter setDateFormat:@"d"];         
        int date_day = [[monthDayFormatter stringFromDate:date] intValue];      
        NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
        NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
        NSString *suffix = [suffixes objectAtIndex:date_day];   
        NSString *dateString = [prefixDateString stringByAppendingString:suffix];       
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:activityDate];
        NSInteger year = [components year];
        dateString=[dateString stringByAppendingFormat:@" %d",year];
        NSLog(@"%@", dateString);
        
        
        whenActivityLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
        whenActivityLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        whenActivityLabel.text=dateString;
        
        
        whereAddressActivityLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
        whereAddressActivityLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        whereAddressActivityLabel.text=info.where_address;
        size = [info.where_address sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14]];
		NSLog(@"width=%f",size.width);
        if(size.width+105>310){
            size.width=size.width-310;
        }
        whereAddressActivityLabel.frame=CGRectMake(91, 166, size.width, size.height);
        
        
        
        
#endif        
        
        
                
#pragma mark -
#pragma mark Profile Picture Functions
// Profile picture loading functions
}
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
    if(image.size.height > 74 || image.size.width > 74)
        profileImgView.image = [SoclivityUtilities compressImage:image size:CGSizeMake(74,74)];
    
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
            [self setOpened];
        }
    }
    
#endif


-(void)setOpened{
    
    if(collapse){
    opened=!opened;
    if(opened){
    CGRect acessImageFrame = activityAccessStatusImgView.frame;
    acessImageFrame.origin.y=154.0f;
    CGRect barImageFrame = activityBarImgView.frame;
    barImageFrame.size.height=185.0f;
    CGRect boxImageFrame = backgroundBoxImgView.frame;
    boxImageFrame.size.height=109;

    CGRect whatTextFrame = activityTextLabel.frame;
    whatTextFrame.size.height=yTextLabel+delta;
        
    CGRect bottomViewFrame = bottomView.frame;
    bottomViewFrame.origin.y=bottomView.frame.origin.y+30;


    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         activityAccessStatusImgView.frame = acessImageFrame;
                         activityBarImgView.frame=barImageFrame;
                         backgroundBoxImgView.frame=boxImageFrame;
                         activityTextLabel.frame=whatTextFrame;
                         bottomView.frame=bottomViewFrame;
                     } 
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    }
    else{
        CGRect acessImageFrame = activityAccessStatusImgView.frame;
        acessImageFrame.origin.y=123.0f;
        CGRect barImageFrame = activityBarImgView.frame;
        barImageFrame.size.height=150.0f;
        CGRect boxImageFrame = backgroundBoxImgView.frame;
        boxImageFrame.size.height=109;
        CGRect whatTextFrame = activityTextLabel.frame;
        whatTextFrame.size.height=yTextLabel;
        CGRect bottomViewFrame = bottomView.frame;
        bottomViewFrame.origin.y=bottomView.frame.origin.y-30;


        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             activityAccessStatusImgView.frame = acessImageFrame;
                             activityBarImgView.frame=barImageFrame;
                             backgroundBoxImgView.frame=boxImageFrame;
                             activityTextLabel.frame=whatTextFrame;
                             bottomView.frame=bottomViewFrame;
                             
                         } 
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
        
    }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
