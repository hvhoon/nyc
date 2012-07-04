//
//  SoclivityUtilities.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoclivityUtilities : NSObject{
    
}
+(UIColor*)returnTextFontColor:(NSInteger)colorType;
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
@end
