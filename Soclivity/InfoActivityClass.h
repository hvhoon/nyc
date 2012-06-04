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
    NSString *activityName;
    NSString *organizerName;
    NSString *DOS;
    NSString *distance;
    NSString *goingCount;
    NSNumber *latitude;
    NSNumber *longitude;
    NSArray *quotations;
}
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,retain)NSString *activityName;
@property (nonatomic,retain)NSString *organizerName;
@property (nonatomic,retain)NSString *DOS;
@property (nonatomic,retain)NSString *distance;
@property (nonatomic,retain)NSString *goingCount;
@property (nonatomic,retain) NSNumber *latitude;
@property (nonatomic,retain) NSNumber *longitude;
@property (nonatomic, retain) NSArray *quotations;
@end
