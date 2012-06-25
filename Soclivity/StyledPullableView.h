//
//  StyledPullableView.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "PullableView.h"
#import "FCRangeSlider.h"
#import "CalendarDateView.h"
@class SoclivityManager;

@interface StyledPullableView : PullableView<UISearchBarDelegate,CalendarDateViewDelegate>{
    UISearchBar*homeSearchBar;
    BOOL learn;
    FCRangeSlider *rangeSlider;
    SoclivityManager *SOC;
    CalendarDateView *calendarDate;
    
    
}
@property (nonatomic, retain) UISearchBar *homeSearchBar;
- (void)sliderValueChanged:(FCRangeSlider *)sender;
@end
