//
//  UIBubbleTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <UIKit/UIKit.h>
#import "ActivityChatData.h"
@interface UIBubbleTableViewCell : UITableViewCell

@property (nonatomic, strong) ActivityChatData *data;
@property (nonatomic) BOOL showAvatar;


@end
