//
//  StyledPullableView.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StyledPullableView.h"
#import "SoclivityUtilities.h"
#import "LaterDateView.h"
#define kPlayActivity 12
#define kEatActivity 13
#define kSeeActivity 14
#define kCreateActivity 15
#define kLearnActivity 16
#define kTodayFilter 17
#define kTomorrowFilter 18
#define kLaterFilter 19
@implementation StyledPullableView
@synthesize homeSearchBar;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        self.backgroundColor=[UIColor clearColor];
        
                              
        filterPaneView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 640, 402)];//402
        filterPaneView.backgroundColor=[UIColor whiteColor];
        self.homeSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 100.0,320, 44.0)] autorelease];
        self.homeSearchBar.delegate = self;
        self.homeSearchBar.showsCancelButton = NO;
        self.homeSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        self.homeSearchBar.placeholder=@"Search for friends to invite ";

        self.homeSearchBar.backgroundImage=[UIImage imageNamed: @"S4.1_search-background.png"];
        [filterPaneView addSubview:self.homeSearchBar];
        
        for (UIView *subview in [self.homeSearchBar subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                //[subview removeFromSuperview];
            }
            
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [(UITextField *)subview setTextColor:[SoclivityUtilities returnTextFontColor:1]];
                [(UITextField *)subview setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];

                [(UITextField *)subview setBackground:[UIImage imageNamed:@"S4.1_search-bar.png"]];
                [(UITextField *)subview setBorderStyle:UITextBorderStyleNone];
            }
        }
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 144, 320, 249)];
        backgroundView.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S4.1_dropdown-background.png"]];
        	
        
        UIImageView *filterImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S4.1_filters.png"]];
        filterImageView.frame=CGRectMake(18, 25, 47, 12);
        [backgroundView addSubview:filterImageView];
        [filterImageView release];
        
        UIImageView *whatImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S4.1_what.png"]];
        whatImageView.frame=CGRectMake(18, 50, 140, 14);
        [backgroundView addSubview:whatImageView];
        [whatImageView release];
        
        
        UIButton *playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        playButton.frame = CGRectMake(0,72, 62.0, 30.0);
        playButton.tag=kPlayActivity;
        [playButton setImage:[UIImage imageNamed:@"S4.1_play-unselected.png"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:playButton];
        
        UIButton *eatButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        eatButton.frame = CGRectMake(64.5,72, 62.0, 30.0);
        eatButton.tag=kEatActivity;
        [eatButton setImage:[UIImage imageNamed:@"S4.1_eat-deselect.png"] forState:UIControlStateNormal];
        [eatButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:eatButton];
        
        
        UIButton *seeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        seeButton.frame = CGRectMake(129,72, 62.0, 30.0);
        seeButton.tag=kSeeActivity;
        [seeButton setImage:[UIImage imageNamed:@"S4.1_see-deselect.png"] forState:UIControlStateNormal];
        [seeButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:seeButton];
        
        
        UIButton *createButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        createButton.frame = CGRectMake(193.5,72, 62.0, 30.0);
        createButton.tag=kCreateActivity;
        [createButton setImage:[UIImage imageNamed:@"S4.1_create-deselect.png"] forState:UIControlStateNormal];
        [createButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:createButton];
        
        
        UIButton *learnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        learnButton.frame = CGRectMake(258,72, 62.0, 30.0);
        learnButton.tag=kLearnActivity;
        [learnButton setImage:[UIImage imageNamed:@"S4.1_learn-deselect.png"] forState:UIControlStateNormal];
        [learnButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:learnButton];
        
        
        UIImageView *whenImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S4.1_when.png"]];
        whenImageView.frame=CGRectMake(18, 120, 154, 12);
        [backgroundView addSubview:whenImageView];
        [whenImageView release];
        
        UIView *timeBackgroundImageView = [[UIView alloc] initWithFrame:CGRectMake(2.5, 145, 315, 89)];
        timeBackgroundImageView.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S4.1_time-background.png"]];

       
        UIButton *todayButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        todayButton.frame = CGRectMake(2,5, 103.0, 29.0);
        todayButton.tag=kTodayFilter;
        [todayButton setImage:[UIImage imageNamed:@"S4.1_today-deselect.png"] forState:UIControlStateNormal];
        [todayButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [timeBackgroundImageView addSubview:todayButton];
        
        
        UIButton *tomorrowButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        tomorrowButton.frame = CGRectMake(106,5, 103.0, 29.0);
        tomorrowButton.tag=kTomorrowFilter;
        [tomorrowButton setImage:[UIImage imageNamed:@"S4.1_tomorrow-deselect.png"] forState:UIControlStateNormal];
        [tomorrowButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [timeBackgroundImageView addSubview:tomorrowButton];
        
        
        UIButton *laterButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        laterButton.frame = CGRectMake(210,5, 103.0, 29.0);
        laterButton.tag=kLaterFilter;
        [laterButton setImage:[UIImage imageNamed:@"S4.1_later-deselect.png"] forState:UIControlStateNormal];
        [laterButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [timeBackgroundImageView addSubview:laterButton];
        
        
        
        
        UIImageView *startImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S4.1_start.png"]];
        startImgView.frame=CGRectMake(18, 55, 32, 10);
        [timeBackgroundImageView addSubview:startImgView];
        [startImgView release];

        
        
        UIImageView *finishImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S4.1_finish.png"]];
        finishImgView.frame=CGRectMake(265, 55, 32, 10);
        [timeBackgroundImageView addSubview:finishImgView];
        [finishImgView release];



        rangeSlider=[[FCRangeSlider alloc]initWithFrame:CGRectMake(58.5, 48, 198, 7)];
        [timeBackgroundImageView addSubview:rangeSlider];
        [rangeSlider setThumbImage:[UIImage imageNamed:@"S4.1_scroll-ball.png"] forState:UIControlStateHighlighted];
        [self sliderValueChanged:rangeSlider];

        [backgroundView addSubview:timeBackgroundImageView];
        [timeBackgroundImageView release];
        [filterPaneView addSubview:backgroundView];

        
        UIButton *searchHandleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        searchHandleButton.frame = CGRectMake(5, 398.0, 58.0, 58.0);
        [searchHandleButton setImage:[UIImage imageNamed:@"S04_bookmark.png"] forState:UIControlStateNormal];
        [searchHandleButton addTarget:self action:@selector(pushTodetailActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchHandleButton];
        
        
        UIView *dateCalendarView=[[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, 402)];
        dateCalendarView.backgroundColor=[UIColor whiteColor];
        
        UIImageView *titleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_titlebar.png"]];
        titleImageView.frame=CGRectMake(0, 100, 320, 44);
        [dateCalendarView addSubview:titleImageView];
        [titleImageView release];
        
        
        UIButton *backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        backButton.frame = CGRectMake(15, 107, 38.0, 30.0);
        [backButton setImage:[UIImage imageNamed:@"S5-back-arrow.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(pushTransformWithAnimation:) forControlEvents:UIControlEventTouchUpInside];
        [dateCalendarView addSubview:backButton];


        [filterPaneView addSubview:dateCalendarView];

        
        
        searchLensImageView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 415, 20, 21)];
        searchLensImageView.image=[UIImage imageNamed:@"S04_search.png"];
        [self addSubview:searchLensImageView];
        searchLensImageView.hidden=NO;

        crossImageView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 415, 22, 18)];
        crossImageView.image=[UIImage imageNamed:@"S4.1_cross.png"];
        [self addSubview:crossImageView];
        crossImageView.hidden=YES;
        
        [self addSubview:filterPaneView];
        [self insertSubview:filterPaneView atIndex:0];
        [self insertSubview:searchHandleButton atIndex:0];
        [self insertSubview:searchHandleButton aboveSubview:filterPaneView]; 
        [backgroundView release];
        }
    return self;
}

- (void)sliderValueChanged:(FCRangeSlider *)sender {
    NSLog(@"lblRangeValue=%@",[NSString stringWithFormat:@"{%f, %f}", sender.rangeValue.start, sender.rangeValue.end]);
}

-(void)activityButtonPressed:(UIButton*)sender{
    
    switch (sender.tag) {
        case kPlayActivity:
        {
            play=!play;
            if(play){
                [sender setImage:[UIImage imageNamed:@"S4.1_play-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_play-unselected.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kEatActivity:
        {
            eat=!eat;
            if(eat){
                [sender setImage:[UIImage imageNamed:@"S4.1_eat-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_eat-deselect.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kSeeActivity:
        {
            see=!see;
            if(see){
                [sender setImage:[UIImage imageNamed:@"S4.1_see-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_see-deselect.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kCreateActivity:
        {
            create=!create;
            if(create){
                [sender setImage:[UIImage imageNamed:@"S4.1_create-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_create-deselect.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kLearnActivity:
        {
            learn=!learn;
            if(learn){
                [sender setImage:[UIImage imageNamed:@"S4.1_learn-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_learn-deselect.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kTodayFilter:
        {
            [sender setImage:[UIImage imageNamed:@"S4.1_today-selected.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kTomorrowFilter]setImage:[UIImage imageNamed:@"S4.1_tomorrow-deselect.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kLaterFilter]setImage:[UIImage imageNamed:@"S4.1_later-deselect.png"] forState:UIControlStateNormal];


                
        }
            break;
            
        case kTomorrowFilter:
        {
            
            [sender setImage:[UIImage imageNamed:@"S4.1_tomorrow-selected.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kTodayFilter]setImage:[UIImage imageNamed:@"S4.1_today-deselect.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kLaterFilter]setImage:[UIImage imageNamed:@"S4.1_later-deselect.png"] forState:UIControlStateNormal];
                
        }
            break;
            
        case kLaterFilter:
        {
            [sender setImage:[UIImage imageNamed:@"S4.1_later-selected.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kTomorrowFilter]setImage:[UIImage imageNamed:@"S4.1_tomorrow-deselect.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kTodayFilter]setImage:[UIImage imageNamed:@"S4.1_today-deselect.png"] forState:UIControlStateNormal];
            [self slideOutFilterPane];


        }
            break;


            
            
    }
}

-(void)pushTransformWithAnimation:(id)sender{
    [self bringInFilterPane];
}
-(void)pushTodetailActivity:(UIButton*)sender{
    NSLog(@"pushTodetailActivity=%f,%f,%f,%f",sender.frame.size.height,sender.frame.size.width,sender.frame.origin.x,sender.frame.origin.y);
}
#pragma mark -
#pragma mark UISearchBarDelegate


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
    
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.homeSearchBar resignFirstResponder];
}

@end
