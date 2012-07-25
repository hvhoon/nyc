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
-(void)ApproveRejectSelection:(NSIndexPath*)indexP request:(BOOL)request;
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
    NSIndexPath *indexPath;
    id <ParticipantTableViewCellDelegate>delegate;
}
@property (nonatomic,retain) NSString *nameText;
@property (nonatomic,retain)UIImage *profileImage;
@property (nonatomic,assign)BOOL noSeperatorLine;
@property (nonatomic,retain)UIImage *leftCrossImage;
@property (nonatomic,retain)UIImage *rightCrossImage;
@property (nonatomic,assign)NSInteger relationType;
@property (nonatomic,retain) UIImage*dosConnectionImage;
@property (nonatomic,retain)NSIndexPath *indexPath;
@property (nonatomic,retain)id <ParticipantTableViewCellDelegate>delegate;
@end
