//
//  ActivityListView.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
#import "SOCTableViewCell.h"
@class InfoActivityClass;
@protocol ActivityListViewDelegate <NSObject>

@optional
-(void)PushToDetailActivityView:(InfoActivityClass*)detailedInfo andFlipType:(NSInteger)andFlipType;
-(void)RefreshFromTheListView;
-(void)PushToProfileView:(InfoActivityClass*)detailedInfo;

@end


@interface ActivityListView : UIView<UITableViewDataSource,UITableViewDelegate,SectionHeaderViewDelegate,PDTTableViewCellDelegate>{
    
    IBOutlet UITableView* tableView;
    NSArray *plays;
    id <ActivityListViewDelegate>delegate;
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
    NSInteger sortType;
    BOOL sectionOpenClose;
    BOOL listRefresh;
    int spinnerIndex;
    BOOL isOrganizerList;
}

@property (nonatomic, retain) NSArray *plays;
@property(nonatomic,retain)UITableView *tableView;
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, retain) UIImageView *topDivider;
@property (nonatomic,assign)NSInteger sortType;
@property (nonatomic,retain)id <ActivityListViewDelegate>delegate;
@property (nonatomic,assign)BOOL isOrganizerList;
-(void)LoadTable;
-(void)mannualToogleBetweenActivities;
- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
- (void)startPopulatingListView;
-(void)SortByDistance;
-(void)sortByDegree;
-(void)sortingFilterRefresh;
-(void)SortByTime;
-(void)doFilteringByActivities;
-(void)BytesDownloadedTimeToHideTheSpinner;
-(void)populateEvents:(NSArray*)listArray;
@end
NS_INLINE NSComparisonResult FilterSorting(NSString *s1, NSString *s2) {
    return [s1 compare:s2];
}