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
#import "SoclivityManager.h"
#import "FilterPreferenceClass.h"
#define kPlayActivity 12
#define kEatActivity 13
#define kSeeActivity 14
#define kCreateActivity 15
#define kLearnActivity 16
#define kTodayFilter 17
#define kTomorrowFilter 18
#define kLaterFilter 19
#define kStartTime 20
#define kFinshTime 21
@implementation StyledPullableView
@synthesize homeSearchBar;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        self.backgroundColor=[UIColor clearColor];
        
        SOC=[SoclivityManager SharedInstance];                     
        filterPaneView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 640, 402)];//402
        filterPaneView.backgroundColor=[UIColor whiteColor];
        self.homeSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 100.0,320, 44.0)] autorelease];
        self.homeSearchBar.delegate = self;
        self.homeSearchBar.showsCancelButton = YES;
        self.homeSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        self.homeSearchBar.placeholder=@"Search for activities";

        self.homeSearchBar.backgroundImage=[UIImage imageNamed: @"S4.1_search-background.png"];
        [filterPaneView addSubview:self.homeSearchBar];
        
        
        
        for (UIView *subview in [self.homeSearchBar subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                //[subview removeFromSuperview];
            }
            UIButton *cancelButton = nil;
            if([subview isKindOfClass:[UIButton class]]){
                cancelButton = (UIButton*)subview;
            }
            if (cancelButton){
                NSLog(@"cancelButton");
                [cancelButton setTintColor:[UIColor colorWithRed:145.0/255.0 green:159.0/255.0 blue:179.0/255.0 alpha:1.0]];
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"S5_on-background.png"] forState:UIControlStateNormal];
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"S5_on-background.png"] forState:UIControlStateHighlighted];
                
                
                    /* For some strange reason, this code changes the font but not the text color. I assume some other internal customizations      make this not possible:
                     
                     UILabel *titleLabel = [cancelButton titleLabel];
                     [titleLabel setFont:font];
                     [titleLabel setTextColor:[UIColor redColor]];
                    
                    // Therefore I had to create view with a label on top:        
                    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(2, 2, kCancelButtonWidth, kCancelButtonLabelHeight)];
                    [overlay setBackgroundColor:[UIColor whiteColor]];
                    [overlay setUserInteractionEnabled:NO]; // This is important for the cancel button to work
                    [cancelButton addSubview:overlay];
                    
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, kCancelButtonWidth, kCancelButtonLabelHeight)];
                    [newLabel setFont:font];
                    [newLabel setTextColor:textColor];
                    // Text "Cancel" should be localized for other languages
                    [newLabel setText:@"Cancel"]; 
                    [newLabel setTextAlignment:UITextAlignmentCenter];
                    // This is important for the cancel button to work
                    [newLabel setUserInteractionEnabled:NO]; 
                    [overlay addSubview:newLabel];
                    [newLabel release];
                    [overlay release]; 
                */
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
        if(SOC.filterObject.playAct)
            [playButton setImage:[UIImage imageNamed:@"S4.1_play-selected.png"] forState:UIControlStateNormal];
        else
            [playButton setImage:[UIImage imageNamed:@"S4.1_play-unselected.png"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:playButton];
        
        UIButton *eatButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        eatButton.frame = CGRectMake(64.5,72, 62.0, 30.0);
        eatButton.tag=kEatActivity;
        
        if(SOC.filterObject.eatAct)
            [eatButton setImage:[UIImage imageNamed:@"S4.1_eat-selected.png"] forState:UIControlStateNormal];
        else
            [eatButton setImage:[UIImage imageNamed:@"S4.1_eat-deselect.png"] forState:UIControlStateNormal];
        
        [eatButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:eatButton];
        
        
        
        
        UIButton *seeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        seeButton.frame = CGRectMake(129,72, 62.0, 30.0);
        seeButton.tag=kSeeActivity;
        
        if(SOC.filterObject.seeAct){
            [seeButton setImage:[UIImage imageNamed:@"S4.1_see-selected.png"] forState:UIControlStateNormal]; 
        }
        else
        [seeButton setImage:[UIImage imageNamed:@"S4.1_see-deselect.png"] forState:UIControlStateNormal];
        
        
        [seeButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:seeButton];
        
        
        UIButton *createButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        createButton.frame = CGRectMake(193.5,72, 62.0, 30.0);
        createButton.tag=kCreateActivity;
        
        if(SOC.filterObject.createAct)
        [createButton setImage:[UIImage imageNamed:@"S4.1_create-selected.png"] forState:UIControlStateNormal];
        else{
        [createButton setImage:[UIImage imageNamed:@"S4.1_create-deselect.png"] forState:UIControlStateNormal];
        }
        [createButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:createButton];
        
        
        UIButton *learnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        learnButton.frame = CGRectMake(258,72, 62.0, 30.0);
        learnButton.tag=kLearnActivity;
        
        if(SOC.filterObject.learnAct)
        [learnButton setImage:[UIImage imageNamed:@"S4.1_learn-selected.png"] forState:UIControlStateNormal];
        else
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
        if(SOC.filterObject.whenSearchType==1){
        [todayButton setImage:[UIImage imageNamed:@"S4.1_today-selected.png"] forState:UIControlStateNormal];
        }
        else{
            [todayButton setImage:[UIImage imageNamed:@"S4.1_today-deselect.png"] forState:UIControlStateNormal];
        }
        [todayButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [timeBackgroundImageView addSubview:todayButton];
        
        
        UIButton *tomorrowButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        tomorrowButton.frame = CGRectMake(106,5, 103.0, 29.0);
        tomorrowButton.tag=kTomorrowFilter;
        if(SOC.filterObject.whenSearchType==2){
            [tomorrowButton setImage:[UIImage imageNamed:@"S4.1_tomorrow-selected.png"] forState:UIControlStateNormal];
        }
        else{
            [tomorrowButton setImage:[UIImage imageNamed:@"S4.1_tomorrow-deselect.png"] forState:UIControlStateNormal];
        }

        
        [tomorrowButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [timeBackgroundImageView addSubview:tomorrowButton];
        
        
        UIButton *laterButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        laterButton.frame = CGRectMake(210,5, 103.0, 29.0);
        laterButton.tag=kLaterFilter;
        if(SOC.filterObject.whenSearchType==3){
            [laterButton setImage:[UIImage imageNamed:@"S4.1_later-selected.png"] forState:UIControlStateNormal];
        }
        else{
            [laterButton setImage:[UIImage imageNamed:@"S4.1_later-deselect.png"] forState:UIControlStateNormal];
        }

        [laterButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [timeBackgroundImageView addSubview:laterButton];
        

        
#if 0
        UIImageView *startImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S4.1_start.png"]];
        startImgView.frame=CGRectMake(18, 55, 32, 10);
        [timeBackgroundImageView addSubview:startImgView];
        [startImgView release];

        
        
        UIImageView *finishImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S4.1_finish.png"]];
        finishImgView.frame=CGRectMake(265, 55, 32, 10);
        [timeBackgroundImageView addSubview:finishImgView];
        [finishImgView release];
#else

        CGRect startLabelRect=CGRectMake(10,55,65,15);
        UILabel *startLabel=[[UILabel alloc] initWithFrame:startLabelRect];
        startLabel.textAlignment=UITextAlignmentLeft;
        startLabel.text=[NSString stringWithFormat:@"12:00 AM"];
        startLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
        startLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        startLabel.tag=kStartTime;
        startLabel.backgroundColor=[UIColor clearColor];
        
        [timeBackgroundImageView addSubview:startLabel];
        [startLabel release];

        CGRect finishLabelRect=CGRectMake(255, 55, 62, 15);
        UILabel *finishLabel=[[UILabel alloc] initWithFrame:finishLabelRect];
        finishLabel.textAlignment=UITextAlignmentLeft;
        finishLabel.text=[NSString stringWithFormat:@"12:00 PM"];
        finishLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
        finishLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        finishLabel.tag=kFinshTime;
        finishLabel.backgroundColor=[UIColor clearColor];
        
        [timeBackgroundImageView addSubview:finishLabel];
        [finishLabel release];

#endif        
        rangeSlider=[[FCRangeSlider alloc]initWithFrame:CGRectMake(58.5, 48, 198, 7)];
        [timeBackgroundImageView addSubview:rangeSlider];
        [rangeSlider setThumbImage:[UIImage imageNamed:@"S4.1_scroll-ball.png"] forState:UIControlStateHighlighted];
        [rangeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

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
    


    [(UILabel*)[self viewWithTag:kStartTime]setText:[SoclivityUtilities getStartAndFinishTimeLabel:sender.rangeValue.start]];
    [(UILabel*)[self viewWithTag:kFinshTime]setText:[SoclivityUtilities getStartAndFinishTimeLabel:sender.rangeValue.end]];
    float startTimeValue=sender.rangeValue.start*48/10;
    int timerStart=lroundf(startTimeValue);
    SOC.filterObject.startTime_48=timerStart;
    
    float endTimeValue=sender.rangeValue.end*48/10;
    int timerEnd=lroundf(endTimeValue);
    SOC.filterObject.finishTime_48=timerEnd;

    
}

-(void)activityButtonPressed:(UIButton*)sender{
    
    switch (sender.tag) {
        case kPlayActivity:
        {
            SOC.filterObject.playAct=!SOC.filterObject.playAct;
            if(SOC.filterObject.playAct){
                [sender setImage:[UIImage imageNamed:@"S4.1_play-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_play-unselected.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kEatActivity:
        {
            SOC.filterObject.eatAct=!SOC.filterObject.eatAct;
            if(SOC.filterObject.eatAct){
                [sender setImage:[UIImage imageNamed:@"S4.1_eat-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_eat-deselect.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kSeeActivity:
        {
            SOC.filterObject.seeAct=!SOC.filterObject.seeAct;
            if(SOC.filterObject.seeAct){
                [sender setImage:[UIImage imageNamed:@"S4.1_see-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_see-deselect.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kCreateActivity:
        {
            SOC.filterObject.createAct=!SOC.filterObject.createAct;
            if(SOC.filterObject.createAct){
                [sender setImage:[UIImage imageNamed:@"S4.1_create-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_create-deselect.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kLearnActivity:
        {
            SOC.filterObject.learnAct=!SOC.filterObject.learnAct;
            if(SOC.filterObject.learnAct){
                [sender setImage:[UIImage imageNamed:@"S4.1_learn-selected.png"] forState:UIControlStateNormal];
            }
            else{
                [sender setImage:[UIImage imageNamed:@"S4.1_learn-deselect.png"] forState:UIControlStateNormal];
                
            }
        }
            break;
            
        case kTodayFilter:
        {
            SOC.filterObject.whenSearchType=1;
            [sender setImage:[UIImage imageNamed:@"S4.1_today-selected.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kTomorrowFilter]setImage:[UIImage imageNamed:@"S4.1_tomorrow-deselect.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kLaterFilter]setImage:[UIImage imageNamed:@"S4.1_later-deselect.png"] forState:UIControlStateNormal];


                
        }
            break;
            
        case kTomorrowFilter:
        {
            SOC.filterObject.whenSearchType=2;
            [sender setImage:[UIImage imageNamed:@"S4.1_tomorrow-selected.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kTodayFilter]setImage:[UIImage imageNamed:@"S4.1_today-deselect.png"] forState:UIControlStateNormal];
            [(UIButton*)[self viewWithTag:kLaterFilter]setImage:[UIImage imageNamed:@"S4.1_later-deselect.png"] forState:UIControlStateNormal];
                
        }
            break;
            
        case kLaterFilter:
        {
            SOC.filterObject.whenSearchType=3;
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
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
     [self.homeSearchBar resignFirstResponder];
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.homeSearchBar resignFirstResponder];
}

@end
