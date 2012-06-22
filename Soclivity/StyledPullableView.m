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
#define kPlayLabelText 22
#define kPlayTickImage 23
#define kEatTickImage 24
#define kEatLabelText 25
#define kSeeTickImage 26
#define kSeeLabelText 27
#define kCreateTickImage 28
#define kCreateLabelText 29
#define kLearnTickImage 30
#define kLearnLabelText 31
#define kNextTwoDays 32
#define kNextTwoDaysTickImage 33
#define kNextTwoDaysText 34
#define kNextSevenDays 35
#define kNextSevenDaysTickImage 36
#define kNextSevenDaysText 37
#define kPickADayText 38
#define kPickADayTickImage 39
#define kPickADay 40
#define kMorningButton 41
#define kSunriseImage 42
#define kMorningText 43
#define kAm12_Am11 44
#define kAfternoonButton 45
#define kSunSelectedImage 46
#define kAfternoonText 47
#define kPm12_Pm6 48
#define kEveningButton 49
#define kMoonSelectedImage 50
#define kEveningText 51
#define kPm7_Pm11 52
@implementation StyledPullableView
@synthesize homeSearchBar;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        self.backgroundColor=[UIColor clearColor];
        
        SOC=[SoclivityManager SharedInstance];                     
        filterPaneView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 640, 402)];//402
        filterPaneView.backgroundColor=[UIColor whiteColor];
        self.homeSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 40.0,320, 44.0)] autorelease];
        self.homeSearchBar.delegate = self;
        self.homeSearchBar.showsCancelButton =NO;
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
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"S04.1_cancel.png"] forState:UIControlStateNormal];
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"S04.1_cancelPressed.png"] forState:UIControlStateHighlighted];
                
                
            }
            
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [(UITextField *)subview setTextColor:[SoclivityUtilities returnTextFontColor:1]];
                [(UITextField *)subview setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];

                [(UITextField *)subview setBackground:[UIImage imageNamed:@"S4.1_search-bar.png"]];
                [(UITextField *)subview setBorderStyle:UITextBorderStyleNone];
            }
        }
        
#if 1        
        CGRect actTypesLabelRect=CGRectMake(10,100,165,15);
        UILabel *actTypesLabel=[[UILabel alloc] initWithFrame:actTypesLabelRect];
        actTypesLabel.textAlignment=UITextAlignmentLeft;
        actTypesLabel.text=[NSString stringWithFormat:@"ACTIVITY TYPES"];
        actTypesLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        actTypesLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        actTypesLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:actTypesLabel];
        [actTypesLabel release];
        
        
        
        
        
        
        UIButton *playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        playButton.frame = CGRectMake(22.5,125,55,51);
        playButton.tag=kPlayActivity;
        [playButton setImage:[UIImage imageNamed:@"S04.1_play.png"] forState:UIControlStateNormal];

        [playButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:playButton];
        
        UIImageView *playTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        playTickImageView.frame=CGRectMake(42, 135, 16, 15);
        playTickImageView.tag=kPlayTickImage;
        [filterPaneView addSubview:playTickImageView];
        [playTickImageView release];
        
        CGRect playTypeLabelRect=CGRectMake(38,155,45,15);
        UILabel *playTypeLabel=[[UILabel alloc] initWithFrame:playTypeLabelRect];
        playTypeLabel.textAlignment=UITextAlignmentLeft;
        playTypeLabel.text=[NSString stringWithFormat:@"Play"];
        playTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        playTypeLabel.textColor=[UIColor whiteColor];
        playTypeLabel.tag=kPlayLabelText;
        playTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:playTypeLabel];
        [playTypeLabel release];
        
        
        
        UIButton *eatButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        eatButton.frame = CGRectMake(77.5,125,55,51);
        eatButton.tag=kEatActivity;
        [eatButton setImage:[UIImage imageNamed:@"S04.1_eat.png"] forState:UIControlStateNormal];
        
        [eatButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:eatButton];
        
        UIImageView *eatTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        eatTickImageView.frame=CGRectMake(97, 135, 16, 15);
        eatTickImageView.tag=kEatTickImage;
        [filterPaneView addSubview:eatTickImageView];
        [eatTickImageView release];
        
        CGRect eatTypeLabelRect=CGRectMake(95,155,45,15);
        UILabel *eatTypeLabel=[[UILabel alloc] initWithFrame:eatTypeLabelRect];
        eatTypeLabel.textAlignment=UITextAlignmentLeft;
        eatTypeLabel.text=[NSString stringWithFormat:@"Eat"];
        eatTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        eatTypeLabel.textColor=[UIColor whiteColor];
        eatTypeLabel.tag=kEatLabelText;
        eatTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:eatTypeLabel];
        [eatTypeLabel release];
        
        UIButton *seeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        seeButton.frame = CGRectMake(132.5,125,55,51);
        seeButton.tag=kSeeActivity;
        [seeButton setImage:[UIImage imageNamed:@"S04.1_see.png"] forState:UIControlStateNormal];
        
        [seeButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:seeButton];
        
        UIImageView *seeTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        seeTickImageView.frame=CGRectMake(152, 135, 16, 15);
        seeTickImageView.tag=kSeeTickImage;
        [filterPaneView addSubview:seeTickImageView];
        [seeTickImageView release];
        
        CGRect seeTypeLabelRect=CGRectMake(150,155,45,15);
        UILabel *seeTypeLabel=[[UILabel alloc] initWithFrame:seeTypeLabelRect];
        seeTypeLabel.textAlignment=UITextAlignmentLeft;
        seeTypeLabel.text=[NSString stringWithFormat:@"See"];
        seeTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        seeTypeLabel.textColor=[UIColor whiteColor];
        seeTypeLabel.tag=kSeeLabelText;
        seeTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:seeTypeLabel];
        [seeTypeLabel release];
        
        
        
        UIButton *createButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        createButton.frame = CGRectMake(187.5,125,55,51);
        createButton.tag=kCreateActivity;
        [createButton setImage:[UIImage imageNamed:@"S04.1_create.png"] forState:UIControlStateNormal];
        
        [createButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:createButton];
        
        UIImageView *createTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        createTickImageView.frame=CGRectMake(207, 135, 16, 15);
        createTickImageView.tag=kCreateTickImage;
        [filterPaneView addSubview:createTickImageView];
        [createTickImageView release];
        
        CGRect createTypeLabelRect=CGRectMake(195,155,45,15);
        UILabel *createTypeLabel=[[UILabel alloc] initWithFrame:createTypeLabelRect];
        createTypeLabel.textAlignment=UITextAlignmentLeft;
        createTypeLabel.text=[NSString stringWithFormat:@"Create"];
        createTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        createTypeLabel.textColor=[UIColor whiteColor];
        createTypeLabel.tag=kCreateLabelText;
        createTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:createTypeLabel];
        [createTypeLabel release];
        
        
        
        UIButton *learnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        learnButton.frame = CGRectMake(241.5,125,55,51);
        learnButton.tag=kLearnActivity;
        [learnButton setImage:[UIImage imageNamed:@"S04.1_learn.png"] forState:UIControlStateNormal];
        
        [learnButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:learnButton];
        
        UIImageView *learnTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
        learnTickImageView.frame=CGRectMake(256, 135, 16, 15);
        learnTickImageView.tag=kLearnTickImage;
        [filterPaneView addSubview:learnTickImageView];
        [learnTickImageView release];
        
        CGRect learnTypeLabelRect=CGRectMake(250,155,45,15);
        UILabel *learnTypeLabel=[[UILabel alloc] initWithFrame:learnTypeLabelRect];
        learnTypeLabel.textAlignment=UITextAlignmentLeft;
        learnTypeLabel.text=[NSString stringWithFormat:@"Learn"];
        learnTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        learnTypeLabel.textColor=[UIColor whiteColor];
        learnTypeLabel.tag=kLearnLabelText;
        learnTypeLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:learnTypeLabel];
        [learnTypeLabel release];
        
        
        
        
        
        UIImageView *calendarIconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_calendarIcon.png"]];
        calendarIconImageView.frame=CGRectMake(10, 195, 26, 25);
        [filterPaneView addSubview:calendarIconImageView];
        [calendarIconImageView release];
        
        UIImageView *horizontalDividerImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_horizontalDivider.png"]];
        horizontalDividerImageView.frame=CGRectMake(44, 205, 269, 2);
        [filterPaneView addSubview:horizontalDividerImageView];
        [horizontalDividerImageView release];
        
        
        UIButton *next2DaysButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        next2DaysButton.frame = CGRectMake(45,225,90,41);
        next2DaysButton.tag=kNextTwoDays;
        [next2DaysButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:next2DaysButton];
        
        UIImageView *next2DaysTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_datesCheck.png"]];
        next2DaysTickImageView.frame=CGRectMake(60, 225, 16, 15);
        next2DaysTickImageView.tag=kNextTwoDaysTickImage;
        [filterPaneView addSubview:next2DaysTickImageView];
        [next2DaysTickImageView release];
        
        CGRect next2DaysLabelRect=CGRectMake(35,250,90,15);
        UILabel *next2DaysLabel=[[UILabel alloc] initWithFrame:next2DaysLabelRect];
        next2DaysLabel.textAlignment=UITextAlignmentLeft;
        next2DaysLabel.text=[NSString stringWithFormat:@"Next 2 Days"];
        next2DaysLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        next2DaysLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        next2DaysLabel.tag=kNextTwoDaysText;
        next2DaysLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:next2DaysLabel];
        [next2DaysLabel release];
        
        
        UIImageView *datesVerticalDividerImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_datesVerticalDivider.png"]];
        datesVerticalDividerImageView.frame=CGRectMake(120, 230, 2, 29);
        [filterPaneView addSubview:datesVerticalDividerImageView];
        [datesVerticalDividerImageView release];
        
        
        
        
        UIButton *next7DaysButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        next7DaysButton.frame = CGRectMake(140,225,90,41);
        next7DaysButton.tag=kNextSevenDays;
        [next7DaysButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:next7DaysButton];
        
        UIImageView *next7DaysTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_datesCheck.png"]];
        next7DaysTickImageView.frame=CGRectMake(155, 225, 16, 15);
        next7DaysTickImageView.tag=kNextSevenDaysTickImage;
        next7DaysTickImageView.alpha=0.3f;
        [filterPaneView addSubview:next7DaysTickImageView];
        [next7DaysTickImageView release];
        
        CGRect next7DaysLabelRect=CGRectMake(130,250,90,15);
        UILabel *next7DaysLabel=[[UILabel alloc] initWithFrame:next7DaysLabelRect];
        next7DaysLabel.textAlignment=UITextAlignmentLeft;
        next7DaysLabel.text=[NSString stringWithFormat:@"Next 7 Days"];
        next7DaysLabel.alpha=0.3f;
        next7DaysLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        next7DaysLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        next7DaysLabel.tag=kNextSevenDaysText;
        next7DaysLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:next7DaysLabel];
        [next7DaysLabel release];
        
        
        UIImageView *datesVerticalDividerImageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_datesVerticalDivider.png"]];
        datesVerticalDividerImageView2.frame=CGRectMake(220, 230, 2, 29);
        [filterPaneView addSubview:datesVerticalDividerImageView2];
        [datesVerticalDividerImageView2 release];
        
        UIButton *pickADayButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        pickADayButton.frame = CGRectMake(240,225,90,41);
        pickADayButton.tag=kPickADay;
        [pickADayButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:pickADayButton];
        
        UIImageView *pickADayTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_pickADayIcon.png"]];
        pickADayTickImageView.frame=CGRectMake(255, 225, 16, 15);
        pickADayTickImageView.tag=kPickADayTickImage;
        pickADayTickImageView.alpha=0.3f;
        [filterPaneView addSubview:pickADayTickImageView];
        [pickADayTickImageView release];
        
        CGRect pickADayLabelRect=CGRectMake(230,250,90,15);
        UILabel *pickADayLabel=[[UILabel alloc] initWithFrame:pickADayLabelRect];
        pickADayLabel.textAlignment=UITextAlignmentLeft;
        pickADayLabel.text=[NSString stringWithFormat:@"Pick A Day"];
        pickADayLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        pickADayLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        pickADayLabel.tag=kPickADayText;
        pickADayLabel.alpha=0.3f;
        pickADayLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:pickADayLabel];
        [pickADayLabel release];
        
        
        UIImageView *clockIconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_clock.png"]];
        clockIconImageView.frame=CGRectMake(10, 290, 24, 23);
        [filterPaneView addSubview:clockIconImageView];
        [clockIconImageView release];
        
        UIImageView *horizontalDividerImageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_horizontalDivider.png"]];
        horizontalDividerImageView2.frame=CGRectMake(44, 300, 269, 2);
        [filterPaneView addSubview:horizontalDividerImageView2];
        [horizontalDividerImageView2 release];
        
        
        UIButton *morningButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        morningButton.frame =CGRectMake(45,325,90,41);
        morningButton.tag=kMorningButton;
        [morningButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:morningButton];
        
        UIImageView *sunriseImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_sunriseSelected.png"]];
        sunriseImageView.frame=CGRectMake(60, 325, 15,9);
        sunriseImageView.tag=kSunriseImage;
        [filterPaneView addSubview:sunriseImageView];
        [sunriseImageView release];
        
        CGRect morningLabelRect=CGRectMake(45,345,90,15);
        UILabel *morningLabel=[[UILabel alloc] initWithFrame:morningLabelRect];
        morningLabel.textAlignment=UITextAlignmentLeft;
        morningLabel.text=[NSString stringWithFormat:@"Morning"];
        morningLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        morningLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        morningLabel.tag=kMorningText;
        morningLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:morningLabel];
        [morningLabel release];
        
        CGRect Am12_Am11_LabelRect=CGRectMake(35,365,90,15);
        UILabel *Am12_Am11Label=[[UILabel alloc] initWithFrame:Am12_Am11_LabelRect];
        Am12_Am11Label.textAlignment=UITextAlignmentLeft;
        Am12_Am11Label.text=[NSString stringWithFormat:@"12am - 11am"];
        Am12_Am11Label.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        Am12_Am11Label.textColor=[SoclivityUtilities returnTextFontColor:1];
        Am12_Am11Label.tag=kAm12_Am11;
        Am12_Am11Label.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:Am12_Am11Label];
        [Am12_Am11Label release];
        
        
        UIImageView *timeVerticalDividerImageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_timeVerticalDivider.png"]];
        timeVerticalDividerImageView1.frame=CGRectMake(120, 335, 2, 41);
        [filterPaneView addSubview:timeVerticalDividerImageView1];
        [timeVerticalDividerImageView1 release];

        UIButton *afternoonButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        afternoonButton.frame =CGRectMake(140,325,90,53);
        afternoonButton.tag=kAfternoonButton;
        [afternoonButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:afternoonButton];
        
        UIImageView *sunSelectedImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_sunSelected.png"]];
        sunSelectedImageView.frame=CGRectMake(155, 325, 16, 15);
        sunSelectedImageView.tag=kSunSelectedImage;
        [filterPaneView addSubview:sunSelectedImageView];
        [sunSelectedImageView release];
        
        CGRect afternoonLabelRect=CGRectMake(140,345,90,15);
        UILabel *afternoonLabel=[[UILabel alloc] initWithFrame:afternoonLabelRect];
        afternoonLabel.textAlignment=UITextAlignmentLeft;
        afternoonLabel.text=[NSString stringWithFormat:@"Afternoon"];
        afternoonLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        afternoonLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        afternoonLabel.tag=kAfternoonText;
        afternoonLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:afternoonLabel];
        [afternoonLabel release];
        
        CGRect Pm12_Pm6_LabelRect=CGRectMake(130,365,90,15);
        UILabel *Pm12_Pm6_Label=[[UILabel alloc] initWithFrame:Pm12_Pm6_LabelRect];
        Pm12_Pm6_Label.textAlignment=UITextAlignmentLeft;
        Pm12_Pm6_Label.text=[NSString stringWithFormat:@"12pm - 6pm"];
        Pm12_Pm6_Label.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        Pm12_Pm6_Label.textColor=[SoclivityUtilities returnTextFontColor:1];
        Pm12_Pm6_Label.tag=kPm12_Pm6;
        Pm12_Pm6_Label.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:Pm12_Pm6_Label];
        [Pm12_Pm6_Label release];
        
#endif        
        UIImageView *timeVerticalDividerImageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_timeVerticalDivider.png"]];
        timeVerticalDividerImageView2.frame=CGRectMake(220, 335, 2, 41);
        [filterPaneView addSubview:timeVerticalDividerImageView2];
        [timeVerticalDividerImageView2 release];
        
        UIButton *eveningButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        eveningButton.frame =CGRectMake(240,325,90,53);
        eveningButton.tag=kEveningButton;
        [eveningButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [filterPaneView addSubview:eveningButton];
        
        UIImageView *moonSelectedImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_moonSelected.png"]];
        moonSelectedImageView.frame=CGRectMake(255, 325, 13, 15);
        moonSelectedImageView.tag=kMoonSelectedImage;
        [filterPaneView addSubview:moonSelectedImageView];
        [moonSelectedImageView release];
        
        CGRect eveningLabelRect=CGRectMake(245,345,90,15);
        UILabel *eveningLabel=[[UILabel alloc] initWithFrame:eveningLabelRect];
        eveningLabel.textAlignment=UITextAlignmentLeft;
        eveningLabel.text=[NSString stringWithFormat:@"Evening"];
        eveningLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        eveningLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        eveningLabel.tag=kEveningText;
        eveningLabel.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:eveningLabel];
        [eveningLabel release];
        
        CGRect Pm7_Pm11_LabelRect=CGRectMake(230,365,90,15);
        UILabel *Pm7_Pm11_Label=[[UILabel alloc] initWithFrame:Pm7_Pm11_LabelRect];
        Pm7_Pm11_Label.textAlignment=UITextAlignmentLeft;
        Pm7_Pm11_Label.text=[NSString stringWithFormat:@"7pm - 11pm"];
        Pm7_Pm11_Label.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        Pm7_Pm11_Label.textColor=[SoclivityUtilities returnTextFontColor:1];
        Pm7_Pm11_Label.tag=kPm7_Pm11;
        Pm7_Pm11_Label.backgroundColor=[UIColor clearColor];
        [filterPaneView addSubview:Pm7_Pm11_Label];
        [Pm7_Pm11_Label release];




        

        
#if 0        
                
        
        UIButton *learnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        learnButton.frame = CGRectMake(258,72, 62.0, 30.0);
        learnButton.tag=kLearnActivity;
        
        if(SOC.filterObject.learnAct)
        [learnButton setImage:[UIImage imageNamed:@"S4.1_learn-selected.png"] forState:UIControlStateNormal];
        else
            [learnButton setImage:[UIImage imageNamed:@"S4.1_learn-deselect.png"] forState:UIControlStateNormal];
        
        [learnButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:learnButton];
        
        
                
     
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
      
        rangeSlider=[[FCRangeSlider alloc]initWithFrame:CGRectMake(58.5, 48, 198, 7)];
        [timeBackgroundImageView addSubview:rangeSlider];
        [rangeSlider setThumbImage:[UIImage imageNamed:@"S4.1_scroll-ball.png"] forState:UIControlStateHighlighted];
        [rangeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

        [backgroundView addSubview:timeBackgroundImageView];
        [timeBackgroundImageView release];
        [filterPaneView addSubview:backgroundView];
        [backgroundView release];

 
      
#endif        
        UIButton *searchHandleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        searchHandleButton.frame = CGRectMake(5, 398.0, 58.0, 58.0);
        [searchHandleButton setImage:[UIImage imageNamed:@"S04_bookmark.png"] forState:UIControlStateNormal];
        [searchHandleButton addTarget:self action:@selector(pushTodetailActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchHandleButton];
        
        
        
        UIView *dateCalendarView=[[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, 402)];
        dateCalendarView.backgroundColor=[UIColor whiteColor];
        
        UIImageView *titleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_titlebar.png"]];
        titleImageView.frame=CGRectMake(0, 40, 320, 44);
        [dateCalendarView addSubview:titleImageView];
        [titleImageView release];
        
        
        UIButton *backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        backButton.frame = CGRectMake(15, 47, 38.0, 30.0);
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
            SOC.filterObject.eatAct=!SOC.filterObject.eatAct;
            if(SOC.filterObject.eatAct){
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
            SOC.filterObject.seeAct=!SOC.filterObject.seeAct;
            if(SOC.filterObject.seeAct){
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
            SOC.filterObject.createAct=!SOC.filterObject.createAct;
            if(SOC.filterObject.createAct){
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
            SOC.filterObject.learnAct=!SOC.filterObject.learnAct;
            if(SOC.filterObject.learnAct){
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
            SOC.filterObject.whenSearchType=1;
            [(UILabel*)[self viewWithTag:kNextTwoDaysText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kNextTwoDaysTickImage]setAlpha:1.0f];
            [(UILabel*)[self viewWithTag:kNextSevenDaysText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kNextSevenDaysTickImage]setAlpha:0.3f];
            [(UILabel*)[self viewWithTag:kPickADayText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kPickADayTickImage]setAlpha:0.3f];

            
         }
            break;
            
        case kNextSevenDays:
        {
            SOC.filterObject.whenSearchType=2;
            [(UILabel*)[self viewWithTag:kNextTwoDaysText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kNextTwoDaysTickImage]setAlpha:0.3f];
            [(UILabel*)[self viewWithTag:kNextSevenDaysText] setAlpha:1.0f];
            [(UIImageView*)[self viewWithTag:kNextSevenDaysTickImage]setAlpha:1.0f];
            [(UILabel*)[self viewWithTag:kPickADayText] setAlpha:0.3f];
            [(UIImageView*)[self viewWithTag:kPickADayTickImage]setAlpha:0.3f];

        }
            break;
            
        case kPickADay:
        {
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
            [(UILabel*)[self viewWithTag:kAm12_Am11] setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kMorningText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kSunriseImage]setImage:[UIImage imageNamed:@"S04.1_sunriseUnselected.png"]];
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
                [(UILabel*)[self viewWithTag:kPm12_Pm6] setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kAfternoonText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kSunSelectedImage]setImage:[UIImage imageNamed:@"S04.1_sunUnselected.png"]];
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
                [(UILabel*)[self viewWithTag:kPm7_Pm11] setAlpha:1.0f];
            }
            else{
                [(UILabel*)[self viewWithTag:kEveningText] setAlpha:0.3f];
                [(UIImageView*)[self viewWithTag:kMoonSelectedImage]setImage:[UIImage imageNamed:@"S04.1_moonUnselected.png"]];
                [(UILabel*)[self viewWithTag:kPm7_Pm11] setAlpha:0.3f];
                
            }
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
	
    self.homeSearchBar.showsCancelButton = YES;
    for (UIView *subview in [self.homeSearchBar subviews]) {
        UIButton *cancelButton = nil;
        if([subview isKindOfClass:[UIButton class]]){
            cancelButton = (UIButton*)subview;
        }
        if (cancelButton){
            NSLog(@"cancelButton");
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"S04.1_cancel.png"] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"S04.1_cancelPressed.png"] forState:UIControlStateHighlighted];
            }   
        }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    self.homeSearchBar.showsCancelButton = NO;
     [self.homeSearchBar resignFirstResponder];
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
     self.homeSearchBar.showsCancelButton = NO;
    [self.homeSearchBar resignFirstResponder];
}

@end
