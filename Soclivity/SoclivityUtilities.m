//
//  SoclivityUtilities.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoclivityUtilities.h"
#import "UIImage+ProportionalFill.h"
#import "UIImage+Tint.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "InfoActivityClass.h"
#import "DetailInfoActivityClass.h"
#import "SoclivityManager.h"
#import "FilterPreferenceClass.h"

#define PASSWORD_LENGTH 6

@implementation SoclivityUtilities

static NSArray *playerActivityDetails;
+(void)setPlayerActivities:(NSArray *)_data{
    playerActivityDetails = [[NSArray alloc]autorelease];
    playerActivityDetails = [_data copy];
    
}
+(NSArray *)getPlayerActivities{
    return playerActivityDetails;
    
}

+(NSString*)getStartAndFinishTimeLabel:(float)sliderValue{
    float timeValue=sliderValue*48/10;
    int timer=lroundf(timeValue);
    //int value1=value;
    //float theFloat = 5.3456;
    //int rounded = lroundf(theFloat); NSLog(@"%d",rounded);
    //int roundedUp = ceil(theFloat); NSLog(@"%d",roundedUp);
    //int roundedDown = floor(theFloat); NSLog(@"%d",roundedDown);

    NSMutableString * result = [[NSMutableString new] autorelease];
    NSLog(@"%d",timer);
if(timer%2==0){
                timer=timer/2;
        if(timer>=12){
                if(timer==12){
                    [result appendFormat:@"%d:00 PM",timer];
            }
                else if(timer==24){
                    [result appendFormat:@"%d:00 AM",12];
            }
                else{
                    timer=timer-12;
                    [result appendFormat:@"%d:00 PM",timer];
            }
            
            
}
 else{
        if(timer==0){
                    [result appendFormat:@"%d:00 AM",12];
            }
                else
                    [result appendFormat:@"%d:00 AM",timer];
        }
    }
        else{
                        timer=timer/2;
            if(timer>=12){
                        if(timer==12){
                            [result appendFormat:@"%d:30 PM",timer];

                        }
                        else{
                            timer=timer-12;
                            [result appendFormat:@"%d:30 PM",timer];
                        }
                }
          else{
                            [result appendFormat:@"%d:30 AM",timer];
            }
    }
    
    return result;

}

+(NSString*)lastUpdate:(NSString*)time{
#if 1    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    // how to get back time from current time in the same format
    
    NSDate *lastDate = [dateFormatter dateFromString:time];//add the string
    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate=[dateFormatter dateFromString:todayDate];	
    
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:lastDate];
    NSLog(@"initail interval=%f",interval);
    unsigned long seconds = interval;
    unsigned long minutes = seconds / 60;
    seconds %= 60;
    unsigned long hours = minutes / 60;
    if(hours)
        minutes %= 60;
    unsigned long days=hours/24;
    if(days)
        hours %=24;
    
    NSMutableString * result = [[NSMutableString new] autorelease];
    dateFormatter.dateFormat=@"EEE, MMM d, h:mm a";//@"MMM d, YYYY, h:mm a"
    
    
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger destinationGMTOffset1 = [destinationTimeZone secondsFromGMTForDate:lastDate];
    NSInteger destinationGMTOffset2 = [destinationTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval2 = destinationGMTOffset1;
    NSTimeInterval interval3 = destinationGMTOffset2;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval2 sinceDate:lastDate] autorelease];
    
    NSDate* currentDateTime = [[[NSDate alloc] initWithTimeInterval:interval3 sinceDate:currentDate] autorelease];
    
    
    NSString *activityTime=[dateFormatter stringFromDate:destinationDate];
    NSString  *currentTime=[dateFormatter stringFromDate:currentDateTime];
    NSTimeInterval interval5 = [destinationDate timeIntervalSinceDate:currentDateTime];
    NSLog(@"activityTime=%@",activityTime);
    NSLog(@"currentTime=%@",currentTime);
    NSLog(@"interval5,the actual difference=%f",interval5);
    
    
    
    NSDate *forwardDate = [currentDateTime dateByAddingTimeInterval:3600];
    NSDate *backwardDate = [currentDateTime dateByAddingTimeInterval:-3600];
    NSString *forwardDateTime=[dateFormatter stringFromDate:forwardDate];
    NSString  *backwardDateTime=[dateFormatter stringFromDate:backwardDate];
    
    NSLog(@"forwardDate=%@",forwardDateTime);
    NSLog(@"backwardDate=%@",backwardDateTime);
    
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    int differenceInDays =
    [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:destinationDate]-
    [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:currentDateTime];
    BOOL checkTime=TRUE;
    switch (differenceInDays) {
        case -1:
        {
            NSLog(@"Yesterday");
            dateFormatter.dateFormat=@"h:mm a";
            
            NSString*timeUpdate=[NSString stringWithFormat:@"Updated yesterday at %@",[dateFormatter stringFromDate:destinationDate]];
            [result appendFormat:timeUpdate];

        }
            break;
        case 0:
        {
            NSLog(@"Today");
            
            if(hours && checkTime){
                if(hours==1) {
                    [result appendFormat: @"Updated %ld hr ago", hours];
                    checkTime=FALSE;
                }
                else {
                    [result appendFormat: @"Updated %ld hrs ago", hours];
                    checkTime=FALSE;
                }
            }
            
            if(minutes && checkTime){
                
                if(minutes ==1){
                    [result appendFormat: @"Updated %ld min ago", minutes];
                    checkTime=FALSE;
                }
                else {
                    [result appendFormat: @"Updated %ld mins ago", minutes];
                    checkTime=FALSE;
                }
                
            }
            if(seconds && checkTime){
                     [result appendFormat: @"Updated a few moments ago"];
                     checkTime=FALSE;
            }
            
        }
            break;
        default:
        {
            NSLog(@"later");
            NSString*timeUpdate=[NSString stringWithFormat:@"Last update: %@",activityTime];
            [result appendFormat:timeUpdate];
        }
            break;
            
    }
    
    
    return result;
    
    
#endif
    
}
+(NSString*)NetworkTime:(InfoActivityClass*)formatStringGMTObj{
#if 1    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    // how to get back time from current time in the same format
    
    NSDate *lastDate = [dateFormatter dateFromString:formatStringGMTObj.when];//add the string
    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate=[dateFormatter dateFromString:todayDate];	
    
    NSTimeInterval interval = [lastDate timeIntervalSinceDate:currentDate];
    NSLog(@"initail interval=%f",interval);
    unsigned long seconds = interval;
    unsigned long minutes = seconds / 60;
    seconds %= 60;
    unsigned long hours = minutes / 60;
    if(hours)
        minutes %= 60;
    unsigned long days=hours/24;
    if(days)
        hours %=24;
    
    NSMutableString * result = [[NSMutableString new] autorelease];
    dateFormatter.dateFormat=@"EEE, MMM d, h:mm a";
    
    
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger destinationGMTOffset1 = [destinationTimeZone secondsFromGMTForDate:lastDate];
    NSInteger destinationGMTOffset2 = [destinationTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval2 = destinationGMTOffset1;
    NSTimeInterval interval3 = destinationGMTOffset2;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval2 sinceDate:lastDate] autorelease];
    
    NSDate* currentDateTime = [[[NSDate alloc] initWithTimeInterval:interval3 sinceDate:currentDate] autorelease];
    
    
    NSString *activityTime=[dateFormatter stringFromDate:destinationDate];
    NSString  *currentTime=[dateFormatter stringFromDate:currentDateTime];
    NSLog(@"activityTime=%@",activityTime);
    NSLog(@"currentTime=%@",currentTime);
    
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    int differenceInDays =
    [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:destinationDate]-
    [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:currentDateTime];
    BOOL checkTime=TRUE;
    switch (differenceInDays) {
        case -1:
        {
            NSLog(@"Yesterday");
        }
            break;
        case 0:
        {
            NSLog(@"Today");
            
            if(hours && checkTime){
                [result appendFormat: @"in %d hrs", hours];
            }
            
            if(minutes && checkTime){
                
                if(hours==0){
                    [result appendFormat: @"in %d min", minutes];
                }
                else
                [result appendFormat: @" %d min", minutes];
                
                checkTime=FALSE;
                
            }
            
            
                dateFormatter.dateFormat=@"h:mm a";
                
                NSString*timeUpdate=[NSString stringWithFormat:@"Today, %@",[dateFormatter stringFromDate:destinationDate]];
                formatStringGMTObj.dateAndTime=timeUpdate;
            
            
        }
            break;
        case 1:
        {
            NSLog(@"Tommorow");
            
            [result appendFormat: @"Tommorow"];
            dateFormatter.dateFormat=@"h:mm a";
            
            NSString*timeUpdate=[NSString stringWithFormat:@"Tomorrow, %@",[dateFormatter stringFromDate:destinationDate]];
            formatStringGMTObj.dateAndTime=timeUpdate;
   
            
        }
            break;
        default: {
            NSLog(@"later");
            [result appendFormat:activityTime];
            formatStringGMTObj.dateAndTime=activityTime;
        }
            break;
            
    }
    
    
    return result;
    
    
#endif
    
}
+(BOOL)ValidActivityDate:(NSString*)activityDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *lastDate = [dateFormatter dateFromString:activityDate];

    dateFormatter.dateFormat=@"EEE, MMM d, h:mm a";//@"MMM d, YYYY, h:mm a"
    
    
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger destinationGMTOffset1 = [destinationTimeZone secondsFromGMTForDate:lastDate];
    NSInteger destinationGMTOffset2 = [destinationTimeZone secondsFromGMTForDate:[NSDate date]];
    
    NSTimeInterval interval2 = destinationGMTOffset1;
    NSTimeInterval interval3 = destinationGMTOffset2;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval2 sinceDate:lastDate] autorelease];
    
    NSDate* currentDateTime = [[[NSDate alloc] initWithTimeInterval:interval3 sinceDate:[NSDate date]] autorelease];
    BOOL checkTime=TRUE;

    if ([destinationDate compare:currentDateTime] == NSOrderedAscending){
        checkTime=FALSE;
    }
    else{
        checkTime=TRUE;
    }
    
            
            
    return checkTime;

}
+(Boolean)hasNetworkConnection
{
	Boolean retVal = NO;
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [@"www.google.com" UTF8String]);
	
	if(reachability!= NULL)
	{
		SCNetworkReachabilityFlags flags;
		if (SCNetworkReachabilityGetFlags(reachability, &flags))
		{
			
			if ((flags & kSCNetworkReachabilityFlagsReachable)) {
				retVal = YES;
			} else {
				retVal = NO;
			}
		}
		
	}
	
	
	
	reachability = nil;
	
	return retVal;
}

+(UILabel*)TitleLabelAndFontOnNavigationBar{
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.backgroundColor = [UIColor clearColor];
    label.textColor=[SoclivityUtilities returnTextFontColor:1];
    label.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    label.textAlignment = UITextAlignmentCenter;
	
	return label;
	
}

#pragma mark -
#pragma mark Formatting 
+(UIColor*)returnBackgroundColor:(NSInteger)colorType {
    
    switch(colorType){
        // Light gray background (usage: Home screen details section)
        case 0:
            return [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
            
        // Off-white background (usage: Filter pane background)
        case 1:
            return [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        
        // Light green (play)
        case 10:
            return [UIColor colorWithRed:240.0/255.0 green:243.0/255.0 blue:229.0/255 alpha:1.0];
        
        // Light yellow (eat)
        case 11:
            return [UIColor colorWithRed:253.0/255.0 green:246.0/255.0 blue:229.0/255 alpha:1.0];
            
        // Light purple (see)
        case 12:
            return [UIColor colorWithRed:247.0/255.0 green:229.0/255.0 blue:249.0/255 alpha:1.0];
            
        // Light red (create)
        case 13:
            return [UIColor colorWithRed:250.0/255.0 green:233.0/255.0 blue:231.0/255 alpha:1.0];
            
        // Light blue (learn)
        case 14:
            return [UIColor colorWithRed:229.0/255.0 green:248.0/255.0 blue:246.0/255 alpha:1.0];
        
        // If nothing else matches
        default:
            return [UIColor colorWithRed:255.0/255.0 green:255./255.0 blue:255.0/255.0 alpha:1.0];
    }
}

+(UIColor*)returnTextFontColor:(NSInteger)colorType {
    
    switch(colorType){
        case 0:
        {
            return [UIColor colorWithRed:255.0/255.0 green:255./255.0 blue:255.0/255.0 alpha:1.0];
            
            break;
        }
        case 1:
        {
            return [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
            
            break;
        }
        case 2:
        {
            return [UIColor colorWithRed:32.0/255.0 green:110.0/255.0 blue:183.0/255.0 alpha:1.0];
            
            break;
        }
            
        case 3:
        {
            return [UIColor colorWithRed:118.0/255.0 green:20.0/255.0 blue:158.0/255.0 alpha:1.0];
            
            break;
        }
        case 4:
        {
            return [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
            
            break;
        }
        case 5:
        {
            return [UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:91.0/255.0 alpha:1.0];
        }

        // Color for the Home List view text
        case 6:
            return [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
            
        // Color for the list detailed and middle section
        case 7:
            return [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
        
        // Color for the filter pane
        case 8:
            return [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
            
        default:
        {
            return [UIColor colorWithRed:255.0/255.0 green:255./255.0 blue:255.0/255.0 alpha:1.0];
        }
            break;
    }
	
}
#pragma mark -

+(UIImage*)updateResult:(CGSize)sizeToFitTheImage originalImage:(UIImage*)originalImage switchCaseIndex:(int)switchCaseIndex
{
	UIImage *oldImage = originalImage;
	UIImage *newImage=nil;
    //	CGSize newSize = resultView.frame.size;
	CGSize newSize = sizeToFitTheImage;
	
#if 1	
	
    // Resize the image using the user's chosen method.
	switch (switchCaseIndex) {
		case 0:
			newImage = [oldImage imageScaledToFitSize:newSize]; // uses MGImageResizeScale
			break;
		case 1:
			newImage = [oldImage imageCroppedToFitSize:newSize]; // uses MGImageResizeCrop
			break;
		case 2:
			newImage = [oldImage imageToFitSize:newSize method:MGImageResizeCropStart];
			break;
		case 3:
			newImage = [oldImage imageToFitSize:newSize method:MGImageResizeCropEnd];
			break;
		default:
			break;
	}
	
	
	return newImage;
    
#endif
}

#pragma mark -
#pragma mark Validation Utilities
// Method to check whether the email address is valid
+(BOOL)validEmail:(NSString*)email {
    
    // Check for an empty email
    if(![email isEqualToString:@""]){
        
        // Make sure it contains an '@' and '.'
        NSString *searchForMe = @"@";
        NSRange rangeCheckAtTheRate = [email rangeOfString : searchForMe];
        
        NSString *searchFor = @".";
        NSRange rangeCheckFullStop = [email rangeOfString : searchFor];
        
        if (rangeCheckAtTheRate.location != NSNotFound && rangeCheckFullStop.location !=NSNotFound){
            
            // Ensure that there is something before and after the '@'
            NSString * charToCount = @"@";
            NSArray * array = [email componentsSeparatedByString:charToCount];
            NSInteger numberOfChar=[array count];
            
            if(numberOfChar==2)
                return YES;
        }
    }
    return NO;
}

// Method to check whether the password is valid
+(BOOL)validPassword:(NSString*)password {
    
    // Checking the length
    NSInteger length;
    length = [password length];
    if (length>=PASSWORD_LENGTH)
        return YES;
    
    return NO;
}
+(BOOL)validFilterActivity:(NSInteger)Type{
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    switch (Type) {
        case 1:
        {
            return SOC.filterObject.playAct;
        }
            break;
        case 2:
        {
            return SOC.filterObject.eatAct;
        }
            break;
        case 3:
        {
            return SOC.filterObject.seeAct;
        }
            break;
        case 4:
        {
            return SOC.filterObject.createAct;
        }
            break;
        case 5:
        {
            return SOC.filterObject.learnAct;
        }
            break;
         default:
            return NO;
            break;
    }
}



#if 1
+(NSInteger)DoTheTimeLogic:(NSString*)formatStringGMTObj{

    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    if(!SOC.filterObject.morning && !SOC.filterObject.evening && !SOC.filterObject.afternoon){
    
        return 0;
    }

    
    
    NSDate *startFilterDate;
    NSDate *finishFilterDate;
    if(SOC.filterObject.whenSearchType==1){
        startFilterDate=[NSDate date];
        finishFilterDate = [[NSDate date] dateByAddingTimeInterval:86400*2];
    }
    else if(SOC.filterObject.whenSearchType==2){
        startFilterDate=[NSDate date];
        finishFilterDate = [[NSDate date] dateByAddingTimeInterval:86400*7];
    }
    
    else if(SOC.filterObject.whenSearchType==3){
        startFilterDate=SOC.filterObject.startPickDateTime;
        finishFilterDate=SOC.filterObject.endPickDateTime;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    
    NSDate *activityDate = [dateFormatter dateFromString:formatStringGMTObj];
    NSString *startFilterDateString =[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:startFilterDate]];
    NSDate *startFilterDateFormatted=[dateFormatter dateFromString:startFilterDateString];	
    
    NSString *finishFilterDateString = [dateFormatter stringFromDate:finishFilterDate];
    NSDate *finishFilterDateFormatted=[dateFormatter dateFromString:finishFilterDateString];	

    
    dateFormatter.dateFormat=@"EEE, MMM d, h:mm a";
    
    
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger destinationGMTOffset1 = [destinationTimeZone secondsFromGMTForDate:activityDate];
    NSInteger destinationGMTOffset2 = [destinationTimeZone secondsFromGMTForDate:startFilterDateFormatted];
    
    NSInteger destinationGMTOffset3 = [destinationTimeZone secondsFromGMTForDate:finishFilterDateFormatted];

    
    NSTimeInterval interval2 = destinationGMTOffset1;
    NSTimeInterval interval3 = destinationGMTOffset2;
    NSTimeInterval interval4 = destinationGMTOffset3;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval2 sinceDate:activityDate] autorelease];
    
    NSDate* startDateTime = [[[NSDate alloc] initWithTimeInterval:interval3 sinceDate:startFilterDateFormatted] autorelease];
    
    NSDate* finishDateTime = [[[NSDate alloc] initWithTimeInterval:interval4 sinceDate:finishFilterDateFormatted] autorelease];

    
    
    NSString *activityTime=[dateFormatter stringFromDate:destinationDate];
    NSString  *startFilterTime=[dateFormatter stringFromDate:startDateTime];
    NSString  *finishFilterTime=[dateFormatter stringFromDate:finishDateTime];
    
    NSLog(@"activityTime=%@",activityTime);
    NSLog(@"startFilterTime=%@",startFilterTime);
    NSLog(@"finishFilterTime=%@",finishFilterTime);
    
    int check=0;
    NSDate *setFinishDate;
    NSDate *setStartDate;
    
    NSArray *array = [NSArray arrayWithObjects:startDateTime,destinationDate,finishDateTime, nil];
    
    array = [array sortedArrayUsingComparator: ^(NSDate *s1, NSDate *s2){
        
        return [s1 compare:s2];
    }];
    
    NSUInteger indexOfDay1 = [array indexOfObject:startDateTime];
    NSUInteger indexOfDay2 = [array indexOfObject:destinationDate];
    NSUInteger indexOfDay3 = [array indexOfObject:finishDateTime];
    
    if (((indexOfDay1 < indexOfDay2 ) && (indexOfDay2 < indexOfDay3)) || 
        ((indexOfDay1 > indexOfDay2 ) && (indexOfDay2 > indexOfDay3))) {
        NSLog(@"YES");
        check=1;
    } else {
        NSLog(@"NO");
        check=0;
    }
    NSLog(@"check=%d",check);
    if(SOC.filterObject.morning && SOC.filterObject.evening && SOC.filterObject.afternoon){
        
        return check;
    }
    
    if(check){
    if(SOC.filterObject.morning && !SOC.filterObject.evening && !SOC.filterObject.afternoon){
        
        
        NSCalendar* myCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                                     fromDate:activityDate];
        [components setHour: 11];
        [components setMinute:59];
        [components setSecond:59];
        setFinishDate=[myCalendar dateFromComponents:components];
        
        NSLog(@"weekdayComponentsEnd=%@",[myCalendar dateFromComponents:components]);
        
        [components setHour:00];
        [components setMinute:00];
        [components setSecond:01];
        NSLog(@"weekdayComponentsStart=%@",[myCalendar dateFromComponents:components]);
        setStartDate=[myCalendar dateFromComponents:components];
            

    }
    
    if(!SOC.filterObject.morning && !SOC.filterObject.evening && SOC.filterObject.afternoon){
        
            NSCalendar* myCalendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                                         fromDate:activityDate];
            
            [components setHour:12];
            [components setMinute:00];
            [components setSecond:01];
            setStartDate=[myCalendar dateFromComponents:components];
            NSLog(@"setStartDate=%@",setStartDate);
            
            [components setHour: 18];
            [components setMinute:59];
            [components setSecond:59];
            setFinishDate=[myCalendar dateFromComponents:components];
            
            NSLog(@"setFinishDate=%@",setFinishDate);

            
        
    }
    if(!SOC.filterObject.morning && SOC.filterObject.evening && !SOC.filterObject.afternoon){
        
            NSCalendar* myCalendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                                         fromDate:activityDate];
            [components setHour: 23];
            [components setMinute:59];
            [components setSecond:59];
            setFinishDate=[myCalendar dateFromComponents:components];
            
            NSLog(@"weekdayComponentsEnd=%@",[myCalendar dateFromComponents:components]);
            
            [components setHour:19];
            [components setMinute:00];
            [components setSecond:01];
            NSLog(@"weekdayComponentsStart=%@",[myCalendar dateFromComponents:components]);
            setStartDate=[myCalendar dateFromComponents:components];
            
        
}
    
    if(SOC.filterObject.morning && !SOC.filterObject.evening && SOC.filterObject.afternoon){
        
        NSCalendar* myCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                                     fromDate:activityDate];
        
        
        [components setHour:00];
        [components setMinute:00];
        [components setSecond:01];
        NSLog(@"weekdayComponentsStart=%@",[myCalendar dateFromComponents:components]);
        setStartDate=[myCalendar dateFromComponents:components];
        
        [components setHour: 18];
        [components setMinute:59];
        [components setSecond:59];
        setFinishDate=[myCalendar dateFromComponents:components];
        NSLog(@"weekdayComponentsEnd=%@",[myCalendar dateFromComponents:components]);


        
        
    }
    
    
    
    if(SOC.filterObject.morning && SOC.filterObject.evening && !SOC.filterObject.afternoon){
        
        
        int localCheckMorning=0;
        NSCalendar* myCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                                     fromDate:activityDate];
        
        
        [components setHour:00];
        [components setMinute:00];
        [components setSecond:01];
        NSLog(@"weekdayComponentsStart=%@",[myCalendar dateFromComponents:components]);
        setStartDate=[myCalendar dateFromComponents:components];
        
        [components setHour: 11];
        [components setMinute:59];
        [components setSecond:59];
        setFinishDate=[myCalendar dateFromComponents:components];
        NSLog(@"weekdayComponentsEnd=%@",[myCalendar dateFromComponents:components]);
        
        NSArray *array1 = [NSArray arrayWithObjects:setStartDate,activityDate,setFinishDate, nil];
        
        array1 = [array1 sortedArrayUsingComparator: ^(NSDate *s1, NSDate *s2){
            
            return [s1 compare:s2];
        }];
        
        NSUInteger indexOfDay1 = [array1 indexOfObject:setStartDate];
        NSUInteger indexOfDay2 = [array1 indexOfObject:activityDate];
        NSUInteger indexOfDay3 = [array1 indexOfObject:setFinishDate];
        
        if (((indexOfDay1 < indexOfDay2 ) && (indexOfDay2 < indexOfDay3)) || 
            ((indexOfDay1 > indexOfDay2 ) && (indexOfDay2 > indexOfDay3))) {
            NSLog(@"YES");
            localCheckMorning=1;
        } else {
            NSLog(@"NO");
            localCheckMorning=0;
        }
        
        
        int localCheckEvening=0;
        [components setHour:19];
        [components setMinute:00];
        [components setSecond:01];
        NSLog(@"weekdayComponentsStart=%@",[myCalendar dateFromComponents:components]);
        setStartDate=[myCalendar dateFromComponents:components];
        
        [components setHour: 23];
        [components setMinute:59];
        [components setSecond:59];
        setFinishDate=[myCalendar dateFromComponents:components];
        NSLog(@"weekdayComponentsEnd=%@",[myCalendar dateFromComponents:components]);
        
        NSArray *array = [NSArray arrayWithObjects:setStartDate,activityDate,setFinishDate, nil];
        
        array = [array sortedArrayUsingComparator: ^(NSDate *s1, NSDate *s2){
            
            return [s1 compare:s2];
        }];
        
        indexOfDay1 = [array indexOfObject:setStartDate];
        indexOfDay2 = [array indexOfObject:activityDate];
        indexOfDay3 = [array indexOfObject:setFinishDate];
        
        if (((indexOfDay1 < indexOfDay2 ) && (indexOfDay2 < indexOfDay3)) || 
            ((indexOfDay1 > indexOfDay2 ) && (indexOfDay2 > indexOfDay3))) {
            NSLog(@"YES");
            localCheckEvening=1;
        } else {
            NSLog(@"NO");
            localCheckEvening=0;
        }

        if(localCheckEvening||localCheckMorning){
            return 1;
        }
        else{
            return 0;
        }
        
        
        
        
    }
    
    if(!SOC.filterObject.morning && SOC.filterObject.evening && SOC.filterObject.afternoon){
        
        NSCalendar* myCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                                     fromDate:activityDate];
        
        
        [components setHour:12];
        [components setMinute:00];
        [components setSecond:01];
        NSLog(@"weekdayComponentsStart=%@",[myCalendar dateFromComponents:components]);
        setStartDate=[myCalendar dateFromComponents:components];
        
        [components setHour: 23];
        [components setMinute:59];
        [components setSecond:59];
        setFinishDate=[myCalendar dateFromComponents:components];
        NSLog(@"weekdayComponentsEnd=%@",[myCalendar dateFromComponents:components]);
        
        
        
        
    }
    
    NSArray *array = [NSArray arrayWithObjects:setStartDate,activityDate,setFinishDate, nil];
    
    array = [array sortedArrayUsingComparator: ^(NSDate *s1, NSDate *s2){
        
        return [s1 compare:s2];
    }];
    
    NSUInteger indexOfDay1 = [array indexOfObject:setStartDate];
    NSUInteger indexOfDay2 = [array indexOfObject:activityDate];
    NSUInteger indexOfDay3 = [array indexOfObject:setFinishDate];
    
    if (((indexOfDay1 < indexOfDay2 ) && (indexOfDay2 < indexOfDay3)) || 
        ((indexOfDay1 > indexOfDay2 ) && (indexOfDay2 > indexOfDay3))) {
        NSLog(@"YES");
        check=1;
    } else {
        NSLog(@"NO");
        check=0;
    }

    
    return  check;
    }
    else
        return 0;
    
}
#else
+(NSInteger)DoTheTimeLogic:(NSString*)formatStringGMTObj{
    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    NSDate *filterDate;
    if(SOC.filterObject.whenSearchType==1){
        filterDate = [NSDate date];
    }
    else if(SOC.filterObject.whenSearchType==2){
         filterDate = [[NSDate date] dateByAddingTimeInterval:86400];
    }
    else{
        filterDate = [NSDate date];
    }

    
    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *components =
    [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:filterDate];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    NSLog(@"hour=%d,minute=%d,secnd=%d",hour,minute,second);
    
    
    int timer=lroundf(minute/15);
    int hourInterval=hour*2;
    switch (timer) {
        case 0:
        {
            hourInterval=hourInterval+0;
        }
            break;
        case 1:
        {
            hourInterval=hourInterval+1;
        }
            break;
        case 2:
        {
            hourInterval=hourInterval+1;
        }
            break;
        case 3:
        {
            hourInterval=hourInterval+2;
        }
            break;
        case 4:
        {
            hourInterval=hourInterval+2;
        }
            break;
    }
    NSLog(@"hourInterval=%d",hourInterval);
    long int startTimeInterval;
    long int finishTimeInterval;
    
    if(hourInterval<=SOC.filterObject.startTime_48){
        startTimeInterval=(SOC.filterObject.startTime_48-hourInterval)*30*60;
    }
    else{
        startTimeInterval=-(hourInterval-SOC.filterObject.startTime_48)*30*60;
    }
    
    if(hourInterval<=SOC.filterObject.finishTime_48){
        finishTimeInterval=(SOC.filterObject.finishTime_48-hourInterval)*30*60;
    }
    else{
        finishTimeInterval=-(hourInterval-SOC.filterObject.finishTime_48)*30*60;
    }

    NSLog(@"startTimeInterval=%ld",startTimeInterval);
    NSLog(@"finishTimeInterval=%ld",finishTimeInterval);    
    //Now figuring out the time Range Interval
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];

    
    NSDate *lastDate = [dateFormatter dateFromString:formatStringGMTObj];
    NSString *todayDate = [dateFormatter stringFromDate:filterDate];
    NSDate *currentDate=[dateFormatter dateFromString:todayDate];	

    dateFormatter.dateFormat=@"EEE, MMM d, h:mm a";//@"MMM d, YYYY, h:mm a"
    
    
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger destinationGMTOffset1 = [destinationTimeZone secondsFromGMTForDate:lastDate];
    NSInteger destinationGMTOffset2 = [destinationTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval2 = destinationGMTOffset1;
    NSTimeInterval interval3 = destinationGMTOffset2;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval2 sinceDate:lastDate] autorelease];
    
    NSDate* currentDateTime = [[[NSDate alloc] initWithTimeInterval:interval3 sinceDate:currentDate] autorelease];
    
    
    NSString *activityTime=[dateFormatter stringFromDate:destinationDate];
    NSString  *currentTime=[dateFormatter stringFromDate:currentDateTime];
    NSTimeInterval interval5 = [destinationDate timeIntervalSinceDate:currentDateTime];
    NSLog(@"interval5,the actual difference=%f",interval5);
    
    NSDate *startDate = [currentDateTime dateByAddingTimeInterval:startTimeInterval];
    NSDate *EndDate = [currentDateTime dateByAddingTimeInterval:finishTimeInterval];
    NSString *startDateTime=[dateFormatter stringFromDate:startDate];
    NSString  *endDateTime=[dateFormatter stringFromDate:EndDate];
    NSLog(@"currentTime=%@",currentTime);
    NSLog(@"startDate=%@",startDateTime);
    NSLog(@"activityTime=%@",activityTime);
    NSLog(@"EndDate=%@",endDateTime);

    
    int check=0;
    NSArray *array = [NSArray arrayWithObjects:startDate,destinationDate,EndDate, nil];
    
    array = [array sortedArrayUsingComparator: ^(NSDate *s1, NSDate *s2){
        
        return [s1 compare:s2];
    }];
    
    NSUInteger indexOfDay1 = [array indexOfObject:startDate];
    NSUInteger indexOfDay2 = [array indexOfObject:destinationDate];
    NSUInteger indexOfDay3 = [array indexOfObject:EndDate];
    
    if (((indexOfDay1 < indexOfDay2 ) && (indexOfDay2 < indexOfDay3)) || 
        ((indexOfDay1 > indexOfDay2 ) && (indexOfDay2 > indexOfDay3))) {
        NSLog(@"YES");
        check=1;
    } else {
        NSLog(@"NO");
        check=0;
    }
    NSLog(@"check=%d",check);
    return check;
    

}
#endif

+(BOOL)DoTheSearchFiltering:(NSString*)activityInfo  organizer:(NSString*) organizerName{
    
     SoclivityManager *SOC=[SoclivityManager SharedInstance];
    NSLog(@"text search=%@",SOC.filterObject.searchText);
    if((SOC.filterObject.searchText==(NSString*)[NSNull null])||([SOC.filterObject.searchText isEqualToString:@""]||SOC.filterObject.searchText==nil)||([SOC.filterObject.searchText isEqualToString:@"(null)"])){
        return YES;
    }
    NSRange activityInfoResultsRange = [activityInfo rangeOfString:SOC.filterObject.searchText options:NSCaseInsensitiveSearch];
    NSRange organizerNameResultsRange = [organizerName rangeOfString:SOC.filterObject.searchText options:NSCaseInsensitiveSearch];
    
    if (activityInfoResultsRange.length > 0 ||organizerNameResultsRange.length > 0){
        return YES;
    }
    else{
        return FALSE;
    }
/*    
    NSComparisonResult result = [activityInfo compare:SOC.filterObject.searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [SOC.filterObject.searchText length])];
    if (result == NSOrderedSame)
    {
        return YES;
    }
 */
}

// Function to auto-crop the image if user does not
+(UIImage*) autoCrop:(UIImage*)image{
    
    CGSize dimensions = {0,0};
    float x=0.0,y=0.0;
    
    // Check to see if the image layout is landscape or portrait
    if(image.size.width > image.size.height)
    {
        // if landscape
        x = (image.size.width - image.size.height)/2;
        dimensions.width = image.size.height;
        dimensions.height = image.size.height;
        
    }
    else
    {
        // if portrait
        y = (image.size.height - image.size.width)/2;
        dimensions.height = image.size.width;
        dimensions.width = image.size.width;
        
    }
    
    // Create the mask
    CGRect imageRect = CGRectMake(x,y,dimensions.width,dimensions.height);
    
    // Create the image based on the mask created above
    CGImageRef  imageRef = CGImageCreateWithImageInRect([image CGImage], imageRect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
	return image;
}

// Function to compress a large image
+(UIImage*) compressImage:(UIImage *)image size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(NSString*)getFirstAndLastName:(NSString*)firstName lastName:(NSString*)lastName{
    BOOL fName=TRUE;
    BOOL lName=TRUE;
    NSString *fullName=nil;
    if ((firstName==(NSString*)[NSNull null])||([firstName isEqualToString:@""]||firstName==nil)||([firstName isEqualToString:@"(null)"])){
        fName=FALSE;
    }
    
    if ((lastName==(NSString*)[NSNull null])||([lastName isEqualToString:@""]||lastName==nil)||([lastName isEqualToString:@"(null)"])){
        lName=FALSE;
    }
    
    if(fName && lName){
        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    }
    
    if(fName && !lName){
        fullName=[NSString stringWithFormat:@"%@",firstName];
    }
    
    if(!fName && lName){
        fullName=[NSString stringWithFormat:@"%@",lastName];
    }
    return fullName;
}
@end
