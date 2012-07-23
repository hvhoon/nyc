//
//  FilterPreferenceClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterPreferenceClass : NSObject{
    BOOL playAct;
    BOOL eatAct;
    BOOL seeAct;
    BOOL createAct;
    BOOL learnAct;
    BOOL morning;
    BOOL afternoon;
    BOOL evening;
    NSInteger whenSearchType;
    NSInteger startTime_48;
    NSInteger finishTime_48;
    NSDate *startPickDateTime;
    NSDate *endPickDateTime;
    NSString *searchText;
    NSString *dateString;
    NSString *pickADateString;
    NSString *lastDateString;
    NSDate *lastStartPickDateTime;
    NSDate *lastEndPickDateTime;
    
}
@property (nonatomic,assign)BOOL playAct;
@property (nonatomic,assign)BOOL eatAct;
@property (nonatomic,assign)BOOL seeAct;
@property (nonatomic,assign)BOOL createAct;
@property (nonatomic,assign)BOOL learnAct;
@property (nonatomic,assign)BOOL morning;
@property (nonatomic,assign)BOOL afternoon;
@property (nonatomic,assign)BOOL evening;
@property (nonatomic,assign) NSInteger whenSearchType;
@property (nonatomic,assign)NSInteger startTime_48;
@property (nonatomic,assign)NSInteger finishTime_48;
@property (nonatomic,retain)NSDate *startPickDateTime;
@property (nonatomic,retain)NSDate *endPickDateTime;
@property (nonatomic,retain)NSString *searchText;
@property (nonatomic,retain)NSString *dateString;
@property (nonatomic,retain)NSString *pickADateString;
@property (nonatomic,retain)NSString *lastDateString;
@property (nonatomic,retain)NSDate *lastStartPickDateTime;
@property (nonatomic,retain)NSDate *lastEndPickDateTime;
@end
