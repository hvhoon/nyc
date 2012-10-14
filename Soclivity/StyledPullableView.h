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
#import "CustomSearchBar.h"
@class SoclivityManager;

@interface StyledPullableView : PullableView<UISearchBarDelegate,CalendarDateViewDelegate,CustomSearchBarDelegate>{
    CustomSearchbar*homeSearchBar;
    BOOL learn;
    FCRangeSlider *rangeSlider;
    SoclivityManager *SOC;
    CalendarDateView *calendarDate;
    int tracker;

    
}
@property (nonatomic, retain) CustomSearchbar *homeSearchBar;
- (void)sliderValueChanged:(FCRangeSlider *)sender;
-(void)customCancelButtonHit;
@end
