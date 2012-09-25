//
//  UpComingCompletedEventsViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
#import "SOCTableViewCell.h"
@class InfoActivityClass;

@protocol UpcomingCompletedEvnetsViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface UpComingCompletedEventsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SectionHeaderViewDelegate,PDTTableViewCellDelegate>{
    id <UpcomingCompletedEvnetsViewDelegate>delegate;
    IBOutlet UILabel *activititesLabel;
    IBOutlet UIButton *organizedButton;
    IBOutlet UIButton *goingButton;
    IBOutlet UIButton *completedButton;
    IBOutlet UITableView *activityListView;
    NSArray *plays;
    UIView *refreshHeaderView;
    UILabel *lastUpdateLabel;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    NSInteger filterType;
    BOOL sectionOpenClose;
    BOOL listRefresh;
    int spinnerIndex;

}
@property (nonatomic,retain)id <UpcomingCompletedEvnetsViewDelegate>delegate;
@property (nonatomic,retain) UITableView *activityListView;
@property (nonatomic, retain) NSArray *plays;
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, retain) UIImageView *topDivider;

-(IBAction)profileSliderPressed:(id)sender;
-(IBAction)organizedButtonPressed:(id)sender;
-(IBAction)goingButtonPressed:(id)sender;
-(IBAction)completedButtonPressed:(id)sender;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
-(void)BytesDownloadedTimeToHideTheSpinner;

@end
