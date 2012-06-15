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
+ (NSInteger)dateInterval:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+(NSInteger)DoTheTimeLogic:(InfoActivityClass*)formatStringGMTObj;
@end
