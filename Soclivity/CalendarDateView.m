//
//  CalendarDateView.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarDateView.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "SoclivityManager.h"
#import "FilterPreferenceClass.h"
#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>

void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};
    
    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface CalendarDateView ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;
@end

@implementation CalendarDateView
@synthesize KALDelegate;
@synthesize dataSource, delegate, initialDate, selectedDate,pickADateForActivity;
@synthesize activityTime;
- (id)initWithSelectedDate:(NSDate *)date
{
    if ((self = [super init])) {
        logic = [[KalLogic alloc] initForDate:date];
        self.initialDate = date;
        self.selectedDate = date;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
    }
    return self;
}
- (id)init
{
    return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)[self viewWithTag:123]; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
    if (dataSource != aDataSource) {
        dataSource = aDataSource;
        tableView.dataSource = dataSource;
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
    if (delegate != aDelegate) {
        delegate = aDelegate;
        tableView.delegate = delegate;
    }
}

- (void)clearTable
{
    [dataSource removeAllItems];
    [tableView reloadData];
}

- (void)reloadData
{
    [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
    [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
    
    
    self.selectedDate = [date NSDate];
    NSDate *fromDate = [[date NSDate] cc_dateByMovingToBeginningOfDay];
    NSDate *toDate = [[date NSDate] cc_dateByMovingToEndOfDay];
    
    if(pickADateForActivity){
     
        
        NSDate *dateToSet = [date NSDate];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:activityTime];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];

        
        NSCalendar* myCalendar = [NSCalendar currentCalendar];
        components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                   fromDate:dateToSet];
        [components setHour: hour];
        [components setMinute:minute];
        [components setSecond:00];
        NSDate *setFinishDate=[myCalendar dateFromComponents:components];
        
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSInteger destinationGMTOffset1 = [destinationTimeZone secondsFromGMTForDate:dateToSet];
        NSInteger destinationGMTOffset2 = [destinationTimeZone secondsFromGMTForDate:[NSDate date]];
        
        NSTimeInterval interval2 = destinationGMTOffset1;
        NSTimeInterval interval3 = destinationGMTOffset2;
        
        NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval2 sinceDate:setFinishDate] autorelease];
        
        NSDate* currentDateTime = [[[NSDate alloc] initWithTimeInterval:interval3 sinceDate:[NSDate date]] autorelease];
        BOOL checkTime=TRUE;


        
        if ([destinationDate compare:currentDateTime] == NSOrderedAscending){
            checkTime=FALSE;
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Activity in the past?"
															message:@"Sorry we can't go in the past yet!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
			[alert show];
			[alert release];
			return;

        }
        else{
            checkTime=TRUE;
            
            [[NSUserDefaults standardUserDefaults] setValue:dateToSet forKey:@"ActivityDate"];

        }

        
        
        
        


    }
    else{

    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    NSLog(@"didSelectDate =%@",[date NSDate]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     
    [dateFormatter setDateFormat:@"EEE, MMM d"];
    NSString *formattedDateString = [dateFormatter stringFromDate:[date NSDate]];

    [dateFormatter release];
    SOC.filterObject.startPickDateTime=fromDate;
    SOC.filterObject.endPickDateTime=toDate;
    SOC.filterObject.pickADateString=[NSString stringWithFormat:@"%@",formattedDateString];
    }

    [self clearTable];
    [dataSource loadItemsFromDate:fromDate toDate:toDate];
    [tableView reloadData];
    [tableView flashScrollIndicators];
}


- (void)showPreviousMonth
{
    [self clearTable];
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
    [self reloadData];
}

- (void)showFollowingMonth
{
    [self clearTable];
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
    [self reloadData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
    for (int i=0; i<[dates count]; i++)
        [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
    
    [[self calendarView] markTilesForDates:dates];
    [self didSelectDate:self.calendarView.selectedDate];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
#if PROFILER
    uint64_t start, end;
    struct timespec tp;
    start = mach_absolute_time();
#endif
    
    [[self calendarView] jumpToSelectedMonth];
    
#if PROFILER
    end = mach_absolute_time();
    mach_absolute_difference(end, start, &tp);
    printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
    
    [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
    [self reloadData];
}

- (NSDate *)selectedDate
{
    return [self.calendarView.selectedDate NSDate];
}

- (id)initWithFrame:(CGRect)frame editActivityDate:(NSDate*)editActivityDate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        {
            logic = [[KalLogic alloc] initForDate:editActivityDate];
            self.initialDate = editActivityDate;
            self.selectedDate = editActivityDate;

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];

            
            KalView *kalView = [[[KalView alloc] initWithFrame:CGRectMake(0, 0, 320, 304) delegate:self logic:logic] autorelease];
            kalView.tag=123;
            [self  addSubview:kalView];
            
            [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
             tableView.backgroundColor=[UIColor whiteColor];
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            tableView.bounces=NO;
            [self reloadData];
            
        }

    }
    return self;
}
-(IBAction)backTapped:(id)sender{
    [KALDelegate pushTransformWithAnimation];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
    [initialDate release];
    [selectedDate release];
    [logic release];
    [tableView release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
