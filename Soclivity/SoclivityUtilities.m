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
+(NSString*)NetworkTime:(InfoActivityClass*)formatStringGMTObj{
#if 1    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    // how to get back time from current time in the same format
    
    NSDate *lastDate = [dateFormatter dateFromString:formatStringGMTObj.dateFormatterString];//add the string
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
                [result appendFormat: @"in %d hours", hours];
                checkTime=FALSE;
            }
            else{
                checkTime=TRUE;
            }
            
            if(minutes && checkTime){
                
                
                [result appendFormat: @"in %d minutes", minutes];
                checkTime=FALSE;
            }
            
            
                dateFormatter.dateFormat=@"h:mm a";
                
                NSString*timeUpdate=[NSString stringWithFormat:@"Today,%@",[dateFormatter stringFromDate:destinationDate]];
                formatStringGMTObj.dateAndTime=timeUpdate;
            
            
        }
            break;
        case 1:
        {
            NSLog(@"Tommorow");
            
            [result appendFormat: @"Tommorow"];
            
            for(DetailInfoActivityClass *detailPlay in [formatStringGMTObj quotations]){
                dateFormatter.dateFormat=@"h:mm a";
                
                NSString*timeUpdate=[NSString stringWithFormat:@"Tomorrow,%@",[dateFormatter stringFromDate:destinationDate]];
                formatStringGMTObj.dateAndTime=timeUpdate;
            }
            
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
+(UIColor*)returnTextFontColor:(NSInteger)colorType{
    
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
            return [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        }
            
        default:
        {
            return [UIColor colorWithRed:255.0/255.0 green:255./255.0 blue:255.0/255.0 alpha:1.0];
        }
            break;
    }
	
}

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

@end
