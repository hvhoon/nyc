//
//  ParticipantTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"


@protocol ParticipantTableViewCellDelegate <NSObject>

@optional
-(void)ApproveRejectSelection:(NSIndexPath*)indexPath request:(BOOL)request;
-(void)removeCrossButton:(NSIndexPath*)indexPath;
-(void)pushToUserProfileView:(NSIndexPath*)indexPath;
@end


@interface ParticipantTableViewCell : ABTableViewCell{
    
    NSString *nameText;
    UIImage *profileImage;
    BOOL noSeperatorLine;
    CGRect approveRect;
    CGRect rejectRect;
    UIImage *leftCrossImage;
    UIImage *rightCrossImage;
    NSInteger relationType;
    UIImage*dosConnectionImage;
    NSIndexPath *cellIndexPath;
    id <ParticipantTableViewCellDelegate>delegate;
    BOOL swiped;
    CGRect profileImageP;
    CGRect nameLabelRectP;
}
@property (nonatomic,retain) NSString *nameText;
@property (nonatomic,retain)UIImage *profileImage;
@property (nonatomic,assign)BOOL noSeperatorLine;
@property (nonatomic,retain)UIImage *leftCrossImage;
@property (nonatomic,retain)UIImage *rightCrossImage;
@property (nonatomic,assign)NSInteger relationType;
@property (nonatomic,retain) UIImage*dosConnectionImage;
@property (nonatomic,retain)NSIndexPath *cellIndexPath;
@property (nonatomic,assign)BOOL swiped;
@property (nonatomic,retain)id <ParticipantTableViewCellDelegate>delegate;
@end
