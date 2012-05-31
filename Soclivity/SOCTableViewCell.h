//
//  SOCTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"
#import "DetailInfoActivityClass.h"

@protocol PDTTableViewCellDelegate <NSObject>

@optional
-(void)DisclosureArrowClicked;
@end

@interface SOCTableViewCell : ABTableViewCell{
    id <PDTTableViewCellDelegate> delegate;
    DetailInfoActivityClass *quotation;
}

@property (nonatomic,retain)id <PDTTableViewCellDelegate> delegate;
@property (nonatomic, retain) DetailInfoActivityClass *quotation;
@end
