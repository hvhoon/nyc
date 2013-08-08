//
//  SoclivityUtilities.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NotificationClass;
@class InfoActivityClass;
typedef enum
{
    iPhone          = 1 << 1,
    iPhoneRetnia    = 1 << 2,
    iPhone5         = 1 << 3,
    iPad            = 1 << 4,
    iPadRetnia      = 1 << 5
    
} DeviceType;


@interface SoclivityUtilities : NSObject{
    
}
+ (DeviceType)deviceType;
+(UIColor*)returnTextFontColor:(NSInteger)colorType;
+(UIColor*)returnBackgroundColor:(NSInteger)colorType;
+(UIImage*)updateResult:(CGSize)sizeToFitTheImage originalImage:(UIImage*)originalImage switchCaseIndex:(int)switchCaseIndex;
+(BOOL)validEmail:(NSString*)email;
+(BOOL)validPassword:(NSString*)password;
+(Boolean)hasNetworkConnection;
+(void)setPlayerActivities:(NSArray *)_data;
+(NSArray *)getPlayerActivities;
+(UILabel*)TitleLabelAndFontOnNavigationBar;
+(NSString*)NetworkTime:(InfoActivityClass*)formatStringGMTObj;
+(BOOL)validFilterActivity:(NSInteger)Type;
+(NSString*)getStartAndFinishTimeLabel:(float)sliderValue;
+(NSInteger)DoTheTimeLogic:(NSString*)formatStringGMTObj;
+(BOOL)ValidActivityDate:(NSString*)activityDate;
+(BOOL)DoTheSearchFiltering:(NSString*)activityInfo organizer:(NSString*) organizerName;
+(NSString*)lastUpdate:(NSString*)time;
+(UIImage*) compressImage:(UIImage *)image size:(CGSize)size;
+(UIImage*) autoCrop:(UIImage*)image;
+(NSString*)getFirstAndLastName:(NSString*)firstName lastName:(NSString*)lastName;
+(NSString*)getStateAbbreviation:(NSString*)stateFullName;
+(BOOL)hasLeadingNumberInString:(NSString*) str;
+(void)returnNotificationButtonWithCountUpdate:(UIButton*)button;
+(NSString *)nofiticationTime:(NSString *)timeString;
+(NotificationClass*)getNotificationObject:(NSNotification*)object;
+(NotificationClass*)getNotificationChatPost:(NSNotification*)object;
+(NSString *)upcomingTimeOfActivity:(NSString *)timeString;
@end
