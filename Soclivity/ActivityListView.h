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
@interface ActivityListView : UIView<UITableViewDataSource,UITableViewDelegate,SectionHeaderViewDelegate,PDTTableViewCellDelegate>{
    
    IBOutlet UITableView* tableView;
    NSArray *plays;
    
}
@property (nonatomic, retain) NSArray *plays;
@property(nonatomic,retain)UITableView *tableView;
- (void)setUpActivityDataList;
@end
