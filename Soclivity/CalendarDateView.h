//
//  CalendarDateView.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView.h"       // for the KalViewDelegate protocol
#import "KalDataSource.h" // for the KalDataSourceCallbacks protocol


@class KalLogic, KalDate;
@protocol CalendarDateViewDelegate <NSObject>

@optional
-(void)pushTransformWithAnimation;
@end

@interface CalendarDateView : UIView<KalViewDelegate,KalDataSourceCallbacks>{
     id <CalendarDateViewDelegate>KALDelegate;
    KalLogic *logic;
    UITableView *tableView;
    id <UITableViewDelegate> delegate;
    id <KalDataSource> dataSource;
    NSDate *initialDate; 
    NSDate *selectedDate;
    BOOL pickADateForActivity;
    NSDate *activityTime;
}
@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<KalDataSource> dataSource;
@property (nonatomic, retain, readonly) NSDate *selectedDate;
@property (nonatomic,retain)NSDate* activityTime;
@property (nonatomic,assign)BOOL pickADateForActivity;

- (id)initWithSelectedDate:(NSDate *)selectedDate;
@property (nonatomic,retain) id <CalendarDateViewDelegate>KALDelegate;
-(IBAction)backTapped:(id)sender;
- (void)reloadData;
- (void)showAndSelectDate:(NSDate *)date;
- (id)initWithFrame:(CGRect)frame editActivityDate:(NSDate*)editActivityDate;
@end
