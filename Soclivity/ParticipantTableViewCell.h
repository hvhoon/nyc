//
//  ParticipantTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"

@interface ParticipantTableViewCell : ABTableViewCell{
    
    NSString *nameText;
    UIImage *profileImage;
    BOOL noSeperatorLine;
}
@property (nonatomic,retain) NSString *nameText;
@property (nonatomic,retain)UIImage *profileImage;
@property (nonatomic,assign)BOOL noSeperatorLine;
@end
