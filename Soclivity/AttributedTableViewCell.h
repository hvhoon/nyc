// AttributedTableViewCell.h
//

#import <UIKit/UIKit.h>

@class TTTAttributedLabel;

@interface AttributedTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *summaryText;
@property (nonatomic, retain) TTTAttributedLabel *summaryLabel;
@property (nonatomic, assign) NSInteger hashCount;
@property (nonatomic, copy) NSString *timeText;
@property (nonatomic, retain) UILabel *lbltime;
@property (nonatomic, assign) NSInteger notifytype;

+ (CGFloat)heightForCellWithText:(NSString *)text;

@end
