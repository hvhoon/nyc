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
-(void)PushToDetailActivityView:(InfoActivityClass*)detailedInfo;
@end


@interface ActivityListView : UIView<UITableViewDataSource,UITableViewDelegate,SectionHeaderViewDelegate,PDTTableViewCellDelegate>{
    
    IBOutlet UITableView* tableView;
    NSArray *plays;
    id <ActivityListViewDelegate>delegate;
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
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
@property (nonatomic,retain)id <ActivityListViewDelegate>delegate;

-(void)LoadTable;
- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
- (void)startPopulatingListView;
@end