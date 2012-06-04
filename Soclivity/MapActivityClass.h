//
//  MapActivityClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapActivityClass : NSObject{
    CLLocationCoordinate2D mapCoord;
    NSInteger pinType;
    NSString *activityName;
    NSString *organizer;
    NSString *activityDateAndTime;
    NSInteger DOS;
}
@property (nonatomic,assign)CLLocationCoordinate2D mapCoord;
@property (nonatomic,assign)  NSInteger pinType;
@property (nonatomic,retain)NSString *activityName;
@property (nonatomic,retain)NSString *organizer;
@property (nonatomic,retain)NSString *activityDateAndTime;
@property (nonatomic,assign)NSInteger DOS;
@end
