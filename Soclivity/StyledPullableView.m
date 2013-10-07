//
//  StyledPullableView.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StyledPullableView.h"
#import "SoclivityUtilities.h"
#import "SoclivityManager.h"
#import "FilterPreferenceClass.h"
@implementation StyledPullableView
@synthesize homeSearchBar;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

        self.backgroundColor=[UIColor clearColor];
        tracker=0;
        SOC=[SoclivityManager SharedInstance];
        filterPaneView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 640, 402)];
        filterPaneView.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
        

        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, 320, 44)];
        searchBar.delegate=self;
        [searchBar setShowsCancelButton:NO animated:YES];
        searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        searchBar.placeholder=@"Search for activities or people";
        [filterPaneView addSubview:searchBar];
        }
        else{
        self.homeSearchBar = [[[CustomSearchbar alloc] initWithFrame:CGRectMake(0, 40, 320, 44)] autorelease];
        self.homeSearchBar.delegate = self;
        self.homeSearchBar.CSDelegate=self;
        if(self.homeSearchBar.text!=nil){
            self.homeSearchBar.showsCancelButton = YES;
        }
        
        self.homeSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        self.homeSearchBar.placeholder=@"Search for activities or people";
        self.homeSearchBar.backgroundImage=[UIImage imageNamed: @"S4.1_search-background.png"];
        [filterPaneView addSubview:self.homeSearchBar];
        }
        
        
#if 0        
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
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"S04.1_button.png"] forState:UIControlStateNormal];
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"S04.1_buttonSelected.png"] forState:UIControlStateHighlighted];
                
                
            }
            
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [(UITextField *)subview setTextColor:[SoclivityUtilities returnTextFontColor:1]];
                [(UITextField *)subview setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];

                [(UITextField *)subview setBackground:[UIImage imageNamed:@"S4.1_search-bar.png"]];
                [(UITextField *)subview setBorderStyle:UITextBorderStyleNone];
            }
        }
#endif        
        // Block of code for the activity types
        CGRect actTypesLabelRect=CGRectMake(10,95,165,15);
        UILabel *actTypesLabel=[[UILabel alloc] initWithFrame:actTypesLabelRect];
        actTypesLabel.textAlignment=NSTextAlignmentLeft;
        actTypesLabel.text=[NSString stringWithFormat:@"ACTIVITY TYPES"];
        actTypesLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        actTypesLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        actTypesLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:actTypesLabel];
        [actTypesLabel release];
        
        UIButton *playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        playButton.frame = CGRectMake(25,125,55,51);
        playButton.tag=kPlayActivity;
        [playButton setImage:[UIImage imageNamed:@"S04.1_play.png"] forState:UIControlStateNormal];
        
        

        [playButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:playButton];
        

        
        
        UIImageView *playTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        playTickImageView.frame=CGRectMake(45, 135, 16, 15);
        playTickImageView.tag=kPlayTickImage;
        [filterPaneView addSubview:playTickImageView];
        
        
        CGRect playTypeLabelRect=CGRectMake(25,155-1,55,16);
        UILabel *playTypeLabel=[[UILabel alloc] initWithFrame:playTypeLabelRect];
        playTypeLabel.textAlignment=NSTextAlignmentLeft;
        playTypeLabel.text=[NSString stringWithFormat:@"Play"];
        playTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        playTypeLabel.textColor=[UIColor whiteColor];
        playTypeLabel.textAlignment = NSTextAlignmentCenter;
        playTypeLabel.tag=kPlayLabelText;
        playTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:playTypeLabel];
        
        
        
        if(!SOC.filterObject.playDD){
            playTickImageView.alpha=0.3f;
            playTypeLabel.alpha=0.3f;

        }
        [playTickImageView release];
        [playTypeLabel release];
        UIButton *eatButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        eatButton.frame = CGRectMake(80,125,55,51);
        eatButton.tag=kEatActivity;
        [eatButton setImage:[UIImage imageNamed:@"S04.1_eat.png"] forState:UIControlStateNormal];
        
        [eatButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:eatButton];
        
        UIImageView *eatTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        eatTickImageView.frame=CGRectMake(100, 135, 16, 15);
        eatTickImageView.tag=kEatTickImage;
        [filterPaneView addSubview:eatTickImageView];
        
        
        CGRect eatTypeLabelRect=CGRectMake(80,155,55,15);
        UILabel *eatTypeLabel=[[UILabel alloc] initWithFrame:eatTypeLabelRect];
        eatTypeLabel.textAlignment=NSTextAlignmentLeft;
        eatTypeLabel.text=[NSString stringWithFormat:@"Eat"];
        eatTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        eatTypeLabel.textColor=[UIColor whiteColor];
        eatTypeLabel.textAlignment = NSTextAlignmentCenter;
        eatTypeLabel.tag=kEatLabelText;
        eatTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:eatTypeLabel];
        
        
        
        if(!SOC.filterObject.eatDD){
            eatTickImageView.alpha=0.3f;
            eatTypeLabel.alpha=0.3f;
            
        }
        [eatTickImageView release];
        [eatTypeLabel release];
        UIButton *seeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        seeButton.frame = CGRectMake(135,125,55,51);
        seeButton.tag=kSeeActivity;
        [seeButton setImage:[UIImage imageNamed:@"S04.1_see.png"] forState:UIControlStateNormal];
        
        [seeButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:seeButton];
        
        UIImageView *seeTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        seeTickImageView.frame=CGRectMake(155, 135, 16, 15);
        seeTickImageView.tag=kSeeTickImage;
        [filterPaneView addSubview:seeTickImageView];
        
        
        CGRect seeTypeLabelRect=CGRectMake(135,155,55,15);
        UILabel *seeTypeLabel=[[UILabel alloc] initWithFrame:seeTypeLabelRect];
        seeTypeLabel.textAlignment=NSTextAlignmentLeft;
        seeTypeLabel.text=[NSString stringWithFormat:@"See"];
        seeTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        seeTypeLabel.textColor=[UIColor whiteColor];
        seeTypeLabel.textAlignment = NSTextAlignmentCenter;
        seeTypeLabel.tag=kSeeLabelText;
        seeTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:seeTypeLabel];
        
        
        
        if(!SOC.filterObject.seeDD){
            seeTickImageView.alpha=0.3f;
            seeTypeLabel.alpha=0.3f;
            
        }
        [seeTickImageView release];
        [seeTypeLabel release];
        
        UIButton *createButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        createButton.frame = CGRectMake(190,125,55,51);
        createButton.tag=kCreateActivity;
        [createButton setImage:[UIImage imageNamed:@"S04.1_create.png"] forState:UIControlStateNormal];
        
        [createButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:createButton];
        
        UIImageView *createTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        createTickImageView.frame=CGRectMake(210, 135, 16, 15);
        createTickImageView.tag=kCreateTickImage;
        [filterPaneView addSubview:createTickImageView];
        
        
        CGRect createTypeLabelRect=CGRectMake(190,155,55,15);
        UILabel *createTypeLabel=[[UILabel alloc] initWithFrame:createTypeLabelRect];
        createTypeLabel.textAlignment=NSTextAlignmentLeft;
        createTypeLabel.text=[NSString stringWithFormat:@"Create"];
        createTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        createTypeLabel.textColor=[UIColor whiteColor];
        createTypeLabel.textAlignment = NSTextAlignmentCenter;
        createTypeLabel.tag=kCreateLabelText;
        createTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:createTypeLabel];
        
        
        
        if(!SOC.filterObject.createDD){
            createTickImageView.alpha=0.3f;
            createTypeLabel.alpha=0.3f;
            
        }
        [createTickImageView release];
        [createTypeLabel release];
        
        UIButton *learnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        learnButton.frame = CGRectMake(245,125,55,51);
        learnButton.tag=kLearnActivity;
        [learnButton setImage:[UIImage imageNamed:@"S04.1_learn.png"] forState:UIControlStateNormal];
        
        [learnButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:learnButton];
        
        UIImageView *learnTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        learnTickImageView.frame=CGRectMake(265, 135, 16, 15);
        learnTickImageView.tag=kLearnTickImage;
        [filterPaneView addSubview:learnTickImageView];
        
        
        CGRect learnTypeLabelRect=CGRectMake(245,155,55,15);
        UILabel *learnTypeLabel=[[UILabel alloc] initWithFrame:learnTypeLabelRect];
        learnTypeLabel.textAlignment=NSTextAlignmentLeft;
        learnTypeLabel.text=[NSString stringWithFormat:@"Learn"];
        learnTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        learnTypeLabel.textColor=[UIColor whiteColor];
        learnTypeLabel.textAlignment = NSTextAlignmentCenter;
        learnTypeLabel.tag=kLearnLabelText;
        learnTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:learnTypeLabel];
        
        
        
        if(!SOC.filterObject.learnDD){
            learnTickImageView.alpha=0.3f;
            learnTypeLabel.alpha=0.3f;
            
        }
        [learnTickImageView release];
        [learnTypeLabel release];
        
        // Dates selection section
        UIImageView *calendarIconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_calendarIcon.png"]];
        calendarIconImageView.frame=CGRectMake(10, 197, 26, 25);
        [filterPaneView addSubview:calendarIconImageView];
        [calendarIconImageView release];
        
        UIImageView *horizontalDividerImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_horizontalDivider.png"]];
        horizontalDividerImageView.frame=CGRectMake(41, 207, 269, 1);
        [filterPaneView addSubview:horizontalDividerImageView];
        [horizontalDividerImageView release];
        
        
        UIButton *next2DaysButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [next2DaysButton setFrame:CGRectMake(12,228,100,40)];
        next2DaysButton.tag=kNextTwoDays;
        [next2DaysButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:next2DaysButton];
        
        UIImageView *next2DaysTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_datesCheck.png"]];
        next2DaysTickImageView.frame=CGRectMake(54, 228, 16, 15);
        next2DaysTickImageView.tag=kNextTwoDaysTickImage;
        [filterPaneView addSubview:next2DaysTickImageView];
        
        CGRect next2DaysLabelRect=CGRectMake(12,253-1,100,16);
        UILabel *next2DaysLabel=[[UILabel alloc] initWithFrame:next2DaysLabelRect];
        next2DaysLabel.textAlignment=NSTextAlignmentCenter;
        next2DaysLabel.text=[NSString stringWithFormat:@"Next 2 Days"];
        next2DaysLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        next2DaysLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        next2DaysLabel.tag=kNextTwoDaysText;
        next2DaysLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:next2DaysLabel];
        
        
        
        UIImageView *datesVerticalDividerImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_datesVerticalDivider.png"]];
        datesVerticalDividerImageView.frame=CGRectMake(112, 233, 1, 29);
        [filterPaneView addSubview:datesVerticalDividerImageView];
        [datesVerticalDividerImageView release];
        
        
        UIButton *next7DaysButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [next7DaysButton setFrame:CGRectMake(113,228,100,40)];
        next7DaysButton.tag=kNextSevenDays;
        [next7DaysButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:next7DaysButton];
        
        UIImageView *next7DaysTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_datesCheck.png"]];
        next7DaysTickImageView.frame=CGRectMake(155, 228, 16, 15);
        next7DaysTickImageView.tag=kNextSevenDaysTickImage;
        [filterPaneView addSubview:next7DaysTickImageView];
        
        CGRect next7DaysLabelRect=CGRectMake(113,253-1,100,16);
        UILabel *next7DaysLabel=[[UILabel alloc] initWithFrame:next7DaysLabelRect];
        next7DaysLabel.textAlignment=NSTextAlignmentCenter;
        next7DaysLabel.text=[NSString stringWithFormat:@"Next 7 Days"];
        next7DaysLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        next7DaysLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        next7DaysLabel.tag=kNextSevenDaysText;
        next7DaysLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:next7DaysLabel];
        
        
        UIImageView *datesVerticalDividerImageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_datesVerticalDivider.png"]];
        datesVerticalDividerImageView2.frame=CGRectMake(213, 233, 1, 29);
        [filterPaneView addSubview:datesVerticalDividerImageView2];
        [datesVerticalDividerImageView2 release];
        
        UIButton *pickADayButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        pickADayButton.frame = CGRectMake(214,228,100,45);
        pickADayButton.tag=kPickADay;
        [pickADayButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:pickADayButton];
        
        UIImageView *pickADayTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_pickADayIcon.png"]];
        pickADayTickImageView.frame=CGRectMake(257, 228, 14, 15);
        pickADayTickImageView.tag=kPickADayTickImage;
        [filterPaneView addSubview:pickADayTickImageView];
        
        CGRect pickADayLabelRect=CGRectMake(220,253-1,90,16);
        UILabel *pickADayLabel=[[UILabel alloc] initWithFrame:pickADayLabelRect];
        pickADayLabel.textAlignment=NSTextAlignmentCenter;
        pickADayLabel.text=SOC.filterObject.lastDateString;
        pickADayLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        pickADayLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        pickADayLabel.tag=kPickADayText;
        pickADayLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:pickADayLabel];
        
        // Time selection section
        UIImageView *clockIconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_clock.png"]];
        clockIconImageView.frame=CGRectMake(10, 292, 24, 23);
        [filterPaneView addSubview:clockIconImageView];
        [clockIconImageView release];
        
        UIImageView *horizontalDividerImageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_horizontalDivider.png"]];
        horizontalDividerImageView2.frame=CGRectMake(41, 299, 269, 1);
        [filterPaneView addSubview:horizontalDividerImageView2];
        [horizontalDividerImageView2 release];
        
        UIButton *morningButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        morningButton.frame =CGRectMake(12,320,100,55);
        morningButton.tag=kMorningButton;
        [morningButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:morningButton];
        
        UIImageView *sunriseImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_sunriseSelected.png"]];
        sunriseImageView.frame=CGRectMake(55, 320, 15,9);
        sunriseImageView.tag=kSunriseImage;
        [filterPaneView addSubview:sunriseImageView];

        
        CGRect morningLabelRect=CGRectMake(12,335-1,100,16);
        UILabel *morningLabel=[[UILabel alloc] initWithFrame:morningLabelRect];
        morningLabel.textAlignment=NSTextAlignmentCenter;
        morningLabel.text=[NSString stringWithFormat:@"Morning"];
        morningLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        morningLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        morningLabel.tag=kMorningText;
        morningLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:morningLabel];

        
        CGRect Am12_Am11_LabelRect=CGRectMake(12,355,100,15);
        UILabel *Am12_Am11Label=[[UILabel alloc] initWithFrame:Am12_Am11_LabelRect];
        Am12_Am11Label.textAlignment=NSTextAlignmentCenter;
        Am12_Am11Label.text=[NSString stringWithFormat:@"Before 12pm"];
        Am12_Am11Label.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        Am12_Am11Label.textColor=[SoclivityUtilities returnTextFontColor:5];
        Am12_Am11Label.tag=kAm12_Am11;
        Am12_Am11Label.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:Am12_Am11Label];

        
        
        if(!SOC.filterObject.morning){
            
            morningLabel.alpha=0.3f;
            sunriseImageView.alpha=0.3f;
            sunriseImageView.image=[UIImage imageNamed:@"S04.1_sunriseUnselected.png"];
            Am12_Am11Label.alpha=0.3f;
            
        }
            [sunriseImageView release];
            [morningLabel release];
            [Am12_Am11Label release];
        
        UIImageView *timeVerticalDividerImageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_timeVerticalDivider.png"]];
        timeVerticalDividerImageView1.frame=CGRectMake(112, 323, 1, 41);
        [filterPaneView addSubview:timeVerticalDividerImageView1];
        [timeVerticalDividerImageView1 release];

        UIButton *afternoonButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        afternoonButton.frame =CGRectMake(113,320,100,55);
        afternoonButton.tag=kAfternoonButton;
        [afternoonButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:afternoonButton];
        
        UIImageView *sunSelectedImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_sunSelected.png"]];
        sunSelectedImageView.frame=CGRectMake(155, 314, 16, 15);
        sunSelectedImageView.tag=kSunSelectedImage;
        [filterPaneView addSubview:sunSelectedImageView];
        
        CGRect afternoonLabelRect=CGRectMake(113,335-1,100,16);
        UILabel *afternoonLabel=[[UILabel alloc] initWithFrame:afternoonLabelRect];
        afternoonLabel.textAlignment=NSTextAlignmentCenter;
        afternoonLabel.text=[NSString stringWithFormat:@"Afternoon"];
        afternoonLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        afternoonLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        afternoonLabel.tag=kAfternoonText;
        afternoonLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:afternoonLabel];
        
        CGRect Pm12_Pm6_LabelRect=CGRectMake(113,355,100,15);
        UILabel *Pm12_Pm6_Label=[[UILabel alloc] initWithFrame:Pm12_Pm6_LabelRect];
        Pm12_Pm6_Label.textAlignment=NSTextAlignmentCenter;
        Pm12_Pm6_Label.text=[NSString stringWithFormat:@"12pm - 6pm"];
        Pm12_Pm6_Label.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        Pm12_Pm6_Label.textColor=[SoclivityUtilities returnTextFontColor:5];
        Pm12_Pm6_Label.tag=kPm12_Pm6;
        Pm12_Pm6_Label.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:Pm12_Pm6_Label];
        
        
        if(!SOC.filterObject.afternoon){
            
            afternoonLabel.alpha=0.3f;
            sunSelectedImageView.alpha=0.3f;
            sunSelectedImageView.image=[UIImage imageNamed:@"S04.1_sunUnselected.png"];
            Pm12_Pm6_Label.alpha=0.3f;
            
        }
        [afternoonLabel release];
        [sunSelectedImageView release];
        [Pm12_Pm6_Label release];
        
        UIImageView *timeVerticalDividerImageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_timeVerticalDivider.png"]];
        timeVerticalDividerImageView2.frame=CGRectMake(213, 323, 1, 41);
        [filterPaneView addSubview:timeVerticalDividerImageView2];
        [timeVerticalDividerImageView2 release];
        
        UIButton *eveningButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [eveningButton setFrame:CGRectMake(214,320,100,55)];
        eveningButton.tag=kEveningButton;
        [eveningButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:eveningButton];
        
        UIImageView *moonSelectedImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_moonSelected.png"]];
        moonSelectedImageView.frame=CGRectMake(255, 314, 13, 15);
        moonSelectedImageView.tag=kMoonSelectedImage;
        [filterPaneView addSubview:moonSelectedImageView];

        
        CGRect eveningLabelRect=CGRectMake(214,335-1,100,16);
        UILabel *eveningLabel=[[UILabel alloc] initWithFrame:eveningLabelRect];
        eveningLabel.textAlignment=NSTextAlignmentCenter;
        eveningLabel.text=[NSString stringWithFormat:@"Evening"];
        eveningLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        eveningLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        eveningLabel.tag=kEveningText;
        eveningLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:eveningLabel];

        
        CGRect Pm7_Pm11_LabelRect=CGRectMake(214,355,100,15);
        UILabel *Pm7_Pm11_Label=[[UILabel alloc] initWithFrame:Pm7_Pm11_LabelRect];
        Pm7_Pm11_Label.textAlignment=NSTextAlignmentCenter;
        Pm7_Pm11_Label.text=[NSString stringWithFormat:@"After 6pm"];
        Pm7_Pm11_Label.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        Pm7_Pm11_Label.textColor=[SoclivityUtilities returnTextFontColor:1];
        Pm7_Pm11_Label.tag=kPm7_Pm11;
        Pm7_Pm11_Label.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:Pm7_Pm11_Label];
        
        
        if(!SOC.filterObject.evening){
        eveningLabel.alpha=0.3f;
        moonSelectedImageView.image=[UIImage imageNamed:@"S04.1_moonUnselected.png"];
        moonSelectedImageView.alpha=0.3f;
        Pm7_Pm11_Label.alpha=0.3f;
            
        }

        [Pm7_Pm11_Label release];
        [eveningLabel release];
        [moonSelectedImageView release];
        
        
        switch (SOC.filterObject.whenSearchType) {
            case 1:
            {
                tracker=0;
                next7DaysLabel.alpha=0.3f;
                next7DaysTickImageView.alpha=0.3f;
                pickADayLabel.alpha=0.3f;
                pickADayTickImageView.alpha=0.3f;
                pickADayLabel.text=@"Pick A Day";
                SOC.filterObject.lastDateString=[NSString stringWithFormat:@"Pick A Date"];
                
                
            }
                break;
            case 2:
            {
                tracker=1;
                
                next2DaysLabel.alpha=0.3f;
                next2DaysTickImageView.alpha=0.3f;
                pickADayLabel.alpha=0.3f;
                pickADayTickImageView.alpha=0.3f;
                pickADayLabel.text=@"Pick A Day";
                SOC.filterObject.lastDateString=[NSString stringWithFormat:@"Pick A Date"];
                
            }
                break;
                
                
            case 3:
                
            {
                NSString *firstLetter = [SOC.filterObject.lastDateString  substringToIndex:1];
                if(![firstLetter isEqualToString:@"P"]){
                    tracker=2;
                }
                next2DaysLabel.alpha=0.3f;
                next2DaysTickImageView.alpha=0.3f;
                next7DaysLabel.alpha=0.3f;
                next7DaysTickImageView.alpha=0.3f;

            }
                break;
                
                
        }
        
        
        [next2DaysLabel release];
        [next2DaysTickImageView release];
        [pickADayLabel release];
        [pickADayTickImageView release];
        [next7DaysLabel release];
        [next7DaysTickImageView release];
        
        
         if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        handleCheckButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        handleCheckButton.tag=6569;
        handleCheckButton.frame = CGRectMake(128, 389, 64.0, 33.0);//397
        [handleCheckButton setImage:[UIImage imageNamed:@"applyFilter.png"] forState:UIControlStateNormal];
        [handleCheckButton addTarget:self action:@selector(handleCheckMarkClicked:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:handleCheckButton];
        [handleCheckButton setHidden:YES];
         }


        
        UIButton *searchHandleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        

        searchHandleButton.frame = CGRectMake(5, 397, 58.0, 57.0);//397
        [searchHandleButton setImage:[UIImage imageNamed:@"S04_bookmark.png"] forState:UIControlStateNormal];
        [searchHandleButton addTarget:self action:@selector(pushTodetailActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchHandleButton];
        searchHandleButton.hidden=YES;
        
        UIView *dateCalendarView=[[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, 402)];
        dateCalendarView.backgroundColor=[UIColor whiteColor];
        
        UIImageView *titleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topbar.png"]];
        titleImageView.frame=CGRectMake(0, 40, 320, 44);
        [dateCalendarView addSubview:titleImageView];
        [titleImageView release];
        
        
        UIButton *crossButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        crossButton.frame = CGRectMake(15, 51.5, 21.0, 21.0);
        [crossButton setImage:[UIImage imageNamed:@"S04.1.1_cross.png"] forState:UIControlStateNormal];
        crossButton.tag=kCrossDateSelection;
        [crossButton addTarget:self action:@selector(pushTransformWithAnimation:) forControlEvents:UIControlEventTouchUpInside];
        [dateCalendarView addSubview:crossButton];
        
        
        UIButton *tickButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        tickButton.frame = CGRectMake(281, 51.5, 25.0, 20.0);
        [tickButton setImage:[UIImage imageNamed:@"S04.1.1_tick.png"] forState:UIControlStateNormal];
        tickButton.tag=kTickDateSelection;
        [tickButton addTarget:self action:@selector(pushTransformWithAnimation:) forControlEvents:UIControlEventTouchUpInside];
        [dateCalendarView addSubview:tickButton];

        
        calendarDate=[[CalendarDateView alloc]initWithFrame:CGRectMake(0, 84, 320,354)editActivityDate:[NSDate date]];
        calendarDate.KALDelegate=self;
        [dateCalendarView addSubview:calendarDate];


        [filterPaneView addSubview:dateCalendarView];

        
        
        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
            searchLensImageView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 415, 20, 21)];
            searchLensImageView.image=[UIImage imageNamed:@"S04_search.png"];
            [self addSubview:searchLensImageView];
            
            
            crossImageView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 415, 22, 18)];
            crossImageView.image=[UIImage imageNamed:@"S04.1_cross.png"];
            [self addSubview:crossImageView];
            crossImageView.hidden=YES;

            searchLensImageView.hidden=NO;
            searchHandleButton.hidden=NO;

        }
        
        
        self.notificationView=[[UIView alloc]initWithFrame:CGRectMake(0, 400, 320, 60)];
        [self addSubview:self.notificationView];
        [notificationView setUserInteractionEnabled:NO];
        
        [self addSubview:filterPaneView];
        [self insertSubview:filterPaneView atIndex:0];
        [self insertSubview:searchHandleButton atIndex:0];
        [self insertSubview:searchHandleButton aboveSubview:filterPaneView]; 

        }
    return self;
}


-(void)handleCheckMarkClicked:(id)sender{
     [self setOpened:NO animated:YES];
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
            SOC.filterObject.playDD=!SOC.filterObject.playDD;
            if(SOC.filterObject.playDD){
                [(UILabel*)[self viewWithTag:kPlayLabelText] setAlpha:1.0f];
                [(UIImageView*)[self viewWithTag:kPlayTickImage]setAlpha:1.0f];


            }
            else{
                [(UILabel*)[self viewWithTag:kPlayLabelText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kPlayTickImage]setAlpha:0.3f];
                }
        }
            break;
            
            
        case kEatActivity:
        {
            SOC.filterObject.eatDD=!SOC.filterObject.eatDD;
            if(SOC.filterObject.eatDD){
                [(UILabel*)[self viewWithTag:kEatLabelText] setAlpha:1.0f];
                [(UIImageView*)[self viewWithTag:kEatTickImage]setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kEatLabelText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kEatTickImage]setAlpha:0.3f];
                
            }
        }
            break;
            
        case kSeeActivity:
        {
            SOC.filterObject.seeDD=!SOC.filterObject.seeDD;
            if(SOC.filterObject.seeDD){
                [(UILabel*)[self viewWithTag:kSeeLabelText] setAlpha:1.0f];
                [(UIImageView*)[self viewWithTag:kSeeTickImage]setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kSeeLabelText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kSeeTickImage]setAlpha:0.3f];
                
            }
        }
            break;
            
        case kCreateActivity:
        {
            SOC.filterObject.createDD=!SOC.filterObject.createDD;
            if(SOC.filterObject.createDD){
                [(UILabel*)[self viewWithTag:kCreateLabelText] setAlpha:1.0f];
                [(UIImageView*)[self viewWithTag:kCreateTickImage]setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kCreateLabelText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kCreateTickImage]setAlpha:0.3f];
                
            }
        }
            break;
            
            
        case kLearnActivity:
        {
            SOC.filterObject.learnDD=!SOC.filterObject.learnDD;
            if(SOC.filterObject.learnDD){
                [(UILabel*)[self viewWithTag:kLearnLabelText] setAlpha:1.0f];
                [(UIImageView*)[self viewWithTag:kLearnTickImage]setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kLearnLabelText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kLearnTickImage]setAlpha:0.3f];
                
            }
        }
            break;
            
        case kNextTwoDays:
        {
            tracker=0;
            SOC.filterObject.whenSearchType=1;
            [(UILabel*)[self viewWithTag:kNextTwoDaysText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kNextTwoDaysTickImage]setAlpha:1.0f];
            [(UILabel*)[self viewWithTag:kNextSevenDaysText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kNextSevenDaysTickImage]setAlpha:0.3f];
            [(UILabel*)[self viewWithTag:kPickADayText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kPickADayTickImage]setAlpha:0.3f];
            [(UILabel*)[self viewWithTag:kPickADayText] setText:@"Pick A Day"];
            SOC.filterObject.lastDateString=[NSString stringWithFormat:@"Pick A Date"];

            
         }
            break;
            
        case kNextSevenDays:
        {
            tracker=1;
            SOC.filterObject.whenSearchType=2;
            [(UILabel*)[self viewWithTag:kNextTwoDaysText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kNextTwoDaysTickImage]setAlpha:0.3f];
            [(UILabel*)[self viewWithTag:kNextSevenDaysText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kNextSevenDaysTickImage]setAlpha:1.0f];
            [(UILabel*)[self viewWithTag:kPickADayText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kPickADayTickImage]setAlpha:0.3f];
            [(UILabel*)[self viewWithTag:kPickADayText] setText:@"Pick A Day"];
             SOC.filterObject.lastDateString=[NSString stringWithFormat:@"Pick A Date"];

        }
            break;
            
        case kPickADay:
        {
            NSString *firstLetter = [SOC.filterObject.lastDateString  substringToIndex:1];
            if(![firstLetter isEqualToString:@"P"]){
                tracker=2;
            }
            SOC.filterObject.whenSearchType=3;
            [(UILabel*)[self viewWithTag:kNextTwoDaysText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kNextTwoDaysTickImage]setAlpha:0.3f];
            [(UILabel*)[self viewWithTag:kNextSevenDaysText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kNextSevenDaysTickImage]setAlpha:0.3f];
            [(UILabel*)[self viewWithTag:kPickADayText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kPickADayTickImage]setAlpha:1.0f];

            [self slideOutFilterPane];
            
        }
            break;
            
        case kMorningButton:
        {
            SOC.filterObject.morning=!SOC.filterObject.morning;
            if(SOC.filterObject.morning){
            [(UILabel*)[self viewWithTag:kMorningText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kSunriseImage]setImage:[UIImage imageNamed:@"S04.1_sunriseSelected.png"]];
            [(UIImageView*)[self viewWithTag:kSunriseImage]setAlpha:1.0f];
            [(UILabel*)[self viewWithTag:kAm12_Am11] setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kMorningText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kSunriseImage]setImage:[UIImage imageNamed:@"S04.1_sunriseUnselected.png"]];
                [(UIImageView*)[self viewWithTag:kSunriseImage]setAlpha:0.3f];
                [(UILabel*)[self viewWithTag:kAm12_Am11] setAlpha:0.3f];
                
            }
        }
            break;
            
        case kAfternoonButton:
        {
            SOC.filterObject.afternoon=!SOC.filterObject.afternoon;
            if(SOC.filterObject.afternoon){
                [(UILabel*)[self viewWithTag:kAfternoonText] setAlpha:1.0f];
                [(UIImageView*)[self viewWithTag:kSunSelectedImage]setImage:[UIImage imageNamed:@"S04.1_sunSelected.png"]];
                [(UIImageView*)[self viewWithTag:kSunSelectedImage]setAlpha:1.0f];
                [(UILabel*)[self viewWithTag:kPm12_Pm6] setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kAfternoonText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kSunSelectedImage]setImage:[UIImage imageNamed:@"S04.1_sunUnselected.png"]];
                [(UIImageView*)[self viewWithTag:kSunSelectedImage]setAlpha:0.3f];
                [(UILabel*)[self viewWithTag:kPm12_Pm6] setAlpha:0.3f];
                
            }
        }
            break;
            
        case kEveningButton:
        {
            SOC.filterObject.evening=!SOC.filterObject.evening;
            if(SOC.filterObject.evening){
                [(UILabel*)[self viewWithTag:kEveningText] setAlpha:1.0f];
                [(UIImageView*)[self viewWithTag:kMoonSelectedImage]setImage:[UIImage imageNamed:@"S04.1_moonSelected.png"]];
                [(UIImageView*)[self viewWithTag:kMoonSelectedImage]setAlpha:1.0f];
                [(UILabel*)[self viewWithTag:kPm7_Pm11] setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kEveningText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kMoonSelectedImage]setImage:[UIImage imageNamed:@"S04.1_moonUnselected.png"]];
                [(UIImageView*)[self viewWithTag:kMoonSelectedImage]setAlpha:0.3f];
                [(UILabel*)[self viewWithTag:kPm7_Pm11] setAlpha:0.3f];
                
            }
        }
            break;

            
            
    }
    
    [SOC userProfileDataUpdate];

}

-(void)pushTransformWithAnimation:(UIButton*)sender{
    
    int tag=sender.tag;
    
    switch (tag) {
        case kCrossDateSelection:
        {
            switch (tracker) {
                case 0:
                {
                   
                    
                    SOC.filterObject.whenSearchType=1;
                    tracker=0;
                    [(UILabel*)[self viewWithTag:kNextTwoDaysText] setAlpha:1.0f];
                    [(UIImageView*)[self viewWithTag:kNextTwoDaysTickImage]setAlpha:1.0f];
                    [(UILabel*)[self viewWithTag:kNextSevenDaysText] setAlpha:0.3f];
                    [(UIImageView*)[self viewWithTag:kNextSevenDaysTickImage]setAlpha:0.3f];
                    [(UILabel*)[self viewWithTag:kPickADayText] setAlpha:0.3f];
                    [(UIImageView*)[self viewWithTag:kPickADayTickImage]setAlpha:0.3f];
                    [(UILabel*)[self viewWithTag:kPickADayText] setText:@"Pick A Day"];

                    
                }
                    break;
                    
                case 1:
                {
                    
                    tracker=1;
                    SOC.filterObject.whenSearchType=2;
                    [(UILabel*)[self viewWithTag:kNextTwoDaysText] setAlpha:0.3f];
                    [(UIImageView*)[self viewWithTag:kNextTwoDaysTickImage]setAlpha:0.3f];
                    [(UILabel*)[self viewWithTag:kNextSevenDaysText] setAlpha:1.0f];
                    [(UIImageView*)[self viewWithTag:kNextSevenDaysTickImage]setAlpha:1.0f];
                    [(UILabel*)[self viewWithTag:kPickADayText] setAlpha:0.3f];
                    [(UIImageView*)[self viewWithTag:kPickADayTickImage]setAlpha:0.3f];
                    [(UILabel*)[self viewWithTag:kPickADayText] setText:@"Pick A Day"];

                    
            }
                    break;
                    
                case 2:
                {
                     NSString *firstLetter = [SOC.filterObject.lastDateString  substringToIndex:1];
                     if(![firstLetter isEqualToString:@"P"]){
                        SOC.filterObject.startPickDateTime=SOC.filterObject.lastStartPickDateTime;
                        SOC.filterObject.endPickDateTime=SOC.filterObject.lastEndPickDateTime;
                        
                    }
                    [(UILabel*)[self viewWithTag:kPickADayText] setText:SOC.filterObject.lastDateString];
                    
                }
                 
                    
                    
                default:
                    break;
            }
        }
            break;
            
        case kTickDateSelection:
        {
            SOC.filterObject.lastDateString=SOC.filterObject.pickADateString;
            SOC.filterObject.lastStartPickDateTime=SOC.filterObject.startPickDateTime;
            SOC.filterObject.lastEndPickDateTime=SOC.filterObject.endPickDateTime;
             [(UILabel*)[self viewWithTag:kPickADayText] setText:SOC.filterObject.pickADateString];
        }
            break;
    
            
            
        default:
            break;
    }
    
    [self bringInFilterPane];
}

-(void)updateActivityTypes{
    
    SOC=[SoclivityManager SharedInstance];
    
        if(SOC.filterObject.playDD){
            [(UILabel*)[self viewWithTag:kPlayLabelText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kPlayTickImage]setAlpha:1.0f];
            
            
        }
        else{
            [(UILabel*)[self viewWithTag:kPlayLabelText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kPlayTickImage]setAlpha:0.3f];
        }
        if(SOC.filterObject.eatDD){
            [(UILabel*)[self viewWithTag:kEatLabelText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kEatTickImage]setAlpha:1.0f];
        }
        else{
            [(UILabel*)[self viewWithTag:kEatLabelText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kEatTickImage]setAlpha:0.3f];
            
        }
        if(SOC.filterObject.seeDD){
            [(UILabel*)[self viewWithTag:kSeeLabelText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kSeeTickImage]setAlpha:1.0f];
        }
        else{
            [(UILabel*)[self viewWithTag:kSeeLabelText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kSeeTickImage]setAlpha:0.3f];
            
        }
        if(SOC.filterObject.createDD){
            [(UILabel*)[self viewWithTag:kCreateLabelText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kCreateTickImage]setAlpha:1.0f];
        }
        else{
            [(UILabel*)[self viewWithTag:kCreateLabelText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kCreateTickImage]setAlpha:0.3f];
            
        }
        if(SOC.filterObject.learnDD){
            [(UILabel*)[self viewWithTag:kLearnLabelText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kLearnTickImage]setAlpha:1.0f];
        }
        else{
            [(UILabel*)[self viewWithTag:kLearnLabelText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kLearnTickImage]setAlpha:0.3f];
            
        }
    
    
    
}

-(void)pushTodetailActivity:(UIButton*)sender{
    NSLog(@"pushTodetailActivity=%f,%f,%f,%f",sender.frame.size.height,sender.frame.size.width,sender.frame.origin.x,sender.frame.origin.y);
}
#pragma mark -
#pragma mark UISearchBarDelegate


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
    [searchBar setShowsCancelButton:YES animated:YES];
#if 0
    
    for (UIView *subview in [self.homeSearchBar subviews]) {
        UIButton *cancelButton = nil;
        if([subview isKindOfClass:[UIButton class]]){
            cancelButton = (UIButton*)subview;
            UILabel *cancelLabel=[cancelButton titleLabel];
            cancelLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
            cancelLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
            cancelLabel.backgroundColor=[UIColor clearColor];
            cancelLabel.text=@"Clear";

        }
        if (cancelButton){
            NSLog(@"cancelButton");
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"S04.1_button.png"] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"S04.1_buttonSelected.png"] forState:UIControlStateHighlighted];
            }   
        }
#endif
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidEndEditing=%@",searchBar.text);
    SOC.filterObject.searchText=searchBar.text;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    
    if([self.homeSearchBar.text isEqualToString:@""]){
        
        [searchBar setShowsCancelButton:NO animated:YES];
        self.homeSearchBar.showClearButton=NO;
        
    }
    else{
        [searchBar setShowsCancelButton:NO animated:NO];
         self.homeSearchBar.showClearButton=NO;
 }
    [searchBar setShowsCancelButton:YES animated:NO];

}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
     self.homeSearchBar.text=@"";
     [searchBar setShowsCancelButton:NO animated:YES];
     [self.homeSearchBar resignFirstResponder];
     [searchBar resignFirstResponder];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        searchBar.text=@"";
    }
    SOC.filterObject.searchText=searchBar.text;
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
     
    [self.homeSearchBar resignFirstResponder];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    for (UIView *possibleButton in [[searchBar.subviews objectAtIndex:0]subviews])
    {
        if ([possibleButton isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)possibleButton;
            cancelButton.enabled = YES;
            break;
        }
    }
    }
}
-(void)customCancelButtonHit{
    
    self.homeSearchBar.text=@"";
    SOC.filterObject.searchText=self.homeSearchBar.text;
    self.homeSearchBar.showClearButton=NO;
    [homeSearchBar setShowsCancelButton:NO animated:YES];
    [self.homeSearchBar resignFirstResponder];
}

@end
