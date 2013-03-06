//
//  UIBubbleHeaderFooterTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <UIKit/UIKit.h>

@interface UIBubbleHeaderFooterTableViewCell : UITableViewCell

+ (CGFloat)height;
+(CGFloat)heightForName;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign)NSInteger bubbleType;
@end
