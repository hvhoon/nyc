//
//  InviteUserTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"
@class InviteObjectClass;

@protocol InviteTableViewCellDelegate <NSObject>

@optional
-(void)inviteStatusUpdate:(NSIndexPath*)indexPath;
@end

@interface InviteUserTableViewCell : ABTableViewCell{
    
    UIImage*dosConnectionImage;
    NSIndexPath *cellIndexPath;
    id <InviteTableViewCellDelegate>delegate;
    BOOL noSeperatorLine;
    CGRect inviteRect;
    BOOL inviteStatus;
    NSInteger DOS;
    NSString *userName;
    NSInteger typeOfRelation;
    UIImage *profileImage;

}
@property (nonatomic,retain)id <InviteTableViewCellDelegate>delegate;
@property (nonatomic,retain)NSIndexPath *cellIndexPath;
@property (nonatomic,assign)BOOL noSeperatorLine;
@property (nonatomic,assign)BOOL inviteStatus;
@property (nonatomic,assign)NSInteger DOS;
@property (nonatomic,retain)NSString*userName;
@property (nonatomic,assign)NSInteger typeOfRelation;
@property (nonatomic,retain)UIImage*profileImage;
@end
