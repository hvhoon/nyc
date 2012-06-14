//
//  SOCTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"
#import "InfoActivityClass.h"

@protocol PDTTableViewCellDelegate <NSObject>

@optional
-(void)DisclosureArrowClicked;
@end

@interface SOCTableViewCell : ABTableViewCell{
    id <PDTTableViewCellDelegate> delegate;
    InfoActivityClass *playActivity;
}

@property (nonatomic,retain)id <PDTTableViewCellDelegate> delegate;
@property (nonatomic, retain) InfoActivityClass *playActivity;
@end
