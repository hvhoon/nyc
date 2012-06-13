//
//  InfoActivityClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoActivityClass : NSObject{
    NSInteger type;
    NSInteger stamp;
    NSString *activityName;
    NSString *organizerName;
    NSString *DOS;
    NSString *distance;
    NSString *goingCount;
    NSNumber *latitude;
    NSNumber *longitude;
    NSArray *quotations;
    NSString *dateFormatterString;
}
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSInteger stamp;
@property (nonatomic,retain)NSString *activityName;
@property (nonatomic,retain)NSString *organizerName;
@property (nonatomic,retain)NSString *DOS;
@property (nonatomic,retain)NSString *distance;
@property (nonatomic,retain)NSString *goingCount;
@property (nonatomic,retain) NSNumber *latitude;
@property (nonatomic,retain) NSNumber *longitude;
@property (nonatomic, retain) NSArray *quotations;
@property (nonatomic,retain) NSString *dateFormatterString;
@end
