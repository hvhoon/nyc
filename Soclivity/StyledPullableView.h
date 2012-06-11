//
//  StyledPullableView.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "PullableView.h"
#import "FCRangeSlider.h"

@interface StyledPullableView : PullableView<UISearchBarDelegate>{
    UISearchBar*homeSearchBar;
    BOOL play;
    BOOL eat;
    BOOL see;
    BOOL create;
    BOOL learn;
    FCRangeSlider *rangeSlider;
    
    
}
@property (nonatomic, retain) UISearchBar *homeSearchBar;
- (void)sliderValueChanged:(FCRangeSlider *)sender;
@end
