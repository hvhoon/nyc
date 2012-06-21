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

@end
