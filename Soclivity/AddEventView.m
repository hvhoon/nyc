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
- (id)initWithFrame:(CGRect)frame info:(InfoActivityClass*)info
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed: @"AddEventView" owner:self options: nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
        
        switch (info.type) {
            case 1:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S5_green-bar.png"];
                activityBarTextImgView.image=[UIImage imageNamed:@"S5_play.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S5_green-box.png"];
                
                
            }
                break;
            case 2:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S5_yellow-bar.png"];
                activityBarTextImgView.image=[UIImage imageNamed:@"S5_play.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S5_yellow-box.png"];
                
                
            }
                break;
            case 3:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S5_purple-bar.png"];
                activityBarTextImgView.image=[UIImage imageNamed:@"S5_play.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S5_purple-box.png"];
                
                
            }
                break;
            case 4:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S5_red-bar.png"];
                activityBarTextImgView.image=[UIImage imageNamed:@"S5_play.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S5_red-box.png"];
                
                
            }
                break;
            case 5:
            {
                activityBarImgView.image=[UIImage imageNamed:@"S5_aqua-marine-bar.png"];
                activityBarTextImgView.image=[UIImage imageNamed:@"S5_play.png"];
                backgroundBoxImgView.image=[UIImage imageNamed:@"S5_aqua-marine-box.png"];
            }
                break;
                
                
                
        }
        
        activityTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
        activityTextLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        CGSize size = [info.activityName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
		NSLog(@"width=%f",size.width);
        activityTextLabel.frame=CGRectMake(50, 50, size.width, size.height);
        activityTextLabel.text=info.activityName;
        
        activityBarTextImgView.frame=CGRectMake(50+size.width+5, 56, 26, 9);
        
        goingCountLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
        goingCountLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        goingCountLabel.text=[NSString stringWithFormat:@"%d People going",info.num_of_people];
        
        activityorganizerTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:11];
        activityorganizerTextLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        activityorganizerTextLabel.text=[NSString stringWithFormat:@"%@",info.organizerName];
         size = [info.organizerName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:11]];
		NSLog(@"width=%f",size.width);
        activityorganizerTextLabel.frame=CGRectMake(119, 290, size.width, 11);
        activityCreatedImgView.frame=CGRectMake(119+5+size.width, 290, 75, 9);
        
        peopleYouKnowCountLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:13];
        peopleYouKnowCountLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        peopleYouKnowCountLabel.text=[NSString stringWithFormat:@"You have %d friends going",info.DOS1];
        
        peopleYouMayKnowCountLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:13];
        peopleYouMayKnowCountLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        peopleYouMayKnowCountLabel.text=[NSString stringWithFormat:@"You may know %d people going",info.DOS2];




		whatDescTextView.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
		whatDescTextView.text=[NSString stringWithFormat:@"%@",@"cghchgc ffhvf nbtyfhv nbfhvnvn jvn vn jkvn jhkvn jkhvbn kuvbn hvh njh n hjvnvhkjvbnvfhvnvhfhvbvhvh"];
		whatDescTextView.editable=NO;
		whatDescTextView.scrollEnabled=NO;
		whatDescTextView.textAlignment=UITextAlignmentLeft;
		whatDescTextView.tag=23;
		whatDescTextView.textColor=[SoclivityUtilities returnTextFontColor:1];
		whatDescTextView.backgroundColor=[UIColor clearColor];
		whatDescTextView.autocorrectionType=UITextAutocorrectionTypeNo;
        [whatDescTextView sizeToFit];
        whatDescTextView.contentInset = UIEdgeInsetsMake(-12.0,0.0,0,0.0);
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        
        
        NSDate *activityDate = [dateFormatter dateFromString:info.when];

        NSDate *date = activityDate;
        NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [prefixDateFormatter setDateFormat:@"h:mm | EEE, MMM d"];
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
        whereAddressActivityLabel.frame=CGRectMake(105, 210, size.width, size.height);

        
        
        UIImage *imageProfile=[UIImage imageNamed:@"p1.png"];
        
        if(imageProfile.size.height != imageProfile.size.width)
            imageProfile = [SoclivityUtilities autoCrop:imageProfile];
        
        // If the image needs to be compressed
        if(imageProfile.size.height > 80 || imageProfile.size.width > 84)
            profileImgView.image = [SoclivityUtilities compressImage:imageProfile size:CGSizeMake(84,80)];
        


        

        switch (info.DOS){
            case 1:
                DOSConnectionImgView.image=[UIImage imageNamed:@"S5_DOS-1.png"];
                break;
                
            case 2:
                DOSConnectionImgView.image=[UIImage imageNamed:@"S5_DOS-2.png"];
                break;

                
            default:
                break;
        }



       // Initialization code
    }
    return self;
}
-(IBAction)backButtonPressed:(id)sender{
    [delegate pushToHomeViewController];
}

-(IBAction)addEventActivityPressed:(id)sender{
    
}
-(IBAction)OneDOSFriendListSelect:(id)sender{
    
}
#if 0
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self];
    NSLog(@"Start Point_X=%f,Start Point_Y=%f",startPoint.x,startPoint.y);
        CGRect tapLowerPaneRect =CGRectMake(70, 402, 320, 58);
        CGRect tapClearSearchRect =CGRectMake(270, 44, 57, 30);
        
        
        
        if(CGRectContainsPoint(tapClearSearchRect,startPoint)){
            
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

@end
