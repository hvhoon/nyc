//
//  FilterPreferenceClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterPreferenceClass.h"

@implementation FilterPreferenceClass
@synthesize playAct,eatAct,seeAct,createAct,learnAct,whenSearchType,startTime_48,finishTime_48,morning,afternoon,evening,startPickDateTime,endPickDateTime,searchText,dateString,pickADateString,lastDateString,lastStartPickDateTime,lastEndPickDateTime;


-(void)dealloc{
    [super dealloc];
    [startPickDateTime release];
    [endPickDateTime release];
    [searchText release];
    [dateString release];
    [pickADateString release];
    [lastDateString release];
    [lastStartPickDateTime release];
    [lastEndPickDateTime release];
}
@end
